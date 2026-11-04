# Last Return

**Last Return** is a proposed atmospheric 2D arcade escape game set inside **the Interval**, a dreaming dystopian city. Play centers on reading incoming projectiles, moving to intercept them, and **returning** them with purpose: in competitive paddle duels, short action breaches, and elaborate boss encounters.

> **Status:** Design and pre-production. No playable game has been built or verified yet. The name and technical/content targets are provisional.

## Start here

- [Game design document (Markdown)](docs/GAME_DESIGN.md) — the full written design reference, transcribed from design version 0.1.
- [Cline overnight build instructions](docs/CLINE_OVERNIGHT_PROMPT.md) — paste into the cloud coding agent for a scoped, verified first implementation.
- [Repository agent instructions](AGENTS.md) — standing instructions and safety/quality gates for coding agents.
- [Asset handoff instructions](assets/README.md) — where the two concept paintings and original PDF/DOCX source files belong.
  
## The game

- **Core:** overhead 2D arena duels with reliable core/paddle physics, bank shots, goals, readable enemy behavior, and short retries.
- **Between courts:** compact action rooms where the same return skill redirects enemy fire into vulnerable machinery.
- **Campaign vision:** eight districts, 64 authored encounters, eight bosses, an actual ending.
- **Optional endgame vision:** up to 3,072 *reviewed and accepted* trials; no meaningless palette-swapped level inflation.
- **Art:** curated, human-reviewed AI-assisted painted environment assets; gameplay clarity takes priority.
- **Recommended tech:** Godot 4.x with GDScript, Windows-first playable build; headless Linux validation in the cloud.

## Build priorities

1. One playable court and one rival with intentional aiming, reliable goals, and a rapid retry loop.
2. A connected breach room featuring a projectile that can be returned into a target.
3. Save/retry, menu/controller support, automated tests, and a documented build.
4. A complete small vertical slice before scaling content.

**Do not generate thousands of levels until the prototype passes tests and human playtests establish that returning is fun.**

## Source asset status

The originally produced PDF, DOCX, and two PNG concept paintings are available from the original ChatGPT conversation. They have **not** been copied into this GitHub repository by the text-only GitHub integration. See [assets/README.md](assets/README.md) for the exact expected filenames and a safe upload procedure; the Markdown reference and agent instructions are committed here independently.

## Licensing

All rights reserved unless the repository owner adds an explicit license. Godot and any third-party dependencies/assets must retain their own required notices. Do not import copyrighted assets or assume AI-generated art is cleared for every downstream use without review.

## Branching and release model

- [`dev`](https://github.com/Jeff-Kazzee/Last-return/tree/dev) — active integration branch for next build; task branches merge here by reviewed PR.
- [`prod`](https://github.com/Jeff-Kazzee/Last-return/tree/prod) — approved release branch; **currently a documentation baseline, not a playable shipped game**.
- `main` — preserved bootstrap branch; do not start new game work there.
- Feature/fix/chore/test/docs/art/spike branches start from `dev`; urgent `hotfix/*` branches start from `prod`.

See [branch and agent policy](docs/BRANCHING.md) and [release checklist](docs/RELEASE_CHECKLIST.md). **Agents open PRs but do not merge them**. GitHub rulesets/default branch must be configured separately by the owner; repository text does not mechanically enforce them.
