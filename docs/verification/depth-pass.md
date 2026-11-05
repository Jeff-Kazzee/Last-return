# Intensity and depth pass verification

**Goal:** Replace an uncontested 5–0 two-minute walkover with a shorter, more tactical return game whose rallies escalate and whose opponent adapts.

## Intended behavior

- First to three.
- Every paddle return increases rally pace within a hard speed cap.
- Strike contact in the tight final window grades PERFECT and adds more pace than ACTIVE.
- Successful returns fill focus; E spends 65 focus on a short BRAKE that slows the core but not the courier.
- Two central pylons create intentional bank trajectories.
- After six returns, pressure widens both goals to force a decisive resolution.
- The rival improves speed, reaction, and accuracy after every conceded point.
- The breach requires two returned-core hits on locks at different positions before the exit opens.

## Automated results

- Formal model: **PASS — 324 states / 2,916 transitions** at first-to-three; model SHA-256 `29443f7306a21684a08d64dc2ae11066938b4897b990fc2d8043453ea9404bce`; the duplicate-goal mutation still exits 1 with `start → goal_player → goal_player`.
- Godot mechanics: **PASS — 135 checks / 0 failures**. This includes explicit assertions for rally escalation/cap, pylon bounce, PERFECT vs ACTIVE, BRAKE spending/slowdown, pressure-wide edge goals, adaptive rival parameters, two-lock ownership, and clean retry.
- Input-only benchmark (`scripts/verify_live.sh`, driver `live-v4-focus-brake`): **PASS — 3–2 win in 90.283 s**, 23 PERFECT returns, 8 BRAKE activations, longest rally 17; breach required two lock hits and completed in 11.383 s. The verifier rejects an exact walkover and requires a 3–1/3–2 competitive result.
- Web parity: **PASS** after rebuilding. The updated export booted in Chromium with WebGL2/cross-origin isolation, accepted Enter/movement/Escape, showed the new pylons/focus HUD, and also passed through the public Cloudflare preview.
- This is an expert bot, not a human difficulty measurement. Its timing would be demanding for a new player.

## Limitations

- A 17-return expert rally and a 90-second match are still long for some players; human playtests must calibrate further.
- Difficulty is measured against one deterministic input bot and one seed. It does not prove fun or appropriate difficulty for people.
- No audio feedback yet.
- Continuous physics remains validated by finite tests, not exhaustive proof.
- Web parity is browser-smoke tested, but the match balance has not been evaluated by human players.
