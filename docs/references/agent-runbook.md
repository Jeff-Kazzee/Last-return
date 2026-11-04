EMPIRICAL VERIFICATION RUNBOOK
For Jeff and his coding agents
November 3, 2026

Use the task's existing repository instructions and verification skill. This runbook is an adaptation of the supplied Theo transcript, with ideas from Matt Pocock and Lauren (poteto). It does not install or replace any skill.

STARTER PROMPT

Work on the task I give you using empirical verification. First read the repository instructions, the existing verification skill, and the relevant feature map. Locate the actual files and commands; do not guess skill names or claim unavailable tools ran. If the skill cannot be found, say what you checked and continue with the useful inspection you can do.

State the user-visible outcome, scope, and behavior that must remain true. Inspect the repository to answer questions it can answer. Ask me only about decisions or missing access that materially affect the work. Honor already established decisions and permissions.

Reproduce the current behavior and capture a baseline tied to the exact code revision. Establish a check that can detect the relevant failure. Use the real application path for claims about user behavior. Follow the existing verification ladder: static checks, focused behavioral tests, live interaction, and additional checks when the risk warrants them.

Make one bounded, coherent change at a time. State the hypothesis, run the relevant check, and keep or discard your own change based on evidence. Preserve unrelated edits. For behavioral tests, use observable interfaces and independently justified expected results. Do not add tests that only mirror implementation details.

Keep the evaluation, input data, and success criteria stable while comparing versions. If the evaluator must change, explain why, version it, and rerun both baseline and candidate. Do not weaken checks or omit difficult cases to improve a score.

For a meaningful independent review, use the available review capability and the same fixed revision and evidence. Reviewers work read-only. Verify findings before changing code. If cross-provider review is unavailable, state that limitation; do not impersonate multiple providers.

Use a small initial budget: at most three implementation rounds or 60 minutes for an exploratory improvement, unless I specify another limit. No new paid service without authorization. A straightforward bug fix can finish sooner. Stop at a verified useful result, a material blocker, or the budget. Do not silently raise the target or extend the run.

Complete authorized implementation and checks. Apply the repository's current shipping rules. In Vivary, check and honor the owner-review gate. A model score does not authorize a merge.

Report the user-visible result, exact revision, checks actually run, observations, evidence locations, and unresolved limitations. Mark unavailable checks as blocked or not run. Separate suggestions from confirmed defects.

UI IMPROVEMENT PROMPT

Improve this interface for the specific user task described in my request. Read the existing verification recipe and identify representative states, including long content, relevant themes, supported sizes, and increased zoom.

Capture the current design and candidate using the same content and settings. Use competitor screenshots only as task-relevant references. Keep those references fixed. Preserve user behavior, keyboard access, focus, drafts, status accuracy, and relevant persistence.

Ask an available independent reviewer to compare neutrally labelled artifacts with a fixed rubric for hierarchy, readability, action clarity, consistency, and identity. Withhold desired scores and earlier reviewers' answers. Require specific observations and distinguish visual judgments from behavior that screenshots cannot establish.

Fix the most useful confirmed issue. Capture the new state and exercise the affected interaction. Show clean before-and-after evidence and an annotated explanation of important differences. Treat a higher score as supporting feedback; acceptance also requires the behavior checks and my product judgment.

BLINDED REVIEWER BRIEF

Review only the supplied fixed revision or labelled artifacts and requirements. Keep your work read-only. Do not assume one variant is preferred. Do not infer missing screenshots, code, or test results.

For each significant issue, provide the artifact or file location, observed problem, consequence for the stated task, and a way to verify the claim. Distinguish confirmed defects, hypotheses, and taste preferences. State what you could not inspect.

For UI comparison, use the supplied rubric consistently across all variants in one pass. Explain the preference and remaining tradeoffs. If scores are requested, provide a rationale and avoid unsupported decimal precision. Do not adjust your assessment to achieve a target. Behavioral correctness cannot be inferred from appearance alone.

FAILURE TO EVAL PROMPT

Use only the relevant task history or examples available in this project. Identify recurring failures and turn them into a compact evaluation. Do not read unrelated conversations.

For each case record: request, relevant starting state, tools available, expected behavior, forbidden behavior, observed failure, and the evidence. Separate wrong reasoning or routing from invalid arguments, tool execution failures, environment failures, and wrong final state.

Define a development set and a held-out evaluation set. Use controlled routing tests where useful and real integration checks for important side effects. Pin the suite revision, model identifiers and settings, tool schemas, fixture data, and evaluator.

Demonstrate that the check detects a known failure before using it to claim improvement. Run baseline and candidate under matched conditions. Predeclare repeats and aggregation, preserve all outcomes, and report variation. A perfect observed score applies only to the tested cases and runs.

Improve correctness first. Save the accepted version. Then optimize cost or description length while retaining the correctness conditions. Revalidate the final version on held-out cases. Do not teach the candidate to recognize the evaluation or hardcode example answers.

CONTEXT COMPRESSION PROMPT

Starting from the verified baseline, reduce repeated tool or instruction context while preserving the distinctions required for correct behavior. Protect preconditions, action meaning, required arguments, side effects, and error recovery.

Measure actual token usage with the available tokenizer or usage records. Record initial context separately from total task tokens, latency, retries, and tool errors. Run with tool search enabled and disabled only when both are relevant supported configurations; report them separately.

Use the frozen evaluation and matched workloads after each coherent change. Keep only changes that preserve the required behavior and improve the agreed cost measure. If the evaluator changes, rerun the baseline. Report a missed target honestly rather than weakening correctness to reach it.

VERIFICATION SKILL INSPECTION PROMPT

Inspect the existing project verification skill and its feature map before relying on it for this task. Confirm the documented startup command reaches a usable instance, that the instance belongs to this run, and that the driving recipe reaches the real user path.

Exercise the relevant mapped behavior. Capture the action, resulting state, and relevant side effects. Keep evidence after cleanup. Isolate ports, profiles, and data when needed; do not drive the user's active session casually.

Classify any problem as stale instructions, a harness limitation, an environment prerequisite, or an application defect. Do not rewrite the expected behavior to hide a regression. A full maintenance sweep is a separate task; do not expand this scoped inspection into one without reason.

FRESH CONTEXT HANDOFF PROMPT

Prepare a concise handoff for another agent. Include the goal, current accepted commit, branch and worktree, relevant instruction and verification paths, decisions already made, evaluation version, evidence, failed approaches worth avoiding, and the next bounded action.

Separate the accepted implementation from exploratory work. State which checks remain required on any new revision. Preserve permissions and merge gates. Do not claim old review approval covers future changes.

COMPLETION RECORD

Goal:
Final revision and relevant build:
Environment and workload:
Checks and exact commands or actions:
Expected result:
Observed result:
Baseline and candidate measurements, with units and variation if applicable:
Evidence locations:
Review findings and disposition:
Unverified conditions or blockers:
Shipping status and required owner action:

HOW TO INTERPRET THE EVIDENCE

- Empirical verification observes a result under specified conditions.
- Formal verification establishes a stated property within a mathematical model and assumptions.
- A model council supplies judgments and possible defects; it does not prove runtime correctness.
- A screenshot can support a visual claim. Persistence, permissions, cancellation, and tool side effects need behavioral evidence.
- A rate limit, unavailable model, skipped test, or broken environment is not a passing result.
- The safest improvement is one you can explain, observe, and reproduce without changing the test to flatter it.

PRIMARY SOURCES

The detailed teaching guide contains the full 13-chapter walkthrough and timestamped transcript prompt catalogue.
Theo's T-Stack: https://github.com/t3dotgg/tstack
Matt Pocock's skills: https://github.com/mattpocock/skills
Matt's TDD: https://github.com/mattpocock/skills/blob/main/skills/engineering/tdd/SKILL.md
Lauren's verification generator: https://github.com/cursor/plugins/blob/main/pstack/skills/create-verification-skill/SKILL.md
Lauren's maintenance workflow: https://github.com/cursor/plugins/blob/main/pstack/skills/maintain-verification-skill/SKILL.md
Lauren's hillclimb: https://github.com/cursor/plugins/blob/main/pstack/skills/poteto-mode/playbooks/hillclimb.md
Lauren's eval: https://github.com/cursor/plugins/blob/main/pstack/skills/poteto-mode/playbooks/eval.md

Read installed versions before invocation. Public source is not evidence that a plugin is exposed in the current agent session.
