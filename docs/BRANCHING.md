# Branching, integration, and release policy

The repository is in pre-production. `dev` is the default branch for active development. `prod` holds the owner-approved production baseline. The repository has no `main` branch.

| Branch | Starts from | Pull request target |
| --- | --- | --- |
| `feat/*` | `dev` | `dev` |
| `fix/*` | `dev` | `dev` |
| `chore/*` | `dev` | `dev` |
| `test/*` | `dev` | `dev` |
| `docs/*` | `dev` | `dev` |
| `art/*` | `dev` | `dev` |
| `refactor/*` | `dev` | `dev` |
| `perf/*` | `dev` | `dev` |
| `spike/*` | `dev` | `dev` if the experiment warrants integration |
| `hotfix/*` | `prod` | `prod`, followed by a separate reconciliation PR into `dev` |

Use a lowercase, hyphenated name such as `feat/123-strike-timing`. Include the issue number when available. Keep task branches short-lived.

## Integrate a task

1. Fetch `origin` and create a task branch from `origin/dev`.
2. Commit a bounded change and push the task branch. Open a PR into `dev` with the test evidence for its head SHA.
3. Run the repository guard and the tests that cover the change. Record skipped checks and unverified behaviour.
4. Resolve review conversations. The owner reviews the evidence and squash-merges the PR. Agents stop at handoff.
5. After integration, GitHub can delete the merged task branch. Preserve any branch with unmerged work.

## Promote a release

1. Open a PR from `dev` into `prod`. For an emergency fix, branch from `origin/prod` and open a `hotfix/*` PR into `prod`.
2. Complete the [release checklist](RELEASE_CHECKLIST.md) and record the owner's decision for the candidate SHA.
3. The owner merges the approved PR with a merge commit, then tags the approved `prod` commit when shipping a release.
4. After a hotfix, reconcile the patch through a PR from `prod` to `dev` or through a `fix/*` branch if the patch needs adapting.

## GitHub settings and owner review

Both permanent branches require a pull request and resolved review conversations. Their rulesets block force pushes and deletion and have empty bypass lists. `dev` requires an up-to-date, passing `repository-guard` check from GitHub Actions and uses squash merges. `prod` uses merge commits. A separate update rule limits merges into both branches to repository admins through pull requests. The admin exception applies only to that update rule. The branch protections still apply. Check current enforcement in [repository rulesets](https://github.com/Jeff-Kazzee/Last-return/settings/rules).

The production bootstrap is pending until the owner promotes a `dev` revision that contains the workflow. The guard can run on that promotion PR. After the workflow lands on `prod`, verify it on the production push and on a `hotfix/*` PR. Then add the GitHub Actions `repository-guard` check to the production ruleset.

GitHub Free supports rulesets on this public repository. Required approvals are set to zero so the solo maintainer can merge a PR they authored. The owner reviews changes and records release approval. GitHub cannot distinguish an unattended agent using an administrator credential from the administrator. Give automation only the access it needs and keep owner credentials out of unattended agents. Review any proposed change to the guard, workflow, and integration policy as a change to the checks themselves.

Auto-merge is disabled. Actions use a read-only default token and the guard declares `contents: read`. [GitHub ruleset documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets).

## CI and game verification

`repository-guard` checks PR branch direction, policy script syntax, and required documents. The current workflow skips the engine import when the project or engine is missing. Record import, script parsing, gameplay, and release checks as separate results.

Add Godot checks as the project grows. Pin the Godot version and export templates. Make missing tools fail any job that claims to verify the corresponding behaviour.

1. Import the project headlessly and fail on import errors.
2. Parse GDScript in a separate check with explicit diagnostics.
3. Run headless game logic tests for scoring, resets, pause, retry, and opponent movement.
4. Run fixed-step physics tests with known seeds and fixtures for collision bounds, tunnelling, and double scoring.
5. Validate the Windows export from the candidate SHA. Record a separate smoke test of the actual export on Windows.
6. Check dependencies, action revisions, secrets, and asset licences. Use GitHub's public-repository security features where they cover the risk.

Require new jobs only after the relevant PR paths produce reliable results. Keep GUI playtesting and the owner's release decision in the release checklist.
