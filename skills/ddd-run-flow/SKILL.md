---
name: ddd-run-flow
description: Execute the document-driven flow stage by stage across the DDD stage map 0-6 (Context & Onboarding, Doc-First Plan, Approval, Implementation, Verification, Review & Sign-off, Maintenance), blocking at the 5 gates (Indexed, Planned, Approved, Verified, Signed-off). Use when the user says start, run, execute, or kick off a plan, continue a gated pipeline, or run a specific phase; orchestrates ddd-* skills in dependency order, produces a contiguous-pass execution log with per-stage artifacts and gate sign-offs, stops on any gate FAIL and routes back to the owning stage. Triggers: start the plan, run the flow, execute, kick off, continue the pipeline, run phase N, what's the status.
---
# Gated Execution Flow

## When to use

- Only with an accepted plan from `ddd-plan`. No plan → return to `ddd-plan`.
- The user asks to start, run, execute, or continue the doc-driven flow.
- Not for ad-hoc work — the flow requires a plan and its gates.

## Inputs

1. Accepted plan from `ddd-plan` (or festival file from `ddd-festival-file`).
2. The flow stage map + gate table: `templates/flow.md` and `docs/research/09-flows-and-strategies.md`.
3. The ddd-* skill set, run in dependency order (index → plan → adr/design-doc → implementation → validation → review-gate).
4. Repo context: AGENTS.md, README index, affected files, git state.

## Steps

1. Load the plan and map its phases onto the DDD stage map (Stage 0 Context & Onboarding → 1 Doc-First Plan → 2 Approval → 3 Implementation → 4 Verification → 5 Review & Sign-off → 6 Maintenance).
2. For the current stage, load its spec (docs first, then code) and its gate from `templates/flow.md`.
3. Run the owning ddd-* skill for the stage artifact: `ddd-index` (Stage 0), `ddd-plan`/`ddd-festival-file` (Stage 1), `ddd-adr`/`ddd-design-doc` (Stages 2–3), implementation + `ddd-validate-docs` (Stage 4).
4. Run the stage's runnable check; then run `ddd-review-gate` for the gate checklist.
5. Record PASS/FAIL at the gate in the execution log (append-only). PASS → next stage. FAIL → stop, log the named blocker, route back to the owning stage.
6. After Stage 5 sign-off, hand off to maintenance (Stage 6: index refresh, ADR log, prune).

Runnable check after each step: the execution log shows the stage's artifact exists and its gate result is explicit PASS or FAIL; no stage starts before the previous gate passed.

## Rules

- Contiguous pass chain: no stage starts until the previous gate passed.
- Every task ends with build+verify (festival discipline); no unchecked task.
- Abort = stop + log + report, never silent skip.
- Update plan/log in the same change as the work it records.
- A FAIL at any gate stops the flow and routes back to the owning stage.

## Verification

- Log shows every stage with explicit PASS/FAIL at its gate; artifacts exist; final summary lists gates, artifacts, and remaining work.
- No stage skipped or reordered; abort paths recorded; exit semantics usable in a consumer CI hook.
- Stages and gates match the 09 stage map (names + order + per-stage artifacts).
