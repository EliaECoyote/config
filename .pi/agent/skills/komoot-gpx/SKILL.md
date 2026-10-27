---
name: komoot-gpx
description: Download a Komoot tour as a GPX file to ~/Downloads with the komootgpx CLI. Use when the user shares a komoot.com tour link or tour ID, or asks for the GPX file of a Komoot tour.
---

# Komoot GPX

Download a Komoot tour as a GPX file, from the tour URL or tour ID that the user gave. If the user gave neither, ask for a Komoot tour URL or tour ID.

## Step 1: Extract the tour ID

| Input | Tour ID |
|-------|---------|
| `https://www.komoot.com/tour/3193494509` | `3193494509` |
| `https://www.komoot.com/en/tour/3193494509` | `3193494509` |
| `https://www.komoot.com/de/tour/3193494509` | `3193494509` |
| `https://www.komoot.com/user/12345/tour/3193494509` | `3193494509` |
| `3193494509` | `3193494509` |

The tour ID is the long number after `/tour/` in the URL. If the user gave a bare number, use it as the ID.

## Step 2: Download the GPX

Run this command on one line, with the tour ID in place of `<tour_id>`:

```bash
komootgpx --anonymous --make-gpx=<tour_id> --output ~/Downloads
```

If `komootgpx` is not on `PATH`, run it through uv:

```bash
uv run komootgpx --anonymous --make-gpx=<tour_id> --output ~/Downloads
```

## Step 3: Confirm the download

List the newest GPX files in `~/Downloads` and check that the new file is there:

```bash
ls -lt ~/Downloads/*.gpx | head -5
```

Report the file name and the full path to the user.

## Notes

- `--anonymous` needs no login and works for any public tour.
- The file name pattern is `{title}-{id}.gpx`, for example `Morning_Ride-3193494509.gpx`.
- For a private tour, `--anonymous` fails. Ask the user for their Komoot email and password, and run the command with `-m <email> -p <password>` instead of `--anonymous`.
- A `RequestsDependencyWarning` about urllib3 or chardet versions can appear on stderr. It does not affect the download.
- If the user wants the file in a different folder, change the `--output` path.
