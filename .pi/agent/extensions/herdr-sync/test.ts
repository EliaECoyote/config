import assert from "node:assert/strict";
import { renameCandidates, sanitizeName } from "./index.ts";

// sanitizeName
assert.equal(sanitizeName("polling-&-enrichment"), "polling-enrichment");
assert.equal(sanitizeName("fix-TI-URL"), "fix-ti-url");
assert.equal(sanitizeName("already-clean"), "already-clean");
assert.equal(sanitizeName("with_underscore"), "with_underscore");
assert.equal(sanitizeName("  spaces   and   gaps  "), "spaces-and-gaps");
assert.equal(sanitizeName("leading-digits-123abc"), "leading-digits-123abc");
assert.equal(sanitizeName("123-starts-with-digits"), "starts-with-digits");
assert.equal(sanitizeName("-leading-hyphen"), "leading-hyphen");
assert.equal(sanitizeName("trailing-hyphen-"), "trailing-hyphen");
assert.equal(sanitizeName("trailing-underscore_"), "trailing-underscore");
assert.equal(sanitizeName("multiple---hyphens"), "multiple-hyphens");
assert.equal(sanitizeName("only-specials!!!"), "only-specials");
assert.equal(sanitizeName("123456"), undefined);
assert.equal(sanitizeName("!!!"), undefined);
assert.equal(sanitizeName(""), undefined);

const long = "a" + "b".repeat(40);
assert.equal(sanitizeName(long)?.length, 32);
assert.ok(sanitizeName(long)?.match(/^[a-z][a-z0-9_-]{0,31}$/));

// truncate-then-trim: the char at position 32 is a hyphen
const hyphenTail = "a".repeat(31) + "-x";
assert.equal(sanitizeName(hyphenTail), "a".repeat(31));
assert.ok(!sanitizeName(hyphenTail)?.endsWith("-"));

// renameCandidates
assert.deepEqual(renameCandidates("polling & enrichment"), ["polling-enrichment", "polling-enrichment-2", "polling-enrichment-3", "polling-enrichment-4", "polling-enrichment-5"]);
assert.deepEqual(renameCandidates("123456"), []);
assert.deepEqual(renameCandidates(""), []);

const exact32 = "a".repeat(32);
const suffixed = renameCandidates(exact32);
assert.equal(suffixed[0], exact32);
assert.equal(suffixed[1], "a".repeat(30) + "-2");
assert.ok(suffixed.every((c) => c.length <= 32 && c.match(/^[a-z][a-z0-9_-]{0,31}$/)));

const exact31 = "a".repeat(31);
assert.equal(renameCandidates(exact31)[1], "a".repeat(30) + "-2");

console.log("herdr-sync tests passed");
