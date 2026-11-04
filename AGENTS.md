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

## Empirical and formal verification (mandatory for gameplay changes)

Read [Cline skill bootstrap](docs/SKILL_BOOTSTRAP.md), [verification protocol](docs/VERIFICATION_PROTOCOL.md), and the [cloud launch instructions](docs/CLINE_VERIFIED_LAUNCH.md). The project vendors T-Stack under `.cline/skills/` (MIT, pinned upstream revision) plus a `last-return-verification` skill. Read installed instructions and verify availability before invoking; personal Windows skills or extra providers may not exist on the cloud worker.

Use the task-specific verification skill and real application recipe when present. Establish a baseline and independent expectation, implement one bounded change, exercise static/behavior/live checks, and record exact evidence and revision. For core scoring/pause/retry state, build a finite explicit transition model and actually execute bounded/exhaustive invariant checking with a known-bad mutation; test the real Godot state transitions separately. A correct model alone is not proof of the implementation. Formal claims must name model, assumptions, bounds and checker. For continuous physics, use adversarial empirical tests and explain unproven cases.

T-Stack may include `full-send`, but **this project categorically forbids unattended merging, auto-merging, bypassing review gates or production releases**. Use `full-stop` semantics and leave PRs open for owner approval. Council/sol-loop results require real reachable providers, not inferred access. Unavailable, skipped, rate-limited and headless-only checks must be labelled honestly.
