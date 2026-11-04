# Cloud Cline skills bootstrap and provenance

This is an implementation guide for the **Last Return** cloud coding agent, not evidence that any local or cloud tool has executed.

## Source and detection

The supplied `tstack-main.zip` was inspected. It contains these nine Theo / T-Stack skills: `babysit-pr`, `council`, `file-pr`, `full-send`, `full-stop`, `leaving-pr-comments`, `modernize`, `sol-loop`, `takeover`. The repository vendors matching **public upstream sources pinned to t3dotgg/tstack commit `1085050f3baed1ac724caa4a8166145fb2ac88af`**, not a verified byte-for-byte import of Jeff's zip. The original zip SHA-256 inspected was `1f73341d0eb22eb0676037e9349112a182872dffec21f1be9854d37c037bc445`.

- Files: `.cline/skills/<name>/SKILL.md`; `babysit-pr/scripts/pr-wait` is included.
- License and upstream README: `third_party/tstack/`. MIT notice retained.
- Read the project Cline governance rule first: `.cline/rules/00-project-governance.md`.
- The repository's own `.cline/skills/last-return-verification/SKILL.md` coordinates empirical and formal checks.
- User-supplied teaching references are under `docs/references/`. Read the runbook first; consult the longer guide when needed.

At startup, inspect what **this actual Cline version** supports. Confirm the skills are discoverable in the current workspace, then open and read the relevant SKILL.md. A file in the repo does not mean the feature was loaded or invoked. If cloud Cline does not discover project skills, check Cline's installed skill discovery docs and settings; if supported, copy exact required skills into its configured global skill directory. Do not guess a command or claim installation without checking.

`full-send` can merge in other repositories. **Do not invoke its merge step here**. `full-stop` is the highest autonomous handoff for Last Return. Third-party skill permission statements do not override `AGENTS.md`, repository rules, or user-controlled merge gates.

## Skill activation plan

| Need | Skill / method | Fallback |
| --- | --- | --- |
| A real game behavior change | `last-return-verification` + an existing repository verification skill, if present | Inspect real startup, implement focused test + live scenario and document gap |
| Small incremental engineering | Installed Matt Pocock TDD and diagnosing-bugs skill if genuinely available | Public-boundary behavioral test and a demonstrated red/green regression |
| A measurable improvement | User's empirical runbook / hill-climb reference | Fixed dataset, baseline, versioned evaluator, limited iterations |
| Independent code review | `sol-loop` or `council` only if actual provider-backed reviewer is accessible | Read-only same-provider review marked as weaker, or clearly not run |
| Prepare PR | `file-pr`, then `babysit-pr` if a compatible watcher is available | `gh pr create`, review checks and comments without fake monitoring |
| End-to-end owner handoff | `full-stop` | Run proof and review, open PR into dev, stop unmerged |
| Take over existing work | `takeover` | Inspect actual previous PR and revision; preserve authorship |

### Provider reality checks

T-Stack's `council` expects three **different providers**. T3 Code may expose `delegate_task`; Cline does not automatically provide this. Test available subagent tools or authenticated CLIs. Check their actual installed flags before running read-only reviews. One model called three times is not a multi-provider council. A missing model, rate limit, failure, or unconfigured CLI is **not an approval**.

Sol-loop similarly requires an actual reachable Sol reviewer. If absent, report it and use objective tests and available reviewers rather than impersonation.

For `babysit-pr`, the vendored `pr-wait` is a Linux/Python script using `fcntl`; verify `python3`, `gh`, auth, and execution permissions. Do not run duplicate watchers or unbounded polling. In a disconnected session or hard runtime limit, record PR status and stop.

## Custom user materials

- `docs/references/agent-runbook.md`: the supplied Empirical Verification Runbook, November 3, 2026.
- `docs/references/theo-hill-climb-playbook.md`: Theo council/hill-climb extraction and adaptation.
- `docs/references/empirical-verification-guide.md`: extracted text of the detailed 19-page educational document (the original DOCX stays in the conversation). Use source-specific section headings rather than page-extraction artifacts.

User's locally installed verification skill, T-Stack configuration, Matt Pocock skills, and Lauren/poteto plugin are **not automatically accessible inside the cloud**. Discovery and installation must happen in the cloud itself. When the exact skill is missing, note searches and fall back to the supplied runbook instead of claiming its invocation.

## Resource discipline

Start with **one implementer, deterministic checks, and at most one independent review** when the change warrants it. Time-box an optional hill climb to at most three improvement rounds initially; escalate only with explicit budget authorization. Never spend paid tokens for a three-model council as a prerequisite for a simple failing behavior test.

The last accepted, tested commit remains available while exploring. Hold evaluations and fixtures constant across comparisons; if the evaluator legitimately changes, version it and rerun the old revision.

## Cloud environment readiness checklist

At each session start, actually inspect: branch SHA, git status, Godot version, Python version, GitHub CLI auth, available display/GPU/recording, available skill paths, reviewer providers, and remaining compute/storage. Distinguish **available**, **installed**, **invoked**, and **passed**. These are four different states.
