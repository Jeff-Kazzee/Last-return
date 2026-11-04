# Branching, integration, and release policy

**Effective:** 2026-11-03. This repo is in pre-production; no playable release is claimed.

## Branch responsibilities

| Branch | Purpose | Allowed incoming PRs | Merge authority |
|---|---|---|---|
| `prod` | The currently approved, releasable product state | `dev` release promotion or `hotfix/*` | **Owner approves; agents never merge** |
| `dev` | Next build's integration branch; can contain in-progress work that passes integration checks | Short-lived task branches or `prod` hotfix sync | **Owner approves; agents never merge** |
| `main` | Historical bootstrap branch. **Do not use for new game development.** | None by convention | Reserved |
| `feat/*` | Gameplay or product feature | `dev` | Via reviewed PR |
| `fix/*` | Bugfix discovered during development | `dev` | Via reviewed PR |
| `chore/*` | CI, repo, tooling, maintenance | `dev` | Via reviewed PR |
| `test/*` | Test/verification work | `dev` | Via reviewed PR |
| `docs/*` | Documentation/design updates | `dev` | Via reviewed PR |
| `art/*` | Approved assets or art pipeline work | `dev` | Via reviewed PR |
| `spike/*` | Time-boxed experimental prototypes | `dev`, *only if worth integrating* | Via reviewed PR |
| `agent/*` | Transitional agent-owned task branch; prefer a purpose-specific prefix | `dev` | Via reviewed PR |
| `hotfix/*` | Critical repair branched from `prod` | `prod`, followed by backport/sync to `dev` | Owner approves |

Branch names should use lowercase kebab-case after the prefix: `feat/123-strike-timing`, `fix/goal-double-score`, `chore/ci-godot-import`, `art/station-court`, `spike/controller-latency`. Where a tracked issue exists, include its number. Avoid long-lived per-feature branches.

## Working flow

1. Sync from `dev`, then branch: `git switch dev && git pull --ff-only && git switch -c feat/123-strike-timing`.
2. Implement one coherent piece of work. Add deterministic tests and record command output/limitations.
3. Push the task branch, open a PR **into `dev`**, and complete the PR template.
4. Run CI and any relevant local/manual tests; fix failures in that branch.
5. **Stop for owner approval**. Do not merge PRs or disable checks as an agent.
6. After approved integration, delete the *task branch* if no longer needed. Keep `dev` and `prod` permanently.
7. For a release, open a PR **`dev` → `prod`**, complete `docs/RELEASE_CHECKLIST.md`, obtain explicit owner approval, and then tag the approved `prod` commit. Do not tag `dev`.
8. For a critical production bug, branch from `prod` into `hotfix/*`, PR to `prod`, then bring the fix back into `dev` via a separate PR.

No direct push to `dev` or `prod` after protections are enabled. Do not use force pushes on protected branches. A clean `dev` is **not** proof that `prod` can ship; releases require a separate playable acceptance process.

## What counts as verified

**Repository guard** checks PR direction/branch naming and baseline document hygiene. Once `project.godot` exists, CI imports the project headlessly. A successful import does *not* certify gameplay, rendering, controller support, frame pacing, audio, exported Windows binaries, or game balance. Record local GUI QA and real playtest results separately.

**Required for ordinary feature PRs:** accurate scope and tests, linked issue if any, evidence of gameplay state when relevant, no hardcoded secrets, no unapproved binaries/assets, no broken project import, and full disclosure of untested behavior.

**Required for `prod`:** verified Windows build and smoke test, known-good saves and retry, no critical blocker, content provenance, clean dependency/secrets review, documented release notes, and explicit owner's release decision.

## Automated agent guardrails

Agents can create task branches, commits, PRs, test reports, and proposed documentation. Agents must **not** merge, tag a public release, change repository settings/rulesets, delete branches unrelated to their task, or alter `prod` directly. If the user explicitly authorizes a particular exception, document the scope rather than treating it as standing permission.

Do not put every overnight coding task into one huge PR. Split verified milestones into reviewable branches/PRs when dependencies allow. Prefer a narrow vertical slice to countless unfinished features. Use `docs/PROGRESS.md` in the active task branch to record checkpoints and unresolved problems.

## Required GitHub settings (owner action)

The connected GitHub integration can create branches and files but **does not expose repository administration writes**. These are not active until configured in GitHub:

1. Change default branch from `main` to `dev` at repository **Settings → General → Default branch** so new PRs target active development by default.
2. Create rulesets in **Settings → Rules → Rulesets** for `dev` and `prod`, with: require PR, block force pushes and deletion, require status check `repository-guard` after its first successful run, and prohibit bypass for automation accounts. Configure strict up-to-date checks as needed.
3. For `prod`, consider an additional required human approval, but **do not blindly require one** in a single-maintainer repository where the only qualified reviewer is the PR author: GitHub does not let an author approve their own PR. Keep the owner-controlled manual gate and add a second trusted reviewer when available.
4. Enable secret scanning/Dependabot and review Actions permissions (read-only token by default).
5. Configure squash merging for ordinary task PRs, retain release PR merge history as preferred. Disable automatic merging if you want the owner gate to remain human.

Rulesets and default branch changes must be **verified on GitHub** rather than assumed from this file.
