# Improving agent workflows through empirical verification

> Text-only extraction of Jeff's supplied 19-page DOCX. Some tables, inline figures, and page layout may not survive transcription; consult the original document for precise layout. The source document and its prompt catalogue remain the reference.



---

<!-- Extracted page 1 of 19 -->


Improving agent workflows through
empirical verification
An educational guide for Jeff and his coding agents
November 3, 2026
Give an agent a concrete outcome, a reliable way to observe it, and enough room to improve it. Then judge
the result against evidence. That is the useful idea running through Theo's transcript. You can apply it to
interface design, bugs, performance, tool descriptions, and the way your agents themselves work.
For your workflow, combine three habits: clarify the behavior you want; make the real application observable
and controllable; iterate against a stable check. Keep your own judgment in the loop. A panel of enthusiastic
models can still approve a poor result.
This guide explains all 13 chapters of the supplied transcript, preserves the prompts and instructional passages
in a timestamped catalogue, and gives you a practical workflow and copyable prompts. Transcript observations
are identified by time. External sources are numbered in the reading list. The combined workflow and
suggested budgets are adaptations for your work, rather than a claim that all three people use one identical
process.


Start here
On your next task, write a short statement of the user-visible change. Ask the agent to find your existing
verification skill and the relevant feature instructions. Have it reproduce the current behavior before changing
code. Implement one bounded change, run the relevant checks, and show the evidence. Use an independent
review when the change warrants it. Finish with a usable result and a small record of what was verified.
For example: "In Vivary, make it easier to find a thread and understand whether its run is queued, running,
held, or finished. Preserve the existing state transitions. Use the current verification skill to exercise the real
interface and show the result at normal and increased zoom."
That example gives the agent a product outcome and a behavior to preserve. It does not ask for a whole
redesign or assume that more tests automatically mean more confidence.
Read the transcript walkthrough for the reasoning, the verification section for the evidence standard, and the
prompt catalogue when you want Theo's actual wording. Give an agent the companion runbook when you are
ready to apply the workflow in a repository.


What verification means here
Empirical verification means checking claims through observation or experiment. You run the application,
execute a test, measure a workload, or inspect a recorded interaction. The conclusion applies to the conditions
you actually checked.
Formal verification uses a mathematical specification and reasoning procedure to establish a property under
stated assumptions. A proof about a model applies to that model; connecting it to production code requires
further work. Bounded model checking can exhaust a bounded state space without establishing an unbounded
claim. A test suite, fuzz campaign, type check, or model council is not automatically formal verification.


                                                                                           


---

<!-- Extracted page 2 of 19 -->


 Method                    What it can establish                          What remains uncertain


                           Rules checked by the configured compiler or
 Static checks and types                                                  Runtime behavior outside those rules
                           analyzer


                           The specified observations on the exercised    Uncovered inputs, environments, and
 Behavioral tests
                           inputs                                         interactions


 Live application          A real user path works in the recorded build
                                                                          Other paths and conditions
 verification              and environment


 Benchmarks and agent      Measured performance or task success on a
                                                                          Generalization and run-to-run variation
 evals                     defined workload


                           A reviewer's assessment and proposed
 Model review                                                             Whether claims are true and important
                           defects


                           A stated property within an explicit model     Whether the model and implementation
 Formal methods
                           and assumptions                                match


Your everyday default should be empirical verification. Formal methods become useful when the cost and
structure of a problem justify them: a queue invariant, permission boundary, cancellation protocol, or state
transition system may deserve a more precise model. Keep live checks even when a formal model exists.
Separate three questions. Does it behave correctly? Does the experience help a user complete the task? Is it
better on the metric you are trying to improve? Each question needs its own evidence. A screenshot supports a
visual claim. It cannot establish that a draft survives a restart. A green unit test cannot establish that a control
remains reachable at 150 percent zoom.


The terms and tools in plain language
T3 Code is the coding-agent application discussed in the video. T-Stack is Theo's collection of workflow skills. A
skill supplies instructions; the surrounding agent application must supply the tools, model access, and
permissions needed to carry them out. Installing a council skill does not create access to other model
providers.
A harness is the surrounding machinery that lets an agent or test do work: launching a process, providing tools,
controlling an interface, collecting results, and handling errors. A verification skill can teach an agent how to
operate that machinery for a particular app.
An eval is a repeatable evaluation of behavior on defined cases. A benchmark measures something under a
specified workload. A rubric describes how a reviewer should judge an output. The expected result or judging
rule is sometimes called an oracle; it must have a trustworthy basis.
Hill climbing means proposing a change, checking whether it improves the chosen objective, keeping useful
changes, and repeating. It can settle on a local optimum: a version better than its nearby alternatives even
though a different design could be much better. Explore a few distinct approaches when small refinements
stop helping.

                                                                                          


---

<!-- Extracted page 3 of 19 -->


A regression is behavior that becomes worse after a change. An invariant is a condition that must remain true,
such as a cancelled queue item never starting. A gate is a required condition before proceeding. A held-out
case is kept outside the examples used to optimize the implementation, so it can provide a less rehearsed
check.
A worktree is a separate working checkout of a Git repository. A stacked PR depends on an earlier PR;
reviewers need to know which change forms its base. A fresh thread gives an agent a new conversation
context, so it needs an explicit handoff of relevant facts.
Tokens are the model's units of text processing. Context is the information available in the current interaction,
including instructions, tool definitions, messages, and results. MCP, the Model Context Protocol, is used here
to expose application actions to agents. The eval tests whether agents choose and use those actions correctly.


The transcript explained chapter by chapter
Chapter 1 The UI design challenge
00:00–02:25. Theo starts with criticism of T3 Code's fonts, shapes, hierarchy, and overall polish. The joke about
hiring a French designer named Claude refers to using an AI model. He describes a free, open-source project
without a full-time UI/UX designer, with inference supplied through users' providers or subscriptions.
His question is whether an agent can produce interface quality that would otherwise need sustained design
attention. He reports about 18 hours across five models, more than 30 review rounds, and a result exposed
through a beta setting. Some changes also affected the interface outside the toggle. These are his reported
circumstances, not a controlled experiment or current release verification.
The useful move is converting a vague complaint into a repeated improvement process. The weakness is that
"design quality" initially has no stable definition. The video shows why that matters.

Chapter 2 The design sandbox sponsorship
02:32–04:07. The Magic Patterns segment is a sponsorship and a separate workflow. Theo describes supplying
a screenshot or source code, generating three variants, choosing one, and giving further direction. He
emphasizes that the variants contain code, and that a connected codebase could receive changes.
The examples include moving the sidebar, putting threads below other content, and offering a more compact
sidebar. Preserve the useful lesson: concrete alternatives make preferences easier to express. The transcript
does not establish that this product is required for the later council experiment, or independently verify the
sponsor's capabilities and customer claims.

Chapter 3 Turning criticism into a goal
04:16–06:39. A social exchange supplies concrete design complaints and motivation. Theo screenshots it and
starts a goal-oriented request: improve the UI, use screenshot review, require the council to score the result at
least 9/10, and make a UI polish PR.
He explicitly questions the value of the /goal prefix itself. A well-written ordinary prompt can describe the
same persistence and completion conditions. The durable mechanism is the task definition, tools, feedback,
and stop rule. The command spelling is incidental to that mechanism.
Notice what he delegates: implementation choices and repeated repair. Notice what he retains: the goal,
comparison standard, spending decisions, and eventual judgment about whether the result is actually good.


                                                                                       


---

<!-- Extracted page 4 of 19 -->


Chapter 4 How the council works
06:48–09:22. The public description calls for three strong models from different providers. The private version
names specific models. Each delegate receives the request and relevant context. Reviewers work read-only;
the coordinator collects useful findings, disagreements, and next steps. Each full pass is a round; fixes followed
by a fresh review start another round.
The council grew out of a simpler Sol review loop used for implementation feedback. Theo is testing whether
similar review can improve UI. He contrasts subjective design judgments with measurable goals: make a
function faster, reduce tool context while passing an eval, or send four times less startup data without UI
regressions across his existing threads.
Models can disagree with themselves on the same screenshot. Multiple high scores may be encouraging, but
agreement is not an independent correctness guarantee. The providers may share biases, and the prompt can
lead all reviewers toward the same answer.

Chapter 5 Initial changes and making evidence readable
09:30–12:25. The initial scores are roughly 6 to 6.5. After changes, the named main reviewers report about 7.5
to 8. Theo asks to see before-and-after screenshots, then asks for annotated differences because he cannot
easily see the subtle improvements.
Changes include the fallback font, relative emphasis of the thread title and nearby label, branch-name
truncation, card radii, and softer inline code without unnecessary borders. The branch-name change is
particularly useful: preserve the part that identifies the branch, rather than clipping the meaningful portion.
Annotated screenshots translate an agent's work into something a person can inspect. Keep both the clean
captures and the annotations. Arrows explain a difference; they do not prove that the change improves
usability.
The Gemini "jester" segment reports wrong commits, stale findings, incorrect failed-interrupt advice,
fabricated line numbers, invented syntax, and invented environment details. Preserve these as failure
examples. Do not turn the entertainment framing into your review policy. Verify every reviewer's evidence
using the same standard. Theo's aside that JavaScript numbers cannot overflow is too broad: Number
arithmetic can produce Infinity and can lose integer precision. The particular PNG claim would require its
actual code and input bounds.

Chapter 6 Why the first apparent success was insufficient
12:34–14:48. By round three, the council reaches 9/10. Theo still dislikes the result when he switches between
his app and other products. He starts a new thread, asks for another before-and-after review, and stacks
additional work on a new PR.
Then he supplies screenshots of Claude Code and Codex as comparisons. His new target is to score above
those references consistently. This gives the judges an external comparison that was absent from the original
request. The first run took about an hour to an hour and a half; he says the later run took almost 18 hours.
A fresh conversation can reduce accumulated assumptions. It needs a deliberate handoff: the exact code
revision, task, references, verification results, and unresolved questions. Otherwise it also discards useful
information.


                                                                                        


---

<!-- Extracted page 5 of 19 -->


Chapter 7 Competitive comparison and spending control
14:55–17:35. The previously approved design now scores about 7.4 with one reviewer, compared with about
7.0 for main. Another reviewer puts the improvement at 6.2 to 6.9. Different contexts change the scale. The
transcript's "four-point bump" corresponds to approximately 0.4 in the nearby numbers; the original table is
not included.
The scores for unchanged competitor screenshots also rise as the candidate improves. That is evidence of
judge drift. The screenshots did not improve. A table full of rising numbers is therefore insufficient evidence
that the product improved by the same amount.
To conserve usage, Theo stages the reviewers. First improve against Sol; add Opus after that score is high
enough; add Muse last. The transcript describes Sol rising through roughly 7.4, 8.1, 8.9, and 9.0. Opus later
reaches 9, while Muse still reports 7.9 and then hits a usage limit.
The lesson is to spend review effort where it changes a decision. Missing reviews must be recorded as not run
or blocked. A rate limit does not count as approval. A cheap initial reviewer can help diagnose obvious
weaknesses, but its preferences can also shape the work before anyone else sees it.

Chapter 8 Preserving a good version while exploring further
17:40–21:11. Theo sees better labels, hierarchy, border radii, fonts, indicators, and light-mode readability. He
forks the work and uses a separate worktree to pursue at least 9.5 in every category while keeping the earlier,
usable PR moving.
He delays slow reviewers until they are useful. Sol eventually reports exactly 9.5 in every category; Opus still
rates most categories below that threshold. Unchanged reference screenshots move again, including a reversal
in their ordering. Theo suspects that telling the reviewers the target score may influence them and considers
hiding that threshold from future reviewers.
He reports ten additional iterations to achieve the 9.5 target across delegates. This demonstrates the cost of
raising a subjective threshold. It does not establish that the last half-point corresponds to a meaningful user
benefit. Keep an accepted checkpoint so experimentation cannot consume or destabilize the useful version.

Chapter 9 Reading the cost claims correctly
21:18–23:11. Theo reports roughly 17.6 hours of parallel agent runtime and approximately $400 in modeled
usage. About $150 belongs to a later refinement, leaving roughly $250 attributed to the work already shown.
One model's price is unknown, so he substitutes another model's pricing. Some usage comes from
subscriptions rather than separate API charges.
These numbers are estimates within the video. Parallel runtime, elapsed time, API-equivalent cost, actual cash
paid, and subscription quota are different quantities. His claim that a subscription can provide $12,000 of
usage is not a verified allowance or a budget assumption for you.
He also notices a narrow-screen problem in a separate subscription-management UI. That reminder belongs in
the lesson: successful screenshots at one size leave other layouts untested. Use your real screen constraints
and verify them early.

Chapter 10 Giving useful direction after the loop converges
23:17–26:36. Theo raises the target to 10/10 and adds a specific preference: restore color because the
interface has become too grayscale. He observes a clearer merge button, better icon visibility, contrast



                                                                                       


---

<!-- Extracted page 6 of 19 -->


improvements, changed focus states, and much more readable syntax in light mode. The judges eventually
report very high scores.
The concrete preference matters more than the new number. A system can repeatedly optimize a bland result
if the rubric omits what you care about. Express preferences in observable terms: distinguish actions, preserve
meaning without color alone, keep the reading surface comfortable, and make focus visible.
Theo describes the mechanism as giving the model his own mental process: inspect the new screenshot,
compare it with old and competing designs, score, change, repeat. His enthusiasm is evidence of his
satisfaction; it is not a usability study. Your acceptance should include actually using the changed flow.

Chapter 11 Turning your own failures into an eval
26:43–28:57. The stronger example concerns T3 Code's Model Context Protocol tools. Agents had confused
actions such as creating a new thread and spawning a subagent, or had left thread visibility in the wrong state.
Theo collects failures from his history, categorizes them, and builds an evaluation.
He initially describes around 60 correct out of 88 cases. He moves work to a machine with access to the
necessary databases, tells the agent to treat a previous prompt as loose guidance, and directs it toward the
actual local data. After intervening MCP changes, he asks for another look so the work reflects the current
system. He answers questions that remain.
The resulting evaluation PR contains more than 2,000 lines and is still unmerged at that point. The useful
artifact is a repeatable test of tool behavior. It gives future changes a way to demonstrate improvement
instead of relying on descriptions that sound clearer.

Chapter 12 Correctness first and compression second
29:06–30:53. Theo later reports 66/85 correct, followed by a regression to 63/85. The transcript changes from
88 to 85 cases without explaining the exact suite revision. Do not combine those denominators into one
continuous benchmark.
His optimization order is explicit: reach a perfect score, commit and stabilize that state, establish the result
across the models he cares about, then reduce description size while retaining the score. The compression
target is one-third of the former size. He reports reductions of 52 percent without tool search and 78 percent
with tool search, where much of the available tool information can stay outside the initial context.
Those reported reductions do not establish that every configuration hit exactly one-third. Record each
configuration and denominator separately. A perfect observed score means all evaluated cases passed on the
reported runs. It does not guarantee every future call will be correct.
Theo says the change is in nightly and will reach stable, but that release status is part of the transcript's time
frame. The reusable lesson is that an expensive evaluation effort may lower repeated operating costs,
provided the observed behavior holds under further use.

Chapter 13 The engineering habit to keep
31:02–31:39. Theo considers merging and closes by encouraging engineers to invent ways for agents to
measure and improve their work. In this context, "reward" means feedback and selection in an iteration loop;
the video does not describe retraining model weights through reinforcement learning.
Keep the willingness to experiment. Keep the measurable failure cases. Keep the useful checkpoints. Your
repository's review and owner-approval rules still govern shipping; the video's spontaneous merge moment is
not a suitable substitute.

                                                                                         


---

<!-- Extracted page 7 of 19 -->


How Theo Matt and Lauren fit together
The transcript is Theo's. The additional contributions here come from current public source material by Matt
Pocock and Lauren, known as poteto. Use them as complementary practices and adapt them to the actual
task.

 Inspiration               Contribution to this workflow                   Use it when


                           Repeated improvement, comparative review,       You can define an outcome and inspect
 Theo
                           and turning recurring failures into evals       successive attempts


                           Clear behavior, shared terms, small
                                                                           You need to agree what to build or isolate a
 Matt Pocock               implementation slices, and tests at useful
                                                                           behavior change
                           public boundaries


                           A real application driving recipe, maintained
                                                                           An agent needs to demonstrate that the
 Lauren or poteto          feature coverage, and disciplined
                                                                           result works
                           measurement


Matt's current TDD instructions emphasize behavior through public interfaces, independently justified
expected values, and one vertical slice at a time. They warn against assertions that merely reproduce the
implementation. The current skill places refactoring in review, while the README still uses the broader red-
green-refactor language. Read the installed version before invoking it. The specific skill also requires
agreement on testing seams; reuse agreements already established for the task. [S2, S3]
His debugging workflow starts by creating a reliable failing signal and tightening it before diagnosis. A useful
reproduction gives hypothesis testing something to act on. For your work, that means an agent reporting "I
think this fixes it" should be able to name the observed failure and the check that changed. [S4]
Lauren's verification generator centers on launching a usable app, checking the instance, driving the real user
path, capturing actions and outcomes, and cleaning up without deleting evidence. It derives the recipe from
the repository and existing harnesses. An existing verification skill should be read and used before anyone
invents a replacement. [S5]
Her maintenance workflow separates documentation drift, harness gaps, and product defects. It checks
feature coverage from source and through live use; a broken feature must not be rewritten as acceptable
behavior just to make the documentation agree. Maintenance of that skill is a distinct task from fixing
application code. [S6]
Her hillclimb playbook fixes the workload and metric, validates the measurement harness, and measures each
hypothesis before keeping or reverting it. Her evaluation playbook also addresses blinding: judges receive
sanitized labels, and comparisons share one scoring scale. These practices address weaknesses visible in Theo's
subjective review loop. [S7, S8]


                                                                                            


---

<!-- Extracted page 8 of 19 -->


A workflow you can actually use
Define the behavior and the boundary
Write what a person should be able to do. Name the part of the product involved and what must remain true.
For a bug, state the trigger and expected outcome. For an optimization, name the workload and cost being
reduced. For UI work, state the task and the friction you want removed.
Ask the agent to inspect the repository before questioning you about facts it can observe. You should decide
product intent, unresolved tradeoffs, and permission boundaries. The agent should discover startup
commands, modules, existing tests, and verification instructions.
Use a small shared vocabulary. In a queue, "held", "queued", "running", and "cancelled" must each mean
something specific. Unclear terms can produce inconsistent UI and incorrect implementation even when
everyone agrees on the prose.

Establish a baseline and prove the check is sensitive
Record the code revision, build, fixture or input, environment, and command or user action. Reproduce the
complaint. A baseline that does not reproduce it cannot tell you whether you fixed it.
For a bug regression test, show that it fails for the relevant behavior on the old revision and passes after the
fix. A missing dependency or syntax error is not the intended failing result. If replaying the old revision is
infeasible, explain that limit and use another meaningful sensitivity check.
For a benchmark, show that the harness distinguishes an easy workload from the problematic one. Record
work completed and errors alongside timing or size. An implementation that silently skips half the workload
may look faster.
For a visual rubric, try a known weaker variant and a reference in the same comparison. If the judge praises
everything with no concrete differences, improve the review brief before spending hours optimizing against it.

Freeze the evaluation and protect the invariants
The implementation can change; the definition of success must remain stable during a comparison. Keep the
evaluator, test inputs, screenshot settings, and rubric identifiable. When a valid discovery requires changing
the evaluation, version it and rerun the baseline as well as the candidate.
Protect correctness with hard conditions. For a thread list, that might include opening the intended thread,
preserving a draft, keeping run status accurate, and maintaining keyboard access. A higher visual rating cannot
compensate for violating one of these conditions.
Keep held-out cases for evaluating generalization. The builder can use development examples to improve the
system; final evaluation should include relevant examples it has not optimized against. Rotate exposed held-
out cases into the development suite and acquire new ones when repeated use turns them into training
targets.

Change one coherent thing and measure it
State the hypothesis: "The sidebar gives branch metadata the same emphasis as the task title, so reducing that
emphasis should make the title easier to scan." Then implement the smallest coherent change that tests it.


                                                                                        


---

<!-- Extracted page 9 of 19 -->


One experiment may need several coordinated file edits. The point is causal clarity. Avoid mixing an unrelated
state-machine rewrite with a typography experiment. Measure the changed behavior, run the relevant
regression checks, and either keep the improvement or discard your own experiment safely.
Keep the last accepted version available. Use a separate worktree for a substantial exploratory branch when
the repository and environment support it. Different worktrees can still collide through ports, data directories,
browser profiles, or shared services, so isolate those too.

Review a fixed version and verify findings
Give each reviewer the same immutable commit or patch, requirements, and evidence set. Ask for concrete
findings and uncertainty. Initial reviews should be independent where possible: showing one judge the others'
answers invites agreement.
Keep reviewers read-only. The coordinator resolves conflicting advice and owns changes. After a fix, identify
the new revision and obtain a fresh review of the affected area. An approval of an older revision does not
cover new changes.
Do not expose a desired score to a visual judge. Use neutral labels, rotate order where practical, and request
specific reasons tied to the task. Keep the references unchanged. If scores shift while artifacts do not,
investigate the judge or rubric. Prefer a reasoned comparison over decimal precision that the process cannot
support.

Stop deliberately and present the result
Define a modest starting budget: one implementer, focused verification, and one fresh review when justified.
For an exploratory UI task, a suggested first experiment is at most three implementation rounds or 60 minutes,
with no new paid services. These are starting limits for this guide, not a benchmark or a requirement from the
source authors.
Stop when the behavior is demonstrated and remaining changes have little expected value. Also stop when the
budget is reached, the environment blocks meaningful verification, the metric is unstable, or progress requires
a product decision. Report the best accepted state and the remaining issue. Do not silently lower the goal or
keep resampling until a flattering score appears.
At completion, explain what changed, what you observed, the exact evidence, and what remains uncertain.
Run the current repository's required release checks on the final revision. For Vivary, verify and honor the
applicable owner-review gate before merging. Do not infer permission from a council score.


Applying the workflow to UI
Choose a small set of representative states before making changes. For Vivary, plausible examples are a long
thread list, a selected conversation with a long title and branch name, the composer with notices, a diff, and
queued or held runs. Confirm the actual states against the repository's feature map; these examples are not a
claim about the current implementation.
Use consistent content, window size, zoom, theme, loading state, and capture method for before-and-after
comparisons. Wait for fonts and layout to settle. Label screenshots with the build and scenario. Keep private
conversation content out of shareable evidence by using controlled fixtures.


                                                                                       


---

<!-- Extracted page 10 of 19 -->


 Concern                   Evidence to collect                            Acceptance question


                           Matched screenshots with realistic long        Can you identify the task and current state
 Hierarchy and density
                           content                                        without hunting?


                           Live interaction with the primary and          Is the intended action understandable and
 Action clarity
                           secondary actions                              does it work?


                                                                          Does the visible portion preserve useful
 Truncation                Long titles, names, and identifiers
                                                                          identity?


                           Light and dark states; relevant contrast
 Readability and color                                                    Are text and meaningful controls legible?
                           measurements


                           Keyboard interaction plus visible focus        Can the flow be completed and focus
 Keyboard and focus
                           evidence                                       recovered?


                                                                          Do required controls remain reachable
 Layout resilience         Supported sizes and increased zoom
                                                                          without broken overlap?


                                                                          Do drafts, selection, and statuses behave as
 State preservation        Navigate, reload, and restart where relevant
                                                                          specified?


Keep aesthetic feedback separate from these checks. A judge can suggest that a sidebar feels noisy. The agent
then needs an actual change and a comparison. An automated accessibility scan can identify some defects, but
keyboard and real task checks still matter.
Use a small rubric with concrete criteria such as hierarchy, readability, action clarity, consistency, and identity.
Give each criterion an explanation and anchor examples. A 9.3 should not be treated as a calibrated scientific
measurement. Your own use of the interface can reject a council's conclusion.


Applying the workflow to agent tools and prompts
Start with your real failures. For each example, record the user request, relevant context, tools available at
that moment, expected action, forbidden action, and observed result. Preserve the distinction between a
planning failure, the wrong tool choice, invalid arguments, a tool execution failure, and a wrong final state.
A possible Vivary case is: "Delegate a read-only review of this change." The expected behavior might be an
isolated reviewer with the intended context. A failure could be opening an unrelated visible conversation or
allowing edits. Those expectations must match the actual product contract.
Build two useful layers. A routing check can validate tool choice and arguments with controlled boundaries. A
smaller integration suite must exercise meaningful end-to-end behavior against the real service. A syntactically
correct call can still operate on the wrong project or leave the wrong state.
Pin the evaluation inputs, model version or identifier, generation settings, tool schema, relevant prompt text,
and evaluator revision. Keep transcript evidence for classification. Repeat enough trials to see variation and



                                                                                         


---

<!-- Extracted page 11 of 19 -->


report all runs, including infrastructure failures. Compare baseline and candidate with matched conditions and
a predeclared aggregation method; do not select only the best run.
After correctness stabilizes, compress tool descriptions or other repeated context. Preserve distinctions that
prevent failures: preconditions, action semantics, required arguments, side effects, and recovery behavior.
Measure the actual serialized context with the provider's tokenizer or available usage data. Character count
alone is not token usage.
Track initial tool context separately from total interaction cost. Tool search can reduce the initial context while
later retrieval and extra calls add costs. A shorter description that increases retries may cost more overall.
Include task success, tool errors, latency, and total tokens when they matter to the decision.
Do not encode answers to known examples, relax assertions, remove hard cases, or teach agents to recognize
the evaluation. If the evaluation itself is wrong, correct it transparently and rerun both versions. A passing
score is useful only when the check still represents the intended work.


Using your installed skills without creating another process maze
Your local verification skill should provide the concrete commands and selectors. The guide supplies the
experimental method around it. Read the skill and relevant feature map, verify that they still match the app,
then use them. Do not paste a new universal framework over working project instructions.
T-Stack's public README describes the following skills. The installed version may differ; check it before
invocation. Its council and Sol loop require a harness that can actually run the other models. Calling one model
three times is not a three-provider council. [S1]

 Skill                      Purpose


 council                    Review through three model providers


 sol-loop                   Iterate on review with Sol


 file-pr                    Prepare a concise, problem-led PR


 babysit-pr                 Follow CI and review findings


 full-stop                  Carry work to a PR ready for the owner


 full-send                  Carry work through merge when authorized


 takeover                   Continue an existing PR, branch, or thread


 modernize                  Reassess and rebase older work


 leaving-pr-comments        Format agent-authored comments


                                                                                       


---

<!-- Extracted page 12 of 19 -->


Keep one top-level owner for the task. Invoke only the specialist steps that answer a real need. Do not nest
several autonomous controllers and let each launch a full review loop. Honor the current task's permission
boundaries, especially external comments, publishing, and merges.
Keep local preferences and model assignments in the repository's appropriate instruction file when you
deliberately adopt them. The runbook does not install skills, create automation, alter review gates, or
authorize a deployment.


A first practice task
Choose one annoyance in a real flow you use frequently. A useful first target is a thread label whose important
information disappears at a narrow width. Before choosing it, confirm that the behavior exists in the current
build.
1. Explain the problem in one sentence and identify the task the user is trying to complete.
2. Have the agent locate the relevant source and verification recipe. Ask it to reproduce the issue with realistic
content.
3. Save the baseline and state which behavior must remain unchanged.
4. Let it make one coherent change and verify the same scenario again.
5. Inspect the annotated difference, then use the actual flow yourself. Ask for a fresh review if a meaningful
uncertainty remains.
6. Keep or reject the change based on the evidence. Record a missed case in the existing feature map or test
suite if it will prevent recurrence.
For a later exercise, collect five genuine examples of agents choosing the wrong operation. Turn those into a
small tool-routing eval. Keep some additional examples out of the optimization loop. Improve correctness first.
Only then experiment with shorter instructions.
To check your understanding, explain why a model giving 9/10 is weaker evidence than a repeatable user
journey for a persistence claim. Explain why a benchmark needs a work-completed count. Explain what you
must do if you change the rubric halfway through a comparison. If these answers are clear, you understand the
mechanism well enough to begin.


What to demand from a completion report
A useful completion report names the user-visible change and the code revision, states the scenarios
exercised, points to relevant evidence, and identifies remaining gaps. For a measurement, include baseline,
candidate, variation, workload, and units. For a review, distinguish confirmed defects from suggestions and
uncertain claims.
Use a compact record: goal; revision; environment; check; expected result; observed result; evidence;
limitations; next action. Keep this in an existing PR, task note, or verification report. Do not create a new
administrative system just to store eight fields.
The agent should say "the draft survived reload and restart in these two scenarios" when that is what it
observed. It should not inflate that into "persistence is fully proven." Strong work can state its limits precisely.


                                                                                        


---

<!-- Extracted page 13 of 19 -->


Source and transcription notes
The supplied transcript runs from 00:00 to 31:39 and contains 13 chapter labels. The attachment does not
include the video URL, original screenshots, PR links, full review tables, or executable eval. The timestamped
text supports the account of what Theo describes; it does not let us independently rerun the experiment.
The automatic transcript contains naming and number errors. "Codeex" is treated as Codex and "cloud code"
as Claude Code when context makes the meaning clear. "Soul" appears to refer to Sol. Other model names and
versions are preserved as transcript labels without asserting their present availability. "65", "74", and similar
flattened scores are interpreted from the nearby out-of-ten discussion. The prompt appendix preserves
original wording, including errors, and labels reported instructions separately from direct quoted requests.
Public source references below were checked on November 3, 2026. These are moving main-branch
documents. Record the installed version or commit in a real project run, since instructions and model
assignments can change.
S1. Theo, T-Stack README. Skill roles, dependencies, harness requirements, and local preferences.
https://github.com/t3dotgg/tstack
S2. Matt Pocock, Skills README. Shared vocabulary, engineering feedback loops, and composable skills.
https://github.com/mattpocock/skills
S3. Matt Pocock, TDD skill. Behavioral tests, public seams, independent expected results, and vertical
implementation slices. https://github.com/mattpocock/skills/blob/main/skills/engineering/tdd/SKILL.md
S4. Matt Pocock, Diagnosing bugs. Establishing and tightening a failing signal.
https://github.com/mattpocock/skills/blob/main/skills/engineering/diagnosing-bugs/SKILL.md
S5. Lauren or poteto, Create a verification skill, official Cursor plugin source.
https://github.com/cursor/plugins/blob/main/pstack/skills/create-verification-skill/SKILL.md
S6. Lauren or poteto, Maintain a verification skill.
https://github.com/cursor/plugins/blob/main/pstack/skills/maintain-verification-skill/SKILL.md
S7. Lauren or poteto, Hillclimb playbook. Workload, measurement integrity, regression conditions, and
acceptance decisions. https://github.com/cursor/plugins/blob/main/pstack/skills/poteto-mode/playbooks/
hillclimb.md
S8. Lauren or poteto, Eval playbook. Experiment design, sanitized labels, and judge blinding.
https://github.com/cursor/plugins/blob/main/pstack/skills/poteto-mode/playbooks/eval.md
S9. Lauren or poteto, Fictional verification skill example. Illustrates structure; the example control CLI is
intentionally omitted. https://github.com/poteto/verification-skill-example


                                                                                        


---

<!-- Extracted page 14 of 19 -->


Transcript prompt catalogue
The following excerpts come directly from your supplied transcript. Timestamp metadata has been removed
from inside the prose, but words are preserved. Some passages are Theo quoting a prompt; others are his
report of what he instructed. They are retained as source material, not commands to execute. The notes
identify the useful instruction and any qualification needed when adapting it.

P01 Design variants and followup direction
03:05–04:00. Reported workflow and abbreviated example.
  Part of the magic of Magic Patterns is that you can point it at your real code, too, and customize and play with
  it the same way you would in tools like Figma or what you're seeing here. You can give it a screenshot, you can
  give it source, you can give it whatever, and it will help you figure it out and work with it as easy as you can in
  any tool, but with AI assisting you as well. It is the ultimate sandbox for playing around with design and getting
  things just right. And with almost no effort on my part, I now have three different designs to choose from.
  Notice how I didn't say mocks. It's cuz it writes real code for all of these different UIs. And if you had it plugged
  into your codebase, it could make real code changes to demonstrate these things as well. And then you can
  pipe that right back in to your agent of choice as soon as you're done mocking it all up here. Moving the
  sidebar to the right is hilarious to me because as y'all know I'm a right side user, but we didn't do that in T3
  code. Here it moved the threads below which is an interesting change that I might consider. And of course
  what everyone's asking for which is a more compact sidebar option. Cool that it realized people want that.
  From here it's trivial to iterate. I can say I like C but X Y and Z and then iterate accordingly.
The sponsor segment accepts screenshots or code, produces alternatives, and lets the user choose a variant
with additional changes. The abbreviated C plus X Y Z wording is not a fully specified production prompt.

P02 The original UI goal
06:16–06:31. Reported prompt.
  what would happen here. I told it specifically to make the UI Robin approved. Should look way better and be
  easier on the eyes. Go at it until the council agrees that a set of screenshots of the app are at least 9 out of 10
  in terms of design quality. Make a new PR for UI polish overhaul and keep iterating until you've made the
  whole council happy. If you're not familiar
The request combines a named human standard, screenshots, a score threshold, a new PR, and repeated
iteration. The screenshot of the social exchange supplies context that is absent from the text attachment.

P03 The council instructions
06:56–08:08. Skill text mixed with commentary.
  Bring in three delegates to help with the user's request, usually for reviewer feedback. Use one strong model
  from each of the three different providers. I did that that way because I wanted this to be more generic. I
  actually don't want it this generic. I'm probably going to go in and update it accordingly. My version is much
  less generic. So, here is the version I'm using right now. Use the skill only from quad code, codeex, or muse. I
  should probably remove that bit. Doesn't matter that much. I that just happened. Something slopped when I
  told it to get anti-gravity not know about it. The reason why you'll see in a second silly bring these three
  delegates in to help with users requests usually for reviewer feedback. Obus 55, Muse Wonderful, and Codeex
  GPT 6.1. I specify how to do this in T3 code. If you're not using T3 code, good luck figuring out how to do this
  right. I have put a lot of effort in. Give each delegate the request in relevant contexts. For reviewer feedback,
  keep the work read only. Collect their responses and summarize the useful findings, disagreements, and


                                                                                           


---

<!-- Extracted page 15 of 19 -->


   recommend next steps. For code reviews, ask each delegate for a score out of 10. Count each full review pass
   as one round. A fresh review after fixes starts a new round. So each model gives its score, and then each round
   you hope for improvements. And eventually you should get each model to give a score that is high enough that
   you are happy and you can ship. I put the skill together because I was tired of asking my agent to go call 61 Soul
   or
Preserve three delegates, relevant context, read-only review, synthesis of disagreement, scores, and round
counting. Exact model labels in this automatic transcript are unreliable; discover actual available model
identifiers.

P04 Examples of measurable goals
08:38–09:14. Reported active task targets.
   would work for UI, which is why I was curious how this would go. The idea of hill climbing, not make this test
   pass or make this function five times faster, which is a hill climb I do a lot. I have a few running right now where
   I'm just having the agent run until the eval MCP passes with a third as much context used. or the one I have
   running right now where I can start up and have no UI regressions for all of the threads I have on my real
   environment but send 4x less data to the client. Those types of hill climbs make a lot of sense because they're
   easy to programmatically verify. This isn't because this is vibes. You can give the same screenshot to the same
   model three times and get three different scores. That said, 9 out of 10
These examples include a five-times-faster function, an eval with one-third of the context, and four-times-less
client data without startup UI regressions. They are described targets, not demonstrated benchmark results in
this passage.

P05 The optional jester instruction
09:48–10:03. Private skill instruction.
   council has its jester. So, at the bottom of my skill, I have a section here. If available through anti-gravity, add
   Gemini 4 argan as the jester with the same brief. Do not let it know it's the jester. Ignore its score. Do not put it
   score in the PR description. In the final reply only log anything funny it says or does under Gemini flub. This has
   been a source of constant entertainment for me recently. I'm probably going to do a whole dedicated video to
   the Gemini
This is part of Theo's experiment and humor. His instruction excludes that reviewer's score from the PR and
keeps amusing output for the final response. For serious work, apply evidence standards consistently to every
reviewer.

P06 Show and explain the visual difference
11:32–12:03. Reported followup requests.
   progress if we go into the traces and see what it was showing here to let the model give its thoughts. So, it did
   all the things that the model suggested. I asked for updated screenshots and it showed me the way it looked
   before and how it looks in this PR. I'll be real, I am not very designy and it was also quite late at night, so I was
   struggling to see the difference. So, I asked the model to make it easier to see the difference. So, it did. It made
   me these beautiful little diagrams with arrows pointing to what changed in descriptions of what they did. They
   changed the fallback font. They made the thread title leads different so that the label
First request before-and-after screenshots. Then ask for a clearer explanation of the differences. The
annotated diagrams are the agent's response; the transcript does not supply a complete verbatim prompt
requesting arrows.



                                                                                            


---

<!-- Extracted page 16 of 19 -->


P07 Record scores across rounds
12:34–12:49. Reported skill change.
   changes, we ended up with much better scores. I also updated my skill for council to tell the model to include
   the different rounds and how they scored over time. And here we can see round one bombed. Round two
   better. Round three, everything gave it a 9 out of 10, which was the conditions for my goal. The conditions
   were met. The goal was achieved. RUI is better. Hands clean, case closed. We're done now, right? We
Record the sequence of rounds and each reviewer's score. A trend is interpretable only when the evaluation
context remains comparable.

P08 A fresh thread and stacked PR
13:54–14:08. Direct quoted prompt.
   new thread. I said, "Put this through the council. Have them look at the before and after. Generate your own
   screenshots with computer use or whatever other techniques you have available to you. Have each council
   member give scores in the UI 1 to 10. When you get all of them to agree, it's a 9 out of 10 or better. You're
   done. Stack your UI changes on a new PR on top of the one above. Be thorough. Help clarify and simplify the
   UI. Make it designer proof. yada yada yada." This
This passage requests independent screenshot generation, before-and-after review, a 9/10 threshold, a new
PR stacked on the existing one, and clarity and simplification. The phrase designer proof is aspirational and
needs concrete criteria.

P09 Add competing products
14:33–14:41. Followup prompt mixed with commentary.
   few minutes in. Here are some examples from Claude Code and Codeex. Add them into the comparison and
   judgement panel somehow. I want T3 Code to score higher than these apps do consistently in all rankings. That
   was it. The previous thread ran for about an hour. This one
The supplied external screenshots become comparison anchors. The original images are not in the attachment,
so they cannot be reconstructed faithfully from this text.

P10 Stage the expensive reviewers
17:06–17:14. Direct quoted instruction.
   agent, "Hey, stop asking Muse and Opus until Soul's score is high enough. Then you can start asking Opus. And
   then when that score is high enough, you can finally ask Muse." Cuz I was about to run out of Muse usage. I
   only have one account for it. So that's why we got the not runs here. But 61 soul start at 74.
Ask Sol first, then Opus, then Muse after earlier scores are sufficient. Record unrun reviews explicitly. Your
selection should follow available capabilities and budget.

P11 Fork the exploration and aim higher
18:42–19:13. Reported prompt and orchestration.
   Here's where I said to branch off into a new work tree and iterate until you get a 9.5 or better in all categories
   include Gemini because I I wanted my jester back. Okay. Also, this one was a fork cuz I had the other thread
   maintained because I wanted to have that keep updating the original PR cuz that was already better enough
   that it was mergeable, but I wanted to go further. I wanted to see just how far this insane way of building could
   go. So, I made a fork, which of course ether code supports. told it make a new work tree because we're gonna


                                                                                         


---

<!-- Extracted page 17 of 19 -->


  keep going. Your new goal 9.5 or better. I noticed that it was getting stuck because Gemini is both bad and
  slow. So, I told it to not like
Use a new worktree, preserve progress on the original PR, and seek 9.5 or better in every category. Keep
exploration separate from the accepted version.

P12 Delay a slow optional reviewer
19:13–19:21. Reported followup instruction.
  goal 9.5 or better. I noticed that it was getting stuck because Gemini is both bad and slow. So, I told it to not
  like bring Gemini in yet. Wait on Gemini until we have other slower models like Opus. Don't let Gemini delay
  you. So, again, cuz I was telling it just use Soul until Soul scores are high enough,
The exact sentence spans two timestamp segments and includes surrounding context. The operational point is
to avoid making an optional reviewer the critical path.

P13 Hide the score target from future judges
20:19–20:42. Reflection and proposed future change.
  the screenshots didn't change. LMS and non-determinism are crazy. Even just saying that I want a 9.5 in the
  prompt here might be enough to cause it to behave wrong. Yeah, I put T3 at a 9.3 overall, not 9.5. The fact that
  I set this goal and the sub aent knows about it might have influenced the scores. In the future, I might tell the
  parent agent to not let the sub agents know that there is a score they're trying to hit. You guys want to guess
  how many runs it took? The previous things we showed were three runs and four, maybe
Theo suspects target leakage and proposes withholding the threshold from subagents. The transcript does not
establish that he implemented this blinding in the run shown.

P14 Remember the narrow screen
22:16–22:24. Reported reminder about another UI.
  the future. I've only burned 30% of one of my subs. Right now, I got a lot more to do here. Also, I have to tell
  my agent that uh this UI needs to work on this uh Nero screen, but I'm good on usage. I actually have less
  codecs
The subscription-management interface also needs to work on a narrow screen. This is a separate observation,
included because it reveals a missing acceptance condition.

P15 Pursue tens and restore color
23:17–24:04. Reported goal and quoted design direction.
  another where I wanted 10 out of 10 in every category. And this one's been running since I started my day and
  I honestly kind of forgot about it. It's definitely still going. And it looks like it's getting 10 out of 10 from things
  now. Apparently Soul gave it a 10 out of 10 in every single category. How' Opus do? Mostly tens, but color and
  contrast got a 9.5. Oh, it's going deep. It's like caring about the diff views and [ __ ] Oh, wow. Yeah, this looks a
  lot better. Oh, boy. I I did add a little more context in the prompt this time that I want color back cuz I hated
  how grayscale things had gotten. Yeah. I said, I feel like the new design is too grayscale. Make sure the new
  improvements help restore some color. Let's take a look. Oh, yep. Yeah, I immediately prefer this. Merge is
  much more clearly a button. The color of this is way better. The icon is more visible.
The useful new requirement is to restore color after excessive grayscale. Do not interpret a 10/10 target as a
mathematically meaningful finish line.


                                                                                              


---

<!-- Extracted page 18 of 19 -->


P16 Express the human evaluation process
25:34–25:59. General instruction and mental model.
   the models just blew past it. There was nothing special here. Like my skill was very very basic. You could just
   copy paste the text in and say rank it with these models and tell you their score is this high. I'm not hiding
   something special here. I'm just giving the LLM my mental model for how I would do this. I would look at the
   new screenshot. I would compare it to the other products and the old screenshot and then score it and then do
   it again and again and again until the thing's good. And if you can get yourself into this mindset, Muse just gave
   it 10 out of 10. Previously, the other models gave it 9 out of 10 in
This describes inspection, comparison, scoring, and repetition. It is a recipe for directing agents, not a special
command or hidden capability.

P17 Turn recurring mistakes into cases
27:22–27:46. Reported method and task setup.
   wanted them to settle. Those types of things. So I took all the times in my own history that models did the
   wrong thing. I categorized them and then I turned it into an eval. And then I ran it against sonet 5.5. And of all
   of the things that I had collected, it got 60 or so out of the 88 correct, which means the other 28 were wrong.
   So I now have a set of things, but the description does not serve properly. And I gave two specific tasks to the
   agent. So, I initially started this thread on another machine where I was going in depth on
Collect failures, categorize them, and build an eval. The full historical examples and the complete initial two-
task prompt are not present in the attachment.

P18 Use the right machine and source of truth
28:07–28:16. Reported prompt wording.
   I told I'm trying to workshop T3 Codes MCP and tool descriptions. Here's a prompt it wrote. Didn't give enough
   context. It's from another machine. You should probably read from the T3 code DBs directly instead of click
   house. recall. Treat this prompt as vague guidance on what it's looking for, not specific instructions. And this
   was me after the failures on this other box, writing up a prompt on what went wrong.
The agent is told to read the relevant databases directly and treat a previous machine's prompt as vague
guidance. This illustrates refreshing context instead of executing stale instructions mechanically.

P19 Recheck after merged changes
28:27–28:40. Reported followup and answers.
   It then went around for a while, drafted some steps, asked it to take another look because I just merged
   changes to some of the MCP stuff, specifically what uh models were being exposed over it. It had some
   questions. I answered them. After a bunch of work, I ended up with a PR that had a full evaluation with all
   those failure cases and more. That was over 2,000 lines of code. I still
Theo asks the agent to inspect again after MCP changes and answers its remaining questions. The questions
and answers themselves are not included, so the guide cannot invent them.

P20 Reach correctness then compress
29:06–29:37. Reported ordered instructions.
   run after it made changes was only 63 out of 85. The score went down. And when I told it that, well, I told it to
   get the score up. The order of events I gave it was get a perfect score. So all the failure stop, commit that,


                                                                                           


---

<!-- Extracted page 19 of 19 -->


   stabilize there, make sure all the models we care about get a perfect score there. Now your job is the opposite.
   You need to delete as much as you possibly can from the descriptions because those are bloating the context. I
   want it to be a third the size it was before and still get a perfect score. And this thread ran for [ __ ] ever, but it
   did it. To be very clear, this absolutely worked. You could see the difference in how much context was being
   used before and after. We cut it
First achieve and stabilize the evaluation result across relevant models. Then reduce descriptions toward one-
third of their original size while preserving success. The reported 85-case suite differs from the earlier 88-case
count.

P21 Preserve the evaluation for future changes
30:13–30:30. Reported intended repository practice.
   very soon. I had to spend a shitload of tokens to do this. But now less tokens are used and I have proven that
   the result will be better not worse because I have an evaluation for it. And if I commit and push that eval then
   we have a way to test changes reliably. This all is chaos because as we know LLMs are non-deterministic, but
   they also allow for a level of like flexibility and tedium in your work that make things
Commit and push the evaluation so later changes can be checked. The transcript describes this conditionally; it
is not confirmation that the evaluation PR was merged.

P22 The final merge impulse
30:53–31:15. Discussion with the audience.
   achieved the goal right now. I've had this running for most of the workday and I'm I'm at the point where I
   might just yolo merge this. It's so much better. Do I do it, guys? Do I just hit the button? If the team is mad, I'm
   blaming you guys. I got LLMs to make better UI than anyone on our team was capable of. We're living in weird
   times. If you take anything from this video, it's that being a clever, weird engineer is so fun right now. If you
   can come up with these
Preserved for completeness. The clip shows enthusiasm about merging; your current repository gates and
authorization remain the rule.

P23 Generalize the loop
31:15–31:39. Closing teaching instruction.
   living in weird times. If you take anything from this video, it's that being a clever, weird engineer is so fun right
   now. If you can come up with these weird ways to let models measure themselves and the work they're doing
   and just climb the hill blindly, they will do it and they will make things that are good. You need to reward them
   for succeeding at their tasks. But if you can find a way to do that, oh man, the world's your oyster. I've been
   having so much fun doing stuff like this and I hope that this video will help you see ways to do it yourself. Until
   next time though, peace nerds.
Find ways to measure the work and feed success or failure back into subsequent attempts. This does not imply
model training or justify optimizing a misleading metric.


                                                                                             