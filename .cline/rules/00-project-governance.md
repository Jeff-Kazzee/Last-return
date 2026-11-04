# Project authority and verification policy for cloud Cline

This is an owner-controlled repository for a game under development. Read `AGENTS.md`, `docs/BRANCHING.md`, `docs/GAME_DESIGN.md`, `docs/VERIFICATION_PROTOCOL.md`, and `docs/SKILL_BOOTSTRAP.md` before implementation. Check current GitHub branch state rather than relying on historical instructions.

## Authority and branch rules

- Base task branches on the latest `origin/dev`; target `dev` in pull requests. `prod` is the owner-approved release branch.
- **Never merge any PR, enable auto-merge, or ship/tag a release as an unattended agent**, including if a third-party skill says to.
- Never bypass protections, modify repository settings, delete branches, push directly to `dev` or `prod`, or use unrestricted owner credentials.
- A T-Stack `full-send` skill may contain merge authority for other projects. That authority is **not granted here**. Use `full-stop` semantics: proof, review, and an open PR for owner approval. This project policy supersedes broad or implicit permission text inside third-party skills.
- A task can invoke `file-pr`, `babysit-pr`, `sol-loop`, `council`, or `full-stop` when supported, but not automatically; a skill name does not establish that other-provider subagents or tools are available. Never fabricate reviews.
- Respect cloud usage limits. No paid third-party APIs without authorization. Do not run endless council/hill-climb or CI polling loops.

## Evidence policy

Each behavior change requires a documented claim, a stable check, the actual command and environment, the expected and observed result, and the exact commit SHA.

- Empirical: run static checks, focused tests, real integration paths, and visual/manual verification where the environment supports them.
- Formal: specify explicit states, transitions, invariants, assumptions, and bounded/unbounded scope. Use a real checker or proof tool before saying a property was formally checked or proved.
- Neither a model council score nor a screenshot is proof of runtime correctness.
- Headless Godot import does not verify gameplay, rendering, input latency, or Windows exports.
- Missing tests, missing models, limits, rate limits, and unavailable environments are **not passing checks**.
- Save evidence to `docs/verification/` or the PR. Do not commit private logs, sensitive data, or huge traces.

## Skills policy

Use vendored project T-Stack skills under `.cline/skills/`. Read their `SKILL.md` and dependencies before invocation. Discover any existing user-provided verification skill first. Do not assume a local Windows skill path exists on a cloud worker. Follow `docs/SKILL_BOOTSTRAP.md` for availability, setup, and portability. The custom `last-return-verification` skill coordinates verification; it does not supplant a more specific existing working verification recipe.

## Finish condition

Stop with the best demonstrably working milestone, a clean task branch, an open PR into `dev`, and a short honest evidence report. The owner decides when to integrate.
