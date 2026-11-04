# Agent instructions for Last Return

This repository is a **game under development**, not a completed game. Read `docs/GAME_DESIGN.md` and `docs/CLINE_OVERNIGHT_PROMPT.md` before implementing.

## Product constraints
- Core skill: read and return a moving projectile. Duels, breaches, and bosses must reuse that skill.
- Godot 4.x / GDScript; target Windows first; permit headless Linux tests.
- Fast, physically fair arcade play, deterministic tests, readable feedback, accessible visual cues, no forced internet connection.
- Distinguish design ambitions (64 campaign encounters; 3,072 optional trials) from verified/implemented features.
- Never replace deliberate challenge design with palette-swap inflation. A trial must change actual tactics.
- Licensed/approved AI-assisted art is curated during production; do not generate at runtime.

## Workflow / ownership
- Follow Jeff's machine Git law where available. Last Return uses `dev` as the default branch and the task prefixes in `docs/BRANCHING.md`. Use one branch and one writer per task.
- Do not force-push, bypass CI/review gates, merge without owner approval, delete existing content, or commit credentials.
- Before introducing new dependencies, assess necessity, size, license, supply-chain integrity, and offline compatibility.
- Commit small coherent units; document observed commands/results and unverified GUI behavior in `docs/PROGRESS.md`.
- Test core physical invariants, goal attribution, reset/pause semantics, and rival movement before polishing or expanding.
- If a tool cannot verify a claim, state that; do not fabricate screenshots, tests, timings, or benchmarks.

## Branches and release flow

Read [branching policy](docs/BRANCHING.md) and the [release checklist](docs/RELEASE_CHECKLIST.md). Start normal work from `dev` and open a reviewed PR back to `dev`. Use a short-lived task branch. The repository has no `main` branch.

Only the owner merges PRs. Promote `dev` to `prod` through an owner-approved release PR. Start emergency `hotfix/*` branches from `prod`, target `prod`, and reconcile the fix into `dev` through a separate PR.

Record the candidate SHA, test commands, results, and any skipped checks before integration. The repository guard checks branch direction and basic hygiene. Report Godot tests and playtests separately.
