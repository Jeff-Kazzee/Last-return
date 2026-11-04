# Last Return release gate

`dev` is the default integration branch. `prod` holds approved production work. The repository has no `main` branch. Short-lived task branches target `dev`, except emergency hotfixes. A playable release requires the evidence below.

Version: __________   Candidate commit SHA: __________   Date: __________

## Candidate and integrity

- [ ] PR `dev` → `prod` (or documented `hotfix/*` → `prod`) has a clear scope and change summary.
- [ ] `repository-guard` and all other configured required checks passed for the candidate SHA. Record skipped checks separately.
- [ ] Godot import, GDScript parsing, automated game logic tests, and deterministic physics tests ran for the candidate. Record exact commands, outcomes, and any coverage gaps.
- [ ] Branch and binary artifacts are reproducible from a recorded Godot version and dependencies.
- [ ] Dependency, repository secrets, and asset/licensing provenance review completed.
- [ ] No unresolved blocker or known critical security issue.

## Playable quality

- [ ] Windows build exported and opened on a real Windows environment.
- [ ] Keyboard/mouse gameplay is responsive; controller smoke test performed if advertised.
- [ ] New game, duel start, legal goals, match ending, retry, pause, and quitting work.
- [ ] Projectile physics validated at supported speed bounds; no double-scoring.
- [ ] Breach return-target and scene transitions function if included in release scope.
- [ ] Save, upgrade/migration, and recovery tested for any persisted format change.
- [ ] Visual legibility, audio cues, and reduced-effects accessibility tested at target resolutions.
- [ ] Worst known frame-time or performance issue documented; no false performance claims.

## Shipping decision

- [ ] Release notes and user-facing limitations are accurate.
- [ ] Rollback strategy or previous known-good tag identified.
- [ ] **Owner explicitly approved this candidate SHA.** The owner merges the PR with a merge commit.
- [ ] After merge, tag **the approved `prod` SHA**, never `dev`.
- [ ] If emergency hotfix, bring the patch back into `dev` through its own PR.

Owner decision: __________   Actual test evidence / artifact links: __________
