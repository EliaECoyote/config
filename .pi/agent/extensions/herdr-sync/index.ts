import net from "node:net";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const socketPath = process.env.HERDR_SOCKET_PATH;
const paneId = process.env.HERDR_PANE_ID;
const source = "pi-herdr-sync";

const MAX_CANDIDATES = 5;
const MAX_NAME_LENGTH = 32;

type RpcResponse = { error?: { code?: string; message?: string } };

function send(method: string, params: Record<string, unknown>): Promise<RpcResponse | undefined> {
	return new Promise((resolve) => {
		let done = false;
		let buffer = "";
		let timeout: ReturnType<typeof setTimeout> | undefined;
		const finish = (result?: RpcResponse) => {
			if (done) return;
			done = true;
			if (timeout) clearTimeout(timeout);
			socket.destroy();
			resolve(result);
		};

		const socket = net.createConnection(socketPath!);
		socket.on("error", () => finish());
		socket.on("connect", () =>
			socket.write(
				`${JSON.stringify({
					id: `${source}:${Date.now()}:${Math.random()}`,
					method,
					params,
				})}\n`,
			),
		);
		socket.on("data", (chunk) => {
			buffer += chunk.toString("utf8");
			const newline = buffer.indexOf("\n");
			if (newline !== -1) {
				try {
					finish(JSON.parse(buffer.slice(0, newline)));
				} catch {
					finish();
				}
			}
		});
		socket.on("end", () => finish());
		timeout = setTimeout(finish, 1500);
		timeout.unref?.();
	});
}

export function sanitizeName(name: string): string | undefined {
	const cleaned = name
		.toLowerCase()
		.replace(/[^a-z0-9_-]+/g, "-")
		.replace(/-{2,}/g, "-")
		.replace(/^[^a-z]+/, "")
		.replace(/[-_]+$/, "")
		.slice(0, MAX_NAME_LENGTH)
		.replace(/[-_]+$/, "");
	return cleaned || undefined;
}

export function renameCandidates(raw: string): string[] {
	const base = sanitizeName(raw);
	if (!base) return [];
	const candidates = [base];
	for (let i = 2; candidates.length < MAX_CANDIDATES; i++) {
		const suffix = `-${i}`;
		const trimmed = base.slice(0, MAX_NAME_LENGTH - suffix.length).replace(/[-_]+$/, "");
		candidates.push(trimmed + suffix);
	}
	return candidates;
}

type Ctx = {
	mode?: string;
	sessionManager?: { getSessionFile?: () => string | undefined };
};

export default function (pi: ExtensionAPI) {
	if (process.env.HERDR_ENV !== "1" || !socketPath || !paneId) return;

	let rootSessionFile: string | undefined;

	const rename = async (name: string | undefined): Promise<void> => {
		if (!name) {
			await send("agent.rename", { target: paneId, name: null });
			return;
		}
		for (const candidate of renameCandidates(name)) {
			const response = await send("agent.rename", { target: paneId, name: candidate });
			if (!response?.error) return;
			if (response.error.code !== "agent_name_taken") return;
		}
	};

	// Herdr drops empty rows, but a $spacer token reported with a zero-width
	// space keeps the row alive while rendering blank.
	const reportSpacer = async (): Promise<void> => {
		await send("pane.report_metadata", {
			pane_id: paneId,
			source,
			tokens: { spacer: "\u200b" },
		});
	};

	pi.on("session_start", async (_event, ctx) => {
		if (ctx.mode !== "tui") return;
		rootSessionFile = ctx.sessionManager?.getSessionFile?.();
		await rename(pi.getSessionName());
		await reportSpacer();
	});

	pi.on("session_info_changed", async (event, ctx) => {
		// Subagent children run in this process too; only the interactive root session owns the pane.
		if (ctx.mode !== "tui" || ctx.sessionManager?.getSessionFile?.() !== rootSessionFile) return;
		await rename(event?.name);
	});
}
