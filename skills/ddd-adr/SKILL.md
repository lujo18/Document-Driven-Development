---
name: ddd-adr
description: Capture an architecture decision record (ADR) when a design choice is made or a decision needs recording. Use when the user chooses between options, asks why a decision was made, wants decisions recorded with a proposed/accepted/superseded status lifecycle, or needs an architecture decision logged one per file with monotonic numbering. Writes docs/adr/NNNN-slug.md from templates/adr.md and updates index and supersession links in the same change. Triggers: record an ADR, architecture decision, decide between X and Y, why did we choose, capture this decision, mark an ADR superseded.
---
# ADR

## When to use

- A decision with durable consequences; one decision per ADR.
- The user chooses between options, asks why a decision was made, or wants a decision logged.
- Not for speculative notes — record decisions, not musings.

## Inputs

1. Decision context: the problem/forces, options considered, and the chosen option with rationale.
2. Prior ADRs in `docs/adr/` — for the next monotonic number and any supersession target.
3. Template: `templates/adr.md` (the one-decision skeleton with lifecycle fields).
4. Index: the ADR index section of the README (updated in the same change).

## Steps

1. Determine the next number: largest existing `NNNN` in `docs/adr/` plus one; never reuse a number.
2. Load `templates/adr.md`; fill every placeholder into a new file `docs/adr/NNNN-slug.md`.
3. Write the required sections: Context (facts and forces), Options considered (with trade-offs, not just the winner), Decision (one paragraph), Consequences (bullets), Status, Date.
4. Set status per lifecycle: `proposed` until stakeholders agree, then `accepted`; later `superseded` with a link to the successor ADR.
5. Update the ADR index and any supersession links in the same change.
6. Run the ADR pattern check via `ddd-validate-docs`.

Runnable check after each step: number is monotonic and unique; required sections present; status field valid; index and supersession links updated in the same change.

## Rules

- One decision per record; never vendor unrelated content.
- Do not rewrite history: supersede, don't edit an accepted ADR.
- Monotonic `NNNN` numbering; never renumber or reuse numbers.
- Same-change rule: index + links update with the ADR.

## Verification

- File at `docs/adr/NNNN-slug.md`; unique monotonic number; status field valid; superseded ADRs link successors; index entry present; `ddd-validate-docs` passes the ADR pattern check.
