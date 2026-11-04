# Last Return

**Last Return** is a proposed atmospheric 2D arcade escape game set inside **the Interval**, a dreaming dystopian city. Play centers on reading incoming projectiles, moving to intercept them, and **returning** them with purpose: in competitive paddle duels, short action breaches, and elaborate boss encounters.

> **Status:** A playable Godot 4 vertical slice now exists on the `feat/verified-core-duel` review branch: one first-to-five arcade duel and one connected return-combat breach. The broader game remains in development; campaign, boss, save, and trial targets are not implemented.

## Play the vertical slice

Open `project.godot` in **Godot 4.4.1** and run the project, or run `godot --path .` from a checkout with Godot on `PATH`. No plugins, downloaded assets, accounts, or network connection are required.

1. Press **Enter** at the title. Score five goals before the Runner.
2. Move into the core to make an ordinary return. Time **Strike** near actual paddle contact for a faster, aimed return.
3. After winning, press **Enter** to enter the connected breach. Return the sentry's bright core into the armored mechanism, then move into the opened exit.

| Action | Keyboard / mouse | Conventional gamepad |
| --- | --- | --- |
| Move | WASD | Left stick |
| Aim | Mouse or arrow keys | Right stick |
| Active return | Left mouse | Right trigger |
| Dash | Space | Left shoulder |
| Breach sidearm (sentry stun) | Right mouse | Left trigger |
| Pause / resume | Escape | Menu / Start |
| Retry | R | Keyboard currently required |
| Confirm / enter next room | Enter | A / Cross |
| Collision/AI debug | F3 | — |
| Reduced effects | F4 | — |

The duel uses a 120 Hz fixed-step simulation, swept projectile contacts, whole-core goal openings, a reaction-delayed physical rival, and complete pause/retry state ownership. The breach reuses the same return math and gives the courier three integrity points. Focus loss and controller disconnect pause play.

## Web build

```bash
scripts/build_web.sh                 # Godot 4.4.1 web export into build/web/
python3 scripts/serve_web.py         # http://127.0.0.1:8080/
scripts/test_web.sh                  # real WebGL2/Chromium smoke test
scripts/deploy_cloudflare.sh         # requires a scoped Cloudflare API token
```

The browser build uses Godot's threaded Web runtime, so Cloudflare Pages must serve COOP/COEP headers from `web/_headers`. The exported game has passed a public Cloudflare Tunnel WebGL2 browser test; a permanent Pages deployment is pending a Cloudflare credential exposed to the deployment environment. See `docs/WEB_DEPLOYMENT.md` for account steps, token scope, production checks, and the current blocker.

## Reproduce verification

With Godot 4.4.1 on `PATH` (or `GODOT=/absolute/path/to/godot`):

```bash
scripts/verify_formal.sh   # exhaustive discrete model + intentional invalid transition
scripts/verify_godot.sh    # import diagnostics + lifecycle/physics/breach/scene tests
scripts/verify_live.sh     # real main scene driven only through public Input actions
scripts/verify_all.sh      # all three gates
```

See `docs/verification/verified-core-duel.md` for exact counts, seeds, formal bounds, GUI evidence, and limitations. A headless run is not a human playtest. Windows export/runtime, physical controller hardware, long-session balance, accessibility with users, and human judgments of fun remain unverified.

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

- [`dev`](https://github.com/Jeff-Kazzee/Last-return/tree/dev) is the default branch. Start short-lived task branches here and open reviewed PRs back into `dev`.
- [`prod`](https://github.com/Jeff-Kazzee/Last-return/tree/prod) holds the approved production baseline. The owner promotes releases through a `dev` to `prod` PR. Emergency `hotfix/*` branches start from `prod` and are reconciled into `dev` after the fix.
- The repository has no `main` branch.

Agents open PRs and report verification. The owner reviews and merges them. The repository guard checks branch direction and basic hygiene. Game tests and playtests have separate results.

See the [branching policy](docs/BRANCHING.md) and [release checklist](docs/RELEASE_CHECKLIST.md).
