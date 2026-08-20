# {{title}}

<!-- when to use: create a flow doc describing a doc-driven pipeline for a repo,
     project, or phase. Fill every double-brace placeholder in a NEW file at
     docs/flow/<slug>.md; never edit this template. The flow spec is the DDD
     stage map 0-6 with the 5 gates from docs/research/09-flows-and-strategies.md:
     contiguous pass chain, a FAIL at any gate stops the flow and routes back to
     the owning stage. -->

- **Status:** draft | review | done
- **Date:** {{date}} · **Slug:** {{slug}} · **Owner:** {{owner}}

## Pipeline Overview

<!-- pipeline-summary: one-line summary of the flow, e.g. "0 Context & Onboarding → 1 Doc-First Plan → 2 Approval → 3 Implementation → 4 Verification → 5 Review & Sign-off → 6 Maintenance" -->

{{pipeline-summary}}

## Stage Map

| Stage | Name | Artifacts in → out | Gate |
|---|---|---|---|
| 0 | Context & Onboarding | {{stage-0-artifacts}} | Gate 0 Indexed |
| 1 | Doc-First Plan | {{stage-1-artifacts}} | Gate 1 Planned |
| 2 | Approval | {{stage-2-artifacts}} | Gate 2 Approved |
| 3 | Implementation, doc-anchored | {{stage-3-artifacts}} | Gate 3 at merge |
| 4 | Verification | {{stage-4-artifacts}} | Gate 3 Verified |
| 5 | Review & Sign-off | {{stage-5-artifacts}} | Gate 4 Signed-off |
| 6 | Maintenance & Living Docs | {{stage-6-artifacts}} | cadence-driven |

## Gate Table

| Gate | Name | Check | PASS / FAIL semantics |
|---|---|---|---|
| 0 | Indexed | README links all files; agent resolves "where do I look?" | PASS: {{gate-0-pass}} · FAIL: fix index or move file |
| 1 | Planned | plan doc has Goals, Non-goals, Success, Acceptance criteria | PASS: {{gate-1-pass}} · FAIL: return to draft, block coding |
| 2 | Approved | reviewer sign-off; plan frontmatter `status: accepted` | PASS: {{gate-2-pass}} · FAIL: revise plan, no code |
| 3 | Verified | tests pass; docs updated in same change; doc-truth checks run | PASS: {{gate-3-pass}} · FAIL: add tests/docs, no merge |
| 4 | Signed-off | checklist complete: scope, ≤400-line docs, index updated, ADRs present | PASS: {{gate-4-pass}} · FAIL: back to author, re-review |

## Execution Rules

- Contiguous pass chain: no stage starts until the previous gate passed.
- A FAIL at any gate stops the flow and routes back to the owning stage.
- Every stage ends with a runnable check; no unchecked task.
- Record every gate result in the execution log (append-only).
