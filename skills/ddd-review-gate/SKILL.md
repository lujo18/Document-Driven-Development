---
name: ddd-review-gate
description: Enforce a reviewer checklist before a phase or artifact ships. Use when the user asks for a review gate, sign-off, phase review, or whether work is ready, or when ddd-run-flow hits a gate; checks artifacts against per-type checklists embedded in this skill, separates blockers from nits, records the sign-off decision, and routes any FAIL to the owning lane. Per-artifact checklists cover SKILL.md, markdown docs, templates, and flow/plan docs. Triggers: review gate, sign off, phase review, is this ready to ship, run the checklist, blockers.
---
# Review Gate

## When to use

- End of any phase; consumed by `ddd-run-flow` gates; on-demand sign-off.
- The user asks "is this ready to ship?" or "run the checklist".
- Not for authoring — this skill evaluates and records, it does not edit.

## Inputs

1. The artifacts to review (skills, docs, templates, plan/flow docs).
2. The applicable checklist set from `## Checklists by Artifact` below.
3. The flow/gate context: `templates/flow.md`, `docs/research/09-flows-and-strategies.md`.
4. The execution log (for `ddd-run-flow` gate entries) or the artifact's status.

## Checklists by Artifact

### (a) SKILL.md / portable skill artifacts

- Frontmatter: `name` == folder, kebab regex, single-line description ≤1024 chars.
- Body: <500 lines; exactly one H1; required sections `## When to use`, `## Inputs`, `## Verification` in order; imperative voice; every step ends in a runnable check.
- Zero triple-backtick fences; refs by relative path; no per-skill `references/` dir.

### (b) Markdown docs (header contract)

- H1 == filename slug; `> **Status:**` line present with valid value; `## Purpose` ≤50 words where required.
- Size bounds respected; zero fences; internal links resolve; tag audit — every `[UNVERIFIED]`/`[NEEDS SOURCE]` has an owner + next action.

### (c) Templates

- Exactly one H1; `{{param}}` placeholders only (zero single-brace fill-ins); `<!-- when to use -->` comment near top.
- Render smoke test: substitute sample params → zero remaining `{{`; required sections present; template `mtime` unchanged.

### (d) Flow / plan docs

- Phases ordered doc → code → gate; every phase names its gate and its doc/code outputs.
- Definition of done per phase; gates named and runnable; plan ≤150 lines (or per bound); no renumbered phases.

## Steps

1. Select the checklist set matching the artifact type.
2. Run each checklist item; classify each as PASS, NIT (non-blocking), or BLOCKER (FAIL).
3. Re-run one check independently (anti-rubber-stamp) to confirm the first result.
4. Record the sign-off decision: PASS (zero FAIL) or FAIL-BLOCKED with named blockers, into the execution log or artifact status.
5. On any FAIL, route the named item back to the owning lane and hold sign-off.

Runnable check after each step: every checklist item answered PASS/FAIL with evidence; no unresolved blockers; decision recorded.

## Rules

- Blockers must be resolved before sign-off; nits are logged, not blocking.
- Record the decision (PASS or FAIL + blockers) into the artifact/execution log.
- Agent may run the checklist; final human sign-off is recorded where required.
- Zero FAIL → status `done` + gate-log entry; any FAIL blocks the phase and routes back to the owning lane.

## Verification

- Every checklist item answered PASS/FAIL; no unresolved blockers; decision recorded; gate feeds `ddd-run-flow`.
- A gated flow refuses to advance on unresolved blockers.
