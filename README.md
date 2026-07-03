# SquadPing

SquadPing is a Flutter iOS app for small groups that need quick check-ins,
meetup cutoffs, and clear reply rhythm before plans get scattered.

The current build focuses on three lanes:

- Pulse: active group loops, readiness, and rally windows.
- Roster: member availability signals and preferred nudge style.
- Ping: a small drafting surface for choosing tone, recipient, and message.

The Dart code is split by product area under `lib/features`, with business
models and seeded content kept under `lib/field_notes`.
