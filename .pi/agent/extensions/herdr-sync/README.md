# pi-herdr-sync

Renames the Herdr agent to keep it in sync with the Pi session name. The Pi
session name is authoritative: whenever it is set or changed (`/name`, RPC,
`pi.setSessionName()`), the agent label in Herdr is renamed to the exact same
string. Clearing the Pi session name clears the Herdr agent name.

Pi session names can contain characters Herdr does not allow (uppercase,
`&`, spaces in odd positions), so the name is sanitized before sending:
lowercased, invalid characters collapsed to `-`, leading non-letters
stripped, and truncated to 32 characters. Herdr also requires names to be
unique among live agents; on a collision the rename retries with a `-2`,
`-3`, ... suffix. Names that sanitize to nothing (e.g. `123`) are skipped:
the agent keeps its current Herdr name.

## How it works

Talks to the Herdr socket API (`agent.rename`) from the pane pi is running in
(`HERDR_PANE_ID`), gated on `HERDR_ENV=1` and TUI mode. Renames are only issued
for the interactive root session, so subagent children running in the same
process can't clobber the pane name.

## Install

Add to `~/.pi/agent/settings.json`:

```json
"packages": ["../../dev/pi-packages/packages/herdr-sync"]
```

then restart pi or `/reload`.
