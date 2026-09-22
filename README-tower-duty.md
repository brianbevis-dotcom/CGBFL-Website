# CGBFL Tower Duty — 2026

Coaches find their tower assignments and download a calendar invite. The board edits the
schedule from inside the app.

Built from `2026_CGBFL_Tower_Duty_Schedule.xlsx` (140 regular-season games, Aug 1 - Sep 14) plus
`CGBFL_Tackle_TowerDuty_2026.xlsx` (25 playoff games, Sep 21 - Oct 3), merged into one schedule:
**165 games, 29 duty entries, spanning three months.**

Seven playoff games (both play-in rounds and the two "TBD bracket seed" games) have no team on
the tower — the duty cell reads "CGBFL Board Member" instead. Those are grouped under a synthetic
"Board" bucket so they behave like any other team's assignments (one entry, its own tickets, its
own print sheet), without polluting the Full Schedule or Admin division filters, which stay
Rookie/Minor/Major only. Some late-round matchups aren't decided yet, so a handful of games show
bracket placeholders (M1-M12, J1-J6, R3-R4) for Home/Away exactly as the league's sheet has them —
worth a follow-up pass through Admin to fill in real team names once brackets are set.

---

## What's in the drop

| File | What it is |
|---|---|
| `tower-duty.html` | The whole app. Single file, no build step, no token. |
| `tower-duty-2026.json` | The schedule, venue, coach names, and timing settings. |

Subscribable calendar feeds are gone, along with `generate_ics.py` and the `ics/` folder.
Everything is a download now, generated in the browser at the moment a coach taps the button.

---

## Deploy

1. Copy `tower-duty.html` and `tower-duty-2026.json` into `CGBFL-Website/tower-duty/` on `main`.

2. Set `WORKER_URL` at the top of the script block in `tower-duty.html`:

   ```js
   var WORKER_URL = 'https://your-worker.workers.dev';
   ```

   Trailing slash is fine — the code strips it.

3. **Add `tower-duty-2026.json` to the Worker's `ALLOWED_FILES`.** Without this, every publish
   fails with a 403. The app names this specific cause in the error, but it is still the easiest
   step to forget.

   If your Worker is branch-aware (most of the CGBFL apps are), it also needs `GITHUB_BRANCH` in
   `tower-duty.html` to match the branch GitHub Pages actually serves — `'main'` by default. This
   app reads with `?ref={branch}` and writes with `branch` in the PUT body, same as ProBowl, Camp
   Check-In, and Trojans Command Center. If a publish reports success but the live page never
   changes, this mismatch is the first thing to check — the commit likely landed on a different
   branch than the one being served.

4. Embed on SportsEngine with a Code Element containing **only** an iframe:

   ```html
   <iframe src="https://brianbevis-dotcom.github.io/CGBFL-Website/tower-duty/tower-duty.html"
           style="width:100%;height:1400px;border:0" title="Tower Duty Schedule"></iframe>
   ```

If you skip step 2, everything a coach sees still works. Only the Admin tab changes: instead of
publishing, it hands you the edited JSON to commit yourself.

---

## The five tabs

**My Duty** — coach picks division and team, gets their five assignments as game-day tickets with
the next one flagged. Each ticket has an `.ics` download and a Google Calendar link; one button
below grabs all five at once.

**Full Schedule** — all 140 games, filterable by field, division, tower team, or free text. Every
row has its own `.ics` button.

**Calendar** — month grid showing time, field, matchup, and the team on the tower (▲). Highlight
one team to make their duties jump out in red, or narrow to a single field.

**Print** — one-page team duty sheet with an *Initials* column for sign-off, the month calendar,
or the full schedule list.

**Admin** — password `CGBFL1969`.

---

## Admin

Everything you edit lands in a working copy. Nothing reaches the league until you hit
**Publish changes**, so you can back out of a session cleanly.

**Season settings** — status label (the header badge and every printout), report-early minutes,
event length, venue name, and venue address. *The address is still blank in the JSON; fill it in
and event locations become tappable for directions on every coach's phone.*

**Games** — every game as an editable row. Change the date and the day name follows automatically.
Kickoff accepts whatever you type — `6:00 PM`, `6pm`, `1830`, `18:00` — and normalizes it; anything
it can't read is rejected and the old value comes back. Field, division, and tower duty team are
dropdowns built from the schedule itself. Rows you've touched turn amber, rows you've added turn
green, so you can see your session's footprint at a glance. The filter box narrows 140 rows to the
handful you're working on.

**Coach on duty** — one name field per duty team. A name here shows on that team's tickets,
printouts, and inside the calendar invite.

### Before it publishes

The app refuses to publish and tells you what's wrong when it finds:

- a malformed date or kickoff time
- a game missing a home team, away team, or duty assignment
- duplicate game ids
- **two games on the same field at the same time** — a real scheduling error worth catching before
  parents see it

On publish it also re-reads the live file first. If another board member saved while your tab sat
open, you get a warning before overwriting their work rather than silently clobbering it.

### If publishing fails

**Download JSON** is always there. It hands you the exact file to commit to
`CGBFL-Website/tower-duty/tower-duty-2026.json` by hand. Use it if the Worker is down, the
allowlist hasn't been updated yet, or you'd rather review the diff in GitHub first.

### One thing to be clear about

`CGBFL1969` lives in the HTML, so anyone who views source can read it. It keeps a curious parent
from wandering into the editor — it is **not** real security. The Worker is what actually guards
writes, because it holds the GitHub token and decides which files may be written. If you ever need
genuine access control, that belongs in the Worker, not here.

---

## Calendar invites

Each downloaded event carries:

- **Title** — `Tower Duty - Minor Illinois (Moore Field)`
- **Time** — starts 15 minutes before kickoff, runs 90 minutes (both adjustable in Admin)
- **Alarms** — 1 day before and 1 hour before
- **Notes** — matchup, kickoff, field, report time, coach name if set, and the swap policy
- **Timezone** — `America/Indiana/Indianapolis`, with a full VTIMEZONE block so it lands correctly
  on every platform

UIDs are stable (`towerduty-2026-G001@cgbfl.com`), so a coach who downloads the same invite twice
gets one entry updated, not two.

**The tradeoff to know:** a downloaded `.ics` is a snapshot. When you move a game, coaches who
already downloaded it keep the old time until they download again. Worth a note in the announcement
whenever the schedule shifts.

---

## Two things worth a second look

1. **Two games have odd times in the source sheet.** `2026-08-15 Adams (Minor, Northwestern vs
   Purdue)` and `2026-08-29 Adams (Rookie, Nebraska vs Purdue)` are stored as `09:15` where every
   other Saturday slot is 9:00 / 10:30 / 12:00 / 1:30. They're read as **9:15 AM**. Fix them in the
   Admin tab if that's wrong.

2. **The schedule still reads DRAFT.** That's on the header badge and every printout. Change it in
   Admin under Season settings when it's final.

3. **Bracket placeholders need a follow-up pass.** Home/Away on several late playoff rounds are
   still seed codes (M7 vs M8, J1 vs J2, and so on) because those matchups weren't set when the
   sheet was built. Once real teams are known, update them in Admin — Home and Away are plain text
   fields on every row.

---

## Merging in a new schedule file

The Admin tab is the normal way to add or change games. For a bulk addition — a whole new sheet of
games, like the playoff round was — editing 165 rows by hand isn't it. The playoff merge here was
done with a one-off script (not included, since it's specific to that file), but the shape of it is
worth knowing for next time:

1. Read the new sheet with the same eight columns as the original (Date, Day, Time, Field,
   Division, Home, Away, Tower Duty Team).
2. Give each new row an id continuing from the highest existing `G###`.
3. Any duty cell that doesn't start with `Rookie `, `Minor `, or `Major ` (a board-covered game, or
   any other non-team duty holder) buckets under a synthetic division — `Board` was used here — so
   it still groups into one team-like entry instead of breaking the Rookie/Minor/Major assumption
   the rest of the app makes.
4. Add that bucket name to `dutyDivisions` (not `divisions` — see below) and add a coach entry for
   any brand-new duty name.
5. Check for double-bookings (same date, time, and field) across the combined list before saving —
   the Admin tab does this automatically on every publish, but it's worth a dry run before you even
   open the file there.

**`divisions` vs `dutyDivisions`:** `divisions` is the real list of game divisions (Rookie, Minor,
Major) and drives the Full Schedule filter and the Admin per-game Division column — it should only
ever contain actual divisions games are played in. `dutyDivisions` drives the My Duty picker and can
hold extra buckets like `Board` that group duty assignments without a real team. Keep them separate:
adding `Board` to `divisions` by mistake would put a dead-end filter option into Full Schedule that
always returns zero games.

## How the data loads

The app fetches `tower-duty-2026.json` on load. A copy of the schedule is also embedded in the HTML
as a fallback for when that fetch fails. After a few rounds of admin edits that embedded copy goes
stale — harmless, since it's only used when the JSON is unreachable, but worth re-embedding once the
schedule is final if you want the fallback to be accurate.
