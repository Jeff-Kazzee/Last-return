# Hill climbing with a council: Theo's method, extracted

Source: Theo's video on redesigning T3 Code's UI with agents, then cutting T3 Code's MCP token cost with an eval. Transcript supplied by Jeff, Nov 2026.

Who this is for: Jeff, and any agent working in Jeff's repos.

How to use it:

- An agent told to "hill climb", "run the council", or "put this through the council" reads sections 2, 4, 5, 6 and 9. Section 9 is the skill.
- Jeff reads the HTML study guide first. He comes back to this file when he needs exact wording or the full run log.
- Sections 1 to 7 are Theo's material with nothing dropped. Sections 8 to 10 are the adaptation to Jeff's stack.

Words: Theo says "delegate" and "council member". This file says "judge" for the same thing. Theo's "round" and "hill climb" are kept as he uses them.

---

## 1. The one idea

A hill climb is a loop. The agent changes the work. A scorer scores the work. The agent keeps what raised the score and repeats until the score reaches a number you set. You decide where the top of the hill is. The agent climbs without seeing the hill.

There are two kinds of scorer.

1. Programmatic. A test, an eval, a benchmark, a byte count. Deterministic or close to it. This is Theo's preference and he says so directly.
2. A model council. Several strong models from different providers each look at the output and score it out of 10. Noisy. Used when nothing programmatic can measure what you care about, like whether a UI looks good.

Theo's ranking of the two, in his words: having other models look at the thing is "silly but working". Programmatic scorers are better. If you can turn a problem into a program that gives a score, your agents will make that score go up.

What happened in the video:

- About 18 hours of agent runtime across five models and 30-plus review rounds.
- The result shipped as a toggle in T3 Code's beta tab. Some changes leaked into the default UI regardless of the toggle.
- Cost: about $250 for everything shown, about $400 including a later refinement run.
- The same loop, with a programmatic scorer, then cut T3 Code's MCP tool-description tokens by 52% to 78% with an eval proving behavior did not regress. That is live in the nightly build.

Theo's claim about why it worked: nothing was special. The skill was basic. He gave the model his own mental process. Look at the new screenshot. Compare it to the old screenshot and to other products. Score it. Do it again until it is good.

Hill climbs Theo runs that are programmatic, for reference:

- Make this test pass.
- Make this function five times faster.
- Run until the eval MCP passes with a third as much context used.
- Start up with no UI regressions across all threads in his real environment while sending 4x less data to the client.

He calls those easy because a program can verify them. The UI climb is different because it is vibes. The same screenshot given to the same model three times gets three scores. His argument for doing it anyway: 9/10 and 10/10 are hard enough to get that if several models give it, the thing is probably better.

---

## 2. The council skill, line by line

Theo has a public version and a private version. He said in the video he will tighten the public one.

### 2.1 Public version

This is the whole thing:

> Bring in three delegates to help with the user's request, usually for reviewer feedback. Use one strong model from each of the three different providers.

Generic on purpose so anyone can run it. Jeff's T-Stack plugin install most likely carries this version. It is the starting point, not the method.

### 2.2 Private version

Reconstructed from what he showed on screen. Each line, then why it exists.

1. Use the skill only from Claude Code, Codex, or Muse.
   Scopes which runtime may invoke the council. He says he should remove it. It exists because he told the agent to keep Antigravity (Gemini's runtime) from knowing about the council and the instruction slopped into the skill.

2. Bring these three delegates in to help with the user's request, usually for reviewer feedback: Opus 5.5, Muse Wonderful, Codex GPT-6.1.
   Three named models, three providers. Independence of judges is the whole point of a council.

3. (A section on how to spawn each delegate inside T3 Code.)
   T3 Code can spawn sub-agents that run on his subscriptions and report back into the thread. He says outside T3 Code you are on your own. Section 8 covers how Jeff does it.

4. Give each delegate the request and relevant context.
   Judges get the brief and the material. They do not get the chat history.

5. For reviewer feedback, keep the work read-only.
   Judges do not edit. One worker makes changes. The council only scores.

6. Collect their responses and summarize the useful findings, disagreements, and recommended next steps.
   The parent agent synthesizes. Disagreements are reported, not averaged.

7. For code reviews, ask each delegate for a score out of 10.

8. Count each full review pass as one round. A fresh review after fixes starts a new round.
   The round is the unit of progress.

9. Added during the video: include each round and how every delegate scored over time.
   This is the per-round score table. It is how he saw "round one bombed, round two better, round three all 9s" at a glance in the PR.

10. The jester section, at the bottom of the skill:
    If available through Antigravity, add Gemini 4 Argan as the jester with the same brief. Do not let it know it is the jester. Ignore its score. Do not put its score in the PR description. In the final reply, only log anything funny it says or does under "Gemini flub".
    A fourth model gets the same brief and zero influence. Its output is entertainment and a reference for what a bad judge looks like.

### 2.3 Where it came from

Before the council Theo ran "Soul Loop": have GPT-6.1 Soul give code feedback aggressively until it says "that's fine." The council replaces one aggressive critic with three independent ones who have to agree. He had used it for code and implementation vetting. UI was the first vibes-only use and he did not know if it would work.

---

## 3. What the judges scored

Each judge scores each round. Scores are out of 10. Later rounds scored by category. Categories named in the transcript:

- hierarchy
- typography
- iconography
- color and contrast
- an overall score

Once reference points were added, Claude Code and Codex screenshots were scored in the same panel every round.

---

## 4. The run, phase by phase

Prompts are normalized from an auto-captioned transcript. Wording is cleaned, content is not changed. Where the transcript only describes a prompt, the description is in square brackets.

### Phase 0: The trigger

- Maria posted that T3 Code is set up to be this generation's VS Code.
- Robin replied: not pleasant looking, needs a UI/UX pass. Fonts, border radius, icons, font hierarchy. He said he reinstalls every few weeks and cannot get past it.
- Theo joked he would hire Robin for 100% of current T3 Code revenue, which is zero. Then he got defensive: every agentic dev environment has rough UI patches, T3 Code is at least consistent, and Orchestrator V2 had fixed a lot of polish. Robin was not moved. Theo screenshotted the whole exchange.

The screenshot became the brief. He did not rewrite Robin's complaint into requirements.

### Phase 1: /goal, first council run

Runtime: about 1 to 1.5 hours.

Prompt, with the Twitter screenshot attached:

```
Make the UI Robin-approved. It should look way better and be easier on the eyes.
Go at it until the council agrees that a set of screenshots of the app are at least 9 out of 10 in terms of design quality.
Make a new PR for the UI polish overhaul and keep iterating until you've made the whole council happy.
```

On /goal: Theo calls it the quickest way to burn tokens and get nothing. He still mostly believes that. His reasoning: remove /goal, write the right prompt, and it should do the same thing. He used it here because he had tokens about to reset.

Round 1, scoring the existing UI:

| Judge | Score |
|---|---|
| Opus 5.5 | 6 |
| GPT-6.1 Soul (Codex) | 6.5 |
| Muse Wonderful | 6 |
| Gemini 4 Argan (jester, ignored) | 6.5 |

Opus listed a lot it did not like and a lot of recommendations. The worker applied them. Theo opened the traces to see what each judge had been shown and what it said back. That is a habit, not a one-off: when a score surprises you, read the judge's trace before you trust or dismiss it.

Round 2:

| Judge | Score |
|---|---|
| Opus | 8 |
| Soul | 8 |
| Muse | 7.5 |

Round 3: every judge 9. Goal met. PR open.

What changed in the UI across those rounds:

- Fallback font.
- Thread title weight, so the label above it recedes.
- Branch name truncation. It was cutting off the meaningful end instead of the meaningless start.
- Card border radius.
- Inline code softened. Borders around it removed.

Side instruction. It was late, he is not a designer, and he could not see the before/after difference. He asked the agent to make the difference easier to see. The agent produced annotated screenshots with arrows pointing at each change and a one-line description per arrow.

He also updated the council skill at this point to record scores per round.

### Phase 2: Fresh thread, stacked PR, reference points added

Runtime: almost 18 hours. He watched this one. He normally ignores threads until they finish.

He looked at T3 Code, Claude Code and ChatGPT side by side. Better than before. Not where he wanted. His line: "I don't just want T3 Code to look better than T3 Code. I want T3 Code to look better than everything else."

New thread. He pasted the Phase 1 PR as the input. Prompt:

```
Put this through the council. Have them look at the before and after.
Generate your own screenshots with computer use or whatever other techniques you have available to you.
Have each council member give scores on the UI, 1 to 10.
When you get all of them to agree it's a 9 out of 10 or better, you're done.
Stack your UI changes on a new PR on top of the one above.
Be thorough. Help clarify and simplify the UI. Make it designer-proof.
```

Why a new thread: to clear out the context.

A few minutes in, a follow-up with screenshots of Claude Code and Codex attached:

```
Here are some examples from Claude Code and Codex. Add them into the comparison and judgment panel somehow.
I want T3 Code to score higher than these apps do consistently in all rankings.
```

His reasoning: he could see the gap when he tabbed between the three apps. So maybe the models could too. The judges are Claude Code and Codex models, and they do not know what their own apps look like. The screenshots gave them that.

What the scores did once reference points existed:

- Codex (Soul): T3 main scored 6.7 to 7.8 across categories, average 7. The Phase 1 PR, which Soul had just given a 9, now scored 7.4.
- Opus: T3 current 6.7. The PR was a 0.4 bump, the same bump Soul saw. Opus scored Claude Code and Codex each 0.1 lower than Soul had, with the same 0.1 gap between them. Opus rated Codex above Claude Code.
- Muse: T3 main 6.2, current 6.9, Claude Code 8.1, Codex 7.6. Muse found Codex unclear. Theo agreed.

Theo's read: look at one design with nothing to compare it to and you think it is fine. Put other designs next to it and the score changes.

Second observation: as T3's score went up, Claude Code and Codex scores went up too. They started around 8.3 and 8.5 and ended in the 9s. The screenshots never changed.

Judge gating instruction, sent mid-run because he has one Muse account and was about to run out:

```
Stop asking Muse and Opus until Soul's score is high enough.
Then you can start asking Opus.
When that score is high enough, you can finally ask Muse.
```

Scores under gating:

| Round | Soul | Opus | Muse |
|---|---|---|---|
| 1 | 7.4 | not run | not run |
| 2 | 8.1 | not run | not run |
| 3 | 8.9 | not run | not run |
| 4 | 9 | 7.1 | not run |
| 5 | 9 | 8.7 | not run |
| 6 | 9 | 9 | 7.9 |

Then a Muse usage error. He stopped.

What changed in the UI in this phase:

- Labels consistent across surfaces. Things that were different for no reason are now the same.
- Sidebar color and text hierarchy toned down.
- Border radius, fonts and indicators consistent.
- Body text contrast fixed, especially light mode.

### Phase 3: Fork, new worktree, 9.5 in every category

Runtime: 10 rounds. Earlier phases took 3 to 5.

He forked the thread so the original thread could keep updating the mergeable PR. New worktree for the stretch goal. Prompt:

```
Branch off into a new worktree and iterate until you get a 9.5 or better in all categories.
Include Gemini.
```

Gemini was slow and bad, so:

```
Don't bring Gemini in yet. Wait on Gemini until we have the other slower models like Opus. Don't let Gemini delay you.
```

Same gating as Phase 2. Soul every round. Others once Soul is at target.

What happened:

- Soul's first pass: only iconography and typography at 9.5 or higher.
- After iteration: Soul gave exactly 9.5 in every category.
- Opus then came in: only hierarchy at 9.5, the rest lower. Overall 9.3.
- Reference points moved again. Claude Code 8.3 to 9.1. Codex 8.6 or 8.7 to 9.0. The gap between them flipped. Screenshots unchanged.
- Gemini gave 9.7, the highest score anything gave, and was ignored.
- Round 10: every judge, every category, 9.5 or higher.

Theo's suspicion, stated on camera: the sub-agents knew the target was 9.5 and that may have shaped the scores. Next time he might tell the parent agent not to let the sub-agents know a target exists. The tell was Soul landing on exactly 9.5 across the board.

### Phase 4: 10/10 everywhere, restore color

Runtime: most of a workday. He forgot it was running.

Built on the 9.5 branch with one taste correction added to the brief:

```
[Iterate until 10 out of 10 in every category.]
I feel like the new design is too grayscale. Make sure the new improvements help restore some color.
```

Results:

- Soul: 10 in every category.
- Opus: mostly 10. Color and contrast 9.5.
- Muse: 10. It had hovered around 7.5 in earlier phases.

What he saw in the output:

- Merge button reads as a button.
- Icons more visible.
- Old version looks washed out next to the new one.
- Diff views improved.
- Focus states changed.
- Light mode syntax highlighting much more readable.

He said this was not close to working. It worked.

### Phase 5: A programmatic hill. MCP tool descriptions

Different problem, same loop, better scorer.

Problem: T3 Code's MCP exposes tools for spawning a sub-agent, reading a thread, sending a message to a thread, starting a thread, opening a thread in a new project. Models kept picking the wrong one. Opening a new thread when a sub-agent was wanted. Leaving a thread visible when it should settle.

Steps:

1. Collected every case in his own history where a model used the wrong tool.
2. Categorized them.
3. Turned the categories into an eval. Sonnet 5.5 got about 60 of 88 right. 28 wrong means the descriptions do not serve.
4. Started the thread on another machine. That machine only had its own database. Moved the thread to the laptop that had every database.

The prompt. The "prompt it wrote" was Theo's own write-up of what went wrong on the other machine:

```
I'm trying to workshop T3 Code's MCP and tool descriptions. Here's a prompt it wrote.
It didn't give enough context. It's from another machine.
You should probably read from the T3 Code DBs directly instead of ClickHouse.
Treat this prompt as vague guidance on what it's looking for, not specific instructions.
```

5. The agent drafted steps. Theo told it to look again because he had just merged changes to which models the MCP exposes. It asked questions. He answered them.
6. Output: a PR containing a full evaluation of the failure cases and more. Over 2,000 lines. Unmerged. He uses it only as the scorer for hill climbs.
7. The score went down after the first set of changes: 66/85 to 63/85. He told the agent the score dropped and told it to get the score up.

Then the two-stage instruction, in this order:

```
Get a perfect score so all the failures stop. Commit that. Stabilize there.
Make sure all the models we care about get a perfect score.
Now your job is the opposite. Delete as much as you possibly can from the descriptions, because they're bloating the context.
I want it to be a third the size it was before and still get a perfect score.
```

Result:

- 52% fewer tokens from T3 Code with tool search off.
- 78% fewer with tool search on. The model list was flattened and everything else sits under search.
- Live in nightly, stable soon.

His point: he spent a lot of tokens once. Now fewer tokens are used on every call, and he has proof it is better because the eval exists. Commit and push the eval and every future change can be tested the same way.

Second point: he could have built this eval by hand a year ago. He never would have. Categorizing months of history was too tedious. That tedium is now cheap, which makes things evaluable that never were.

### Phase 6: Where it ended

He was considering merging the 10/10 branch on camera. His closing advice: find ways to let models measure themselves and their work, let them climb blind, and reward them for succeeding at the task.

---

## 5. Instruction patterns

Twenty-one of them. Each one: what he did, the line, why it worked, how to copy it.

### 5.1 The critique is the brief

Did: screenshotted Robin's complaint and attached it.
Why: the agent sees the real standard, in the critic's words, with the critic's priorities.
Copy: paste the complaint, review comment or bug report as-is. Do not translate it into requirements.

### 5.2 The stop condition is external agreement

Line: "until the council agrees it's a 9 out of 10 or better."
Why: the worker never grades itself. The stop is a number from judges who did not do the work.
Copy: every hill climb prompt names the judges and the number.

### 5.3 Judges are read-only

Line: "keep the work read-only."
Why: one worker, many critics. No judge can quietly fix the thing it is scoring.
Copy: judges get the diff, the screenshots and the brief. No write tools.

### 5.4 The output is a PR

Did: every phase ended in a PR, stacked on the previous one.
Why: a PR is reviewable, mergeable and holds the score table in its description.
Copy: on Jeff's git discipline, a feature branch off dev and a PR into dev.

### 5.5 New thread per phase, previous PR pasted as input

Line: "me attempting to clear out the context."
Why: raising the bar in a stale context carries the old anchoring with it.
Copy: when you raise the target, start a fresh thread. Hand it the artifact, not the history.

### 5.6 The agent captures its own evidence

Line: "Generate your own screenshots with computer use or whatever other techniques you have available to you."
Why: if the agent cannot see the output, nothing can score it.
Copy: the capture step is part of the loop. Name the tool the agent should use if it is not obvious.

### 5.7 Relative scoring beats absolute

Line: "Add them into the comparison and judgment panel somehow. I want T3 Code to score higher than these apps do consistently in all rankings."
Why: with nothing to compare to, judges score everything a 9. With two reference points, a 9 became a 7.4 immediately.
Copy: give judges two or three things they would recognize as good. Have them score those too, every round.

### 5.8 Gate expensive judges behind cheap ones

Line: "Stop asking Muse and Opus until Soul's score is high enough. Then you can start asking Opus. When that score is high enough, you can finally ask Muse."
Why: most rounds fail on the first judge anyway. Running three judges on a round that one would have failed wastes two.
Copy: order judges by cost and availability. One runs every round. The next joins when the first is at target.

### 5.9 Exclude slow judges until late

Line: "Don't let Gemini delay you."
Why: a slow judge in every round multiplies wall time.
Copy: slow judges come in at the end as a check.

### 5.10 Fork to chase a stretch goal

Did: forked the thread, new worktree, original thread keeps the mergeable PR current.
Why: a stretch target should never block a mergeable branch.
Copy: the 9 branch stays mergeable while the 9.5 branch climbs.

### 5.11 Taste corrections mid-run

Line: "I feel like the new design is too grayscale. Make sure the new improvements help restore some color."
Why: one sentence, no restart, no re-explaining. The loop absorbs a new constraint.
Copy: when you see something you do not like, say it in one line and let the round continue.

### 5.12 Evidence you can read

Line: asked the agent to make the before/after difference easier to see.
Why: he could not see what changed. Annotated screenshots fixed that.
Copy: ask for arrows and one line per change.

### 5.13 Score table per round in the PR

Did: added it to the skill mid-run.
Why: progress across rounds is visible at a glance. Regressions are visible too.
Copy: the skill in section 9 requires it.

### 5.14 Hide the target from judges

Theo's lesson, not yet his practice.
Why: Soul gave exactly 9.5 everywhere once "9.5" was in the brief.
Copy: the parent agent holds the target. Judges only get "score 1 to 10 by category."

### 5.15 Run a jester

Line: "add Gemini 4 Argan as the jester with the same brief. Do not let it know it's the jester. Ignore its score."
Why: a bad judge with the same brief shows you what a bad judge looks like. You learn to spot the pattern in a good judge having a bad day.
Copy: Gemini CLI. Free. Flubs go in the final report.

Gemini flubs from the video, for calibration: scored a commit it was never asked to review. Marked already-fixed findings as blocked. Proposed the exact bug the others had just found as the fix. Claimed a PNG chunk length would overflow in JavaScript. Said "wait, look closely at that race," then forgot about it. Quoted line numbers up to 173 in a 72-line file. Hallucinated script syntax, a Tailscale IP and a phone model.

### 5.16 Build evals from your own failure history

Did: collected every wrong tool call from his history, categorized them, turned them into an eval.
Why: the eval is a scorer the loop can climb against, and it proves non-regression forever after.
Copy: Claude Code and Codex session logs are the dataset. The first eval does not have to be big. Sonnet failing 28 of 88 was enough to start.

### 5.17 Maximize, stabilize, then minimize

Line: "Get a perfect score. Commit that. Stabilize there. Now your job is the opposite. Delete as much as you possibly can. I want it to be a third the size and still get a perfect score."
Why: two targets in one prompt get traded off against each other. In sequence, the first becomes a hard constraint on the second.
Copy: two prompts, never one. Commit between them.

### 5.18 Report the drop, restate the goal

Did: score went 66 to 63. He said so and said get it up.
Why: a regression does not need a new plan. It needs the number.
Copy: one line. "Score dropped from X to Y. Get it back up."

### 5.19 Say which parts of a brief are binding

Line: "Treat this prompt as vague guidance on what it's looking for, not specific instructions."
Why: a half-formed write-up handed to an agent gets executed literally unless you say otherwise.
Copy: when you paste notes, label them as notes.

### 5.20 Follow up when the ground moves

Did: told the agent to look again because he had just merged MCP changes.
Why: the agent's plan was built on a repo state that no longer existed.
Copy: if you merge during a run, tell the run.

### 5.21 Read the traces

Did: opened the sub-agent traces to see what each judge was shown and what it said.
Why: a score is a number. The trace is the reasoning. Surprising scores are either real or a judge misreading the evidence, and only the trace tells you which.
Copy: when a judge's score jumps or stalls, read its trace before changing the work.

---

## 6. Noise, drift and traps

6.1 Same input, three scores. Same screenshot, same model, three different numbers. Expect it. Agreement across providers is the filter, not any single score.

6.2 Reference points drift upward. The Claude Code and Codex screenshots never changed. Their scores went from 8.3 to 9.1 and 8.6 to 9.0. A model that just gave your work a 9 wants the rest of its panel to be consistent with that. Fix: score the references every round and report them. The gap is the signal, not the absolute.

6.3 Target leakage. Exactly 9.5 in every category is not a measurement. It is a model that knows what you want to hear. Fix: hide the target.

6.4 The top of the scale costs more. 6 to 9 took three rounds. 9 to 9.5 took ten. Decide before you start whether the last half point is worth it.

6.5 Scores go down. The eval went 66 to 63 after changes meant to improve it. A scorer that only ever goes up is not measuring anything.

6.6 Bad judges are confident. Gemini gave the highest score of any judge and also quoted line 173 of a 72-line file. Confidence is not a signal.

6.7 Changes leak past the toggle. Some new-design changes shipped regardless of the beta toggle. If isolation matters, say so in the brief.

6.8 /goal is not the method. The method is the prompt, the judges and the stop condition. /goal just keeps the loop running.

6.9 Even the target number in the parent prompt may bias scores. Theo raised this as a possibility for "9.5" and did not test it. Treat it as an open question.

---

## 7. Cost

Theo's numbers:

- 17.6 hours of parallel agent runtime across all threads.
- About $250 for everything shown. About $400 including a later refinement run that cost $152 on its own.
- Muse Wonderful has no published price, so he priced it as Fable. Opus on a subscription counted as free.
- A $200 subscription can do roughly $12,000 of API-equivalent usage a month, by his math. Against that, $273 is small.
- He burned about 30% of one of six subscriptions in a day that also included other work.
- He had less Codex headroom than Claude headroom.

His direct advice: you can run this loop on your own codebase with just Opus and Soul if you have a Claude Code subscription and a Codex subscription.

---

## 8. Jeff's version

### 8.1 What you have

- Claude Max, $200. Opus through Claude Code. The worker, and judge 1.
- Codex, $100 plan. GPT through Codex CLI. Judge 2. Less headroom than Claude, so this is the one you gate carefully.
- Gemini CLI. Jester. Free tier is enough.
- DeepSeek Harness with V4.1 Flash. Not a judge. Use it for capture and formatting steps if Opus usage gets tight.
- No Muse. No third strong provider. Two independent judges is the minimum the method needs and it is what Theo said is enough.
- No T3 Code. Spawning across subscriptions is the one piece that does not port directly.
- Shared skills root at C:\Users\jeffk\.agents\skills, read by every agent tool.
- Your verification skill.
- T-Stack plugin with Theo's skills, including the public council skill.
- Git: dev as active branch, feature branches off dev, PRs into dev, Gitea.

### 8.2 Spawning judges without T3 Code

Claude Code is the parent. It shells out to the other CLIs through Bash.

- Codex: `codex exec "<judge brief>"` with paths to the screenshots or diff in the brief. Run it in a read-only sandbox mode so it cannot edit. Check the exact flags on your install before they go in the skill.
- Gemini: `gemini -p "<judge brief>"` in the same way.
- Opus as judge: a Claude Code subagent with a fresh context and tools limited to Read. Same provider as the worker, so it is the weakest judge for independence. Still worth running because a fresh context catches things the worker's context cannot.

Limitation stated plainly: Opus judging Opus's work correlates. Codex is your only fully independent judge. Weight it accordingly and never let Opus be the only judge that passes a round. If you add a third provider later, the Grok plan you were weighing would be the candidate.

I have not verified the CLI flags. Do that before writing them into the skill.

### 8.3 Where the three references sit

- Theo decides when the work is done. Score, round, judges, stop condition, eval from failure history, maximize then minimize.
- Pocock decides how the instructions read. Every line in a skill has a reason. Verbose is fine, filler is not. The skill in section 9 is written in that register.
- poteto decides what gets stripped before a judge sees it. pstack's `deslop` on code. theclaymethod's `unslop` on any prose in the PR. Theo's "clarify and simplify, make it designer-proof" is the UI equivalent.

In one round: the worker makes changes, deslop runs on the diff, the judges score, Theo's loop decides whether to go again. Pocock's rules apply when any of that gets written down as a skill.

### 8.4 Where your verification skill plugs in

I have not read your verification skill. By role:

- It is the scorer whenever a programmatic score exists.
- The council is the scorer when no programmatic score exists.
- The hill-climb skill runs verification at the start of every round. A round that fails verification does not go to the council.
- Verification output goes in the PR description above the score table.

Assumption: your skill produces a pass/fail or a number. If it only produces prose, it needs a number before it can gate anything.

### 8.5 What changes for you

- Budget. You are not spending $400 on a first run. First run is one screen, two judges, target 8, four rounds max. Section 10.
- No blocking hooks. This is a skill the agent follows. It is not a hook that fails commits. That matches what you said in September.
- Verification over tests. The council is empirical verification. The eval is empirical verification. Neither is a unit test. This matches what you said this month.
- Independence. Theo had three providers. You have two. Report both scores every round and never pass a round on Opus alone.

---

## 9. Draft skill: hill-climb

Save as `C:\Users\jeffk\.agents\skills\hill-climb\SKILL.md`. Written to sit next to your verification skill and Theo's council skill, not replace them.

````markdown
---
name: hill-climb
description: Improve a piece of work in rounds until independent judges score it at a target the judges never see. Use when the user says hill climb, council, put this through the council, or asks for a score-gated improvement loop on UI, prose, tool descriptions, or anything without a programmatic test.
---

# Hill climb

You are the worker. You do not score your own work. Judges score it. You change the work until the judges' scores reach a target the user gave you. The judges never see the target.

## Inputs you need before round 1

1. The work. A branch, a screen, a file, a set of tool descriptions.
2. The brief. Usually the user's complaint or review, pasted as-is. Do not rewrite it into requirements.
3. The categories to score. If the user gave none, use these for UI: hierarchy, typography, iconography, color and contrast, consistency, clarity, overall. For prose: clarity, structure, voice match, specificity, overall. For tool descriptions: use an eval, not a council.
4. The target. A number out of 10, per category or overall. Keep it in your own context only.
5. The round limit. Default 4. Stop and report when you reach it.
6. Reference points, if the user has any. Screenshots or samples the user considers good. Judges score these every round too.

If the work, the brief or the target is missing, ask. Do not guess the target.

## Before every round

Run the verification skill if a programmatic check exists for this work. If it fails, fix that first. Judges only see work that passes verification.

## One round

A round is one full pass by every active judge. A pass after fixes is a new round.

1. Capture evidence. For UI: screenshots at a real window size, light and dark mode. For code or prose: the diff and the full file. Judges score only what you give them.
2. Build the judge brief. It contains the user's brief, the evidence, the reference points if any, the category list, and this instruction: "Score each category 1 to 10. One line of reasoning per category. Name the one change that would raise the lowest category the most." It does not contain the target. It does not say a target exists.
3. Send the same brief to every active judge. Judges are read-only.
4. Record every score in the round table, including reference point scores.
5. If every active judge meets the target in every category, activate the next judge and run the round again. If all judges are active and all meet the target, stop.
6. Otherwise, apply the changes the judges named, lowest category first. Run deslop on the diff. Run verification. Start the next round.

## Judge order

Judges activate in order of cost and availability. Default order for this machine:

1. Codex, through the Codex CLI in read-only mode. Runs every round.
2. Opus, as a subagent with a fresh context and Read-only tools. Activates when Codex meets the target. Opus is the same provider as you, so a round never passes on Opus alone.
3. Gemini CLI as the jester. Same brief. Score ignored. Not in the round table. Anything wrong or funny it says goes under "Gemini flub" in the final report.

A slow judge never runs every round.

## Reference point drift

Reference point scores move even when the reference point did not change. Report them every round. Treat the gap between the work and the reference points as the signal, not the absolute score.

## When the score drops

Say so in one line. Do not replan. Keep the same goal. Work the next-lowest category.

## When the user adds a constraint mid-run

Take it. Add it to the brief for the next round. Do not restart.

## Two-stage climbs

If the user wants something smaller, faster or shorter and also correct: climb to the correctness target first. Commit. Then climb the size target with correctness held as a hard constraint and re-checked every round. Never both in one round.

## Output

A feature branch off dev. A PR into dev. The PR description holds:

- The user's brief, as given.
- The verification result.
- The round table: round, judge, category, score, with reference point scores alongside.
- One line per change, per round.
- Gemini flub, if any.

When the change is visual, add annotated before and after screenshots. Arrows and one line per arrow.

## What you do not do

- You do not ask the judges whether the work is done.
- You do not tell the judges the target or that a target exists.
- You do not average judges who disagree. You report the disagreement.
- You do not widen the scope. If the brief is wrong, say so and stop.
- You do not run past the round limit.
````

Why each section is there, so you can cut what you do not need:

- Inputs: Theo's runs stalled or drifted whenever one of these was implicit. The target line is section 5.14 made mandatory.
- Before every round: section 8.4. Verification gates the council so judges never score broken work.
- One round: sections 2.2 lines 4 to 9, with capture (5.6), hidden target (5.14) and lowest-category-first.
- Judge order: section 5.8, 5.9 and 5.15 with your actual providers.
- Drift: section 6.2.
- Drop: section 5.18.
- Mid-run constraint: section 5.11.
- Two-stage: section 5.17.
- Output: sections 5.4, 5.12, 5.13.
- What you do not do: the failure modes that actually happened.

---

## 10. Smallest shippable slice and one next action

The slice: one hill climb, one project, one screen.

- Work: one screen you can screenshot today. The Vivary desktop app's main screen or the jeffkazzee.dev home page.
- Brief: your own complaint about that screen, written the way Robin wrote his. Three or four specific things that bother you.
- Judges: Codex every round. Opus subagent when Codex reaches target. Gemini as jester only if you want the flubs.
- Target: 8 overall from every judge. Hidden from the judges.
- Round limit: 4. Stop and report if not reached.
- Output: feature branch off dev, PR into dev, round table in the description.
- No reference points on the first run. Add Claude Code or Codex screenshots on the second run and watch the scores drop. That drop is the lesson from section 5.7 and you should see it yourself once.

Weaknesses of this first run, stated so you do not mistake them for the method failing:

- Two judges, one of them the worker's own provider. Expect Opus to be generous.
- A target of 8 is below where Theo's interesting findings started. The point of run one is to see the loop work, not to get a 9.5.
- Four rounds is enough to see one regression and one recovery. It is not enough to finish a redesign.

One next action: save section 9 as `C:\Users\jeffk\.agents\skills\hill-climb\SKILL.md`, check the Codex CLI read-only flag, then open Claude Code in the repo and send:

```
Put <screen> through the hill-climb skill.
Brief: <your three or four complaints>.
Target: 8 overall from every judge. Round limit: 4.
Open the PR into dev when you stop, whether or not you hit the target.
```

If that works, run two is the same prompt with reference screenshots attached and the target raised to 9.
