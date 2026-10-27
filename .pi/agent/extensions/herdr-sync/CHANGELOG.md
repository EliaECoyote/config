# Changelog

## 0.2.0

- Sanitize names to Herdr's rules before renaming: lowercase, invalid
  characters collapsed to `-`, leading non-letters stripped, truncated to 32
  characters. Previously invalid names (e.g. `polling & enrichment`, `Fix TI
  URL`) were silently rejected by Herdr and the agent kept no name.
- Retry with a `-2`, `-3`, ... suffix when Herdr reports `agent_name_taken`, so
  two sessions with the same auto-generated title no longer collide silently.
- Read the RPC response instead of discarding it, so rename errors are
  actionable.

## 0.1.0

- Initial version: renames the Herdr agent to the Pi session name as-is on
  session start and on `session_info_changed`.
