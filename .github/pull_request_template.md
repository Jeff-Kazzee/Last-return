## What changed?

<!-- Summarize one coherent milestone or fix. Link issue if one exists. -->

## Target and kind

- Target branch: `dev` (normal task) / `prod` (reviewed release or hotfix)
- Type: feature / fix / chore / test / docs / art / spike / hotfix / release
- Linked issue(s):

## Verification evidence

| Check | Command or manual steps | Observed result | Limitations |
|---|---|---|---|
| Headless Godot import | | | |
| Automated mechanics tests | | | |
| GUI playtest / screenshot / video | | | |
| Windows export / manual smoke (releases) | | | |

**Do not claim GUI QA from a headless-only run.**

## Gameplay, art, and safety

- [ ] User-visible changes are described and illustrated if practical.
- [ ] Retry/pause/save/goal behavior remains correct or is explicitly out of scope.
- [ ] Added art/audio has provenance and permitted rights; no runtime image generation.
- [ ] No hard-coded credentials, personal tokens, or unsafe automation.
- [ ] README/progress docs reflect actual implemented state.
- [ ] Breaking changes and unverified behavior are clearly identified.

## Reviewer gate

- [ ] CI completes successfully, with failures resolved or explicitly explained.
- [ ] Human owner reviews **before merge**.
- [ ] For `prod`, complete `docs/RELEASE_CHECKLIST.md`.
- [ ] No agent self-merge or force-push.
