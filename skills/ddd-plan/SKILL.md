---
name: ddd-plan
description: Plan features and changes document-first, before any code. Use when the user asks to build, change, add, refactor, or implement something and a plan must sequence doc changes ahead of code, with per-phase gates and a definition of done. Writes docs/plans/<slug>.md from templates/plan.md, ordering each phase as doc changes to code changes to a runnable gate; plans stay under 150 lines and never renumber phases. Triggers: build, change, add, refactor, implement, plan first, before you write code, how should we approach this.
---
# Document-Driven Plan

## When to use

- Any request that will change behavior, docs, or both.
- The user asks to build/change/implement something and a plan must come first.
- Not for read-only Q&A or trivial changes that need no planning.

## Inputs

1. AGENTS.md and repo README index (conventions, invariants).
2. Doc index (find related docs; follow `ddd-index` contract).
3. Affected files + git status.
4. Plan template: `templates/plan.md`.

## Steps

1. Load `templates/plan.md`; fill every placeholder into `docs/plans/<slug>.md`.
2. Write Goals, Non-goals, constraints.
3. Write Success and Acceptance criteria (what "done" means, in observable terms).
4. Build the phase list: each phase is doc changes → code changes → gate, with a runnable check at the gate.
5. Write a Definition of done per phase.
6. Update the doc index and related docs in the same change.
7. Hand off to `ddd-run-flow` only after the plan is accepted (Gate 1/2).

Runnable check after each step: plan exists at `docs/plans/<slug>.md`; every phase maps to doc+code work and a gate; no code was modified during planning; plan < 150 lines.

## Rules

- Docs before code, in the SAME change (docs-as-code).
- Plan < 150 lines; split into multiple plans if larger.
- Update the plan in the same change you execute it (never renumber phases).
- Hand off to `ddd-run-flow` only after the plan is accepted.

## Verification

- Plan exists at canonical path; every phase names its gate and its doc/code outputs; the plan contains no code edits; a reviewer can execute it without clarifying questions.
