# Agent instructions — Last Return

This repository is a **game under development**, not a completed game. Read `docs/GAME_DESIGN.md` and `docs/CLINE_OVERNIGHT_PROMPT.md` before implementing.

## Product constraints
- Core skill: read and return a moving projectile. Duels, breaches, and bosses must reuse that skill.
- Godot 4.x / GDScript; target Windows first; permit headless Linux tests.
- Fast, physically fair arcade play, deterministic tests, readable feedback, accessible visual cues, no forced internet connection.
- Distinguish design ambitions (64 campaign encounters; 3,072 optional trials) from verified/implemented features.
- Never replace deliberate challenge design with palette-swap inflation. A trial must change actual tactics.
- Licensed/approved AI-assisted art is curated during production; do not generate at runtime.

## Workflow / ownership
- Keep `main` safe. Use feature branches and PRs unless explicit owner authorization says otherwise.
- Do not force-push, bypass CI/review gates, merge without owner approval, delete existing content, or commit credentials.
- Before introducing new dependencies, assess necessity, size, license, supply-chain integrity, and offline compatibility.
- Commit small coherent units; document observed commands/results and unverified GUI behavior in `docs/PROGRESS.md`.
- Test core physical invariants, goal attribution, reset/pause semantics, and rival movement before polishing or expanding.
- If a tool cannot verify a claim, state that; do not fabricate screenshots, tests, timings, or benchmarks.
