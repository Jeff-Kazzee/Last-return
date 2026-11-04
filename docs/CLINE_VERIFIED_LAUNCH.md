# Cloud Cline — Last Return verified build launch prompt

> Copy the following into the **cloud Cline implementation agent**. This launch prompt supplements `docs/CLINE_OVERNIGHT_PROMPT.md`; it does not authorize merging or repo administration.

## COPY FROM HERE

You are the autonomous implementation lead for Last Return, working in the cloud against `https://github.com/Jeff-Kazzee/Last-return`.

**Mission:** create a genuinely playable Godot 4/GDScript arcade vertical slice with reliable puck returns, one fair opponent, scoring, pause/retry, and one short action breach. Do the engineering under a rigorous, evidence-first workflow based on my supplied verification documents and Theo's T-Stack, Matt Pocock's testing practices, and Lauren/poteto's real-application verification.

### 1. Source discovery before implementation

Inspect the live repo and branch protections. Start with `origin/dev`, create `feat/verified-core-duel` or an equivalent unoccupied task branch, and work only there. `prod` is the protected release branch. Do not modify GitHub settings, delete branches, force-push, merge PRs, or use owner bypass credentials.

Read in this order:
1. `AGENTS.md` and `.cline/rules/00-project-governance.md`
2. `docs/GAME_DESIGN.md`, `docs/CLINE_OVERNIGHT_PROMPT.md`, `docs/BRANCHING.md`
3. `docs/SKILL_BOOTSTRAP.md`, `docs/VERIFICATION_PROTOCOL.md`
4. `.cline/skills/last-return-verification/SKILL.md`
5. `docs/references/agent-runbook.md` and relevant sections of the two longer references.

Inspect `.cline/skills/` and **verify** that your running Cline actually discovers T-Stack. The pinned project skills include `full-stop`, `council`, `sol-loop`, `file-pr`, `babysit-pr`, and other helpers. Read exact installed skill text before use. If Cline does not discover project skills, consult the actual installed Cline documentation and configure an accessible skill directory if permitted. Do not claim installation/invocation until verified.

Search the cloud environment for my existing personal verification skill and relevant Matt Pocock or poteto skills. Their presence on my local Windows machine is not proof they exist in the cloud. If they are absent, log the paths and capabilities checked, use the repository-provided `last-return-verification` skill and runbook, and do not stall on unavailable tools or spend money installing dependencies.

### 2. Verification-driven engineering

Before each behavior change: state observable outcome, preserved behavior, baseline SHA, expected outcome independent of code, and the check that can fail.

Implement the smallest playable vertical slice. For fixes, demonstrate the relevant failure on baseline when possible, then a passing result after the change. Keep checks/fixtures stable across comparisons. If changing the evaluator is justified, version it and rerun both revisions.

Use these evidence layers separately:
- static Godot import and script/parser checks;
- focused public-boundary tests;
- deterministic physics and property/scenario tests using fixed seeds, adversarial high-speed cases and intentional negative controls;
- live gameplay checks through a real engine instance when GUI access exists;
- optional read-only independent reviewer feedback, which cannot override behavioral failures.

A missing tool, no graphical environment, a timed-out provider, or an unrun check is **NOT RUN/BLOCKED**, not PASS.

### 3. Mandatory formal verification work

Build a small explicit **formal model of the discrete duel state machine**, not an imaginary proof of all gameplay.

Model `READY`, `LIVE`, `GOAL_FREEZE`, `FINISHED`, paused state, two score counters and the relevant start, goal, serve, pause, resume, and retry transitions. State any assumptions and identify exact win target and time abstraction.

Write a checker using Python state-space exploration or a real appropriate model checker. Check reachable states/transitions against these obligations:
1. A goal awards exactly one point only from an unpaused LIVE state, and the next duplicate goal event cannot award another point before a legal new serve.
2. Scores are bounded and only the intended side can gain the goal.
3. Paused gameplay cannot advance scoring/game-time AI/projectile state.
4. FINISHED cannot restart by accident.
5. Retry resets defined game state completely.
6. A match cannot have two winners.
7. A legal transition never skips required scoring/serve/finish states.

Include an intentional buggy transition or small mutation to demonstrate the checker produces a counterexample and nonzero exit code. Report actual state count, transition count, checker command, model SHA, exploration bounds and assumptions. Exhaustive exploration of a finite **abstraction** is not proof of arbitrary continuous physics.

**Then link the model to the real Godot code**: identify the corresponding functions/events and write integration tests across the same boundary transitions. A correct abstract model alone is insufficient. If a property remains unverified at runtime, disclose it explicitly.

For projectile collision use additional empirical reasoning/stress testing: swept detection if necessary, speed caps, near-simultaneous rail/paddle contact, scoring edge crossings, pause/retry during impact, high-speed tunnelling and randomized held-out seeds. Do not claim a finite sample proves collision correctness for all real inputs.

### 4. Use Theo / Matt / Lauren without ceremony

- Use behavior-first narrow vertical slices and independently justified test expectations. Don't create assertions that simply duplicate private implementation code.
- Use T-Stack `full-stop` **semantics** for the total implementation task: prove the change, obtain appropriate review if real reviewer access exists, file a concise PR, check CI/review comments, and **STOP WITHOUT MERGING**. Never use `full-send` merge permissions.
- Use `file-pr` for a problem-first PR description. `babysit-pr` may run only if a real watcher is available and the runtime supports it. No duplicate or endless polling.
- For meaningful code risk, use `sol-loop` only if an actual Sol reviewer can be invoked. Use `council` only if genuinely distinct provider-backed reviewers are available. Do not fabricate multi-model reviews. Report incomplete reviews.
- Use a hill-climb only when there is a stable objective and fixed evaluator. Start with at most three exploratory rounds. Freeze references, save accepted checkpoint, report regressions honestly, and hide desired visual scores from the judge. Do not trade correctness for a prettier screenshot.
- Read the supplied runbook and playbook, but use the current Godot project as the source of truth for commands and interfaces.

### 5. Implementation priorities

1. Godot project imports cleanly and launches with clear controls.
2. Paddle / projectile / rail physics supports intentional directional returns.
3. Rival AI respects reaction delay, acceleration, speed, and information limits.
4. Score once per goal, serve/reset, match completion, pause, retry.
5. Connected short breach room: reflect enemy projectile into a vulnerable mechanism, opening exit.
6. Readable atmosphere and feedback with simple placeholder assets. Reference art is not collision data or sprite sheets.
7. Optional boss/technique only when core passes executable and application checks.

Do **not** generate thousands of fake levels. Do not hide a broken game behind art.

### 6. Output and review gates

Maintain `docs/IMPLEMENTATION_PLAN.md`, `docs/PROGRESS.md`, and `docs/verification/<task>.md` with the exact branch/head, commands, expected/observed output, checker bounds, formal assumptions, negative-test result, runtime mapping, held-out cases and known gaps.

Commit small verified milestones and push the feature branch when authorized. Open a PR into `dev`. Do not self-merge. If lack of graphics, external reviewer, paid tool, or environment capability blocks an intended check, preserve useful work and report it as unverified.

End with: real implementation status; latest SHA; PR URL; formal model and checker results; Godot empirical tests; GUI playtest status; review availability and findings; blockers; and next three scoped actions. A claim counts only when its evidence is attached to the exact revision.

Begin by inspecting the actual repository and cloud capabilities, then create and execute a bounded plan.

## END COPY
