---
name: ddd-festival-file
description: Write a product requirements document (PRD) or festival-file implementation brief at feature or phase kickoff (also invoked as ddd-prd for product-intent requests). Use when the user starts a feature/phase, asks for a PRD or festival file, or wants an execution-grade spec for an agent; picks mode by intent (prd = product intent via templates/prd.md, festival = execution brief via templates/festival.md), writes imperative atomic tasks with runnable success metrics, scope restrictions, build/verify gates, and acceptance criteria; same-change rule with the implementation doc. Triggers: PRD, festival file, kickoff, implementation brief, spec it before building, hand this to an agent.
---
# PRD / Festival File

## When to use

- Feature/phase kickoff: product intent (PRD mode) or agent execution brief (festival mode).
- The user asks for a PRD, festival file, implementation brief, or a spec before building.
- Not for planning already covered by `ddd-plan` — this skill produces the kickoff spec, not the phased plan.

## Inputs

1. Request + context + mode: `prd` (product intent) or `festival` (agent build brief).
2. Template by mode: `templates/prd.md` or `templates/festival.md`.
3. Catalog manifest: `templates/catalog.md` (path pattern + required params).
4. Flow context if needed: `docs/research/09-flows-and-strategies.md` (gates the spec must support).

## Steps

1. Determine mode by intent: PRD asks for product-intent; festival asks for an execution brief. Route accordingly (ddd-prd alias → PRD mode).
2. Load the matching template from `templates/`; fill every `{{param}}` into a NEW file.
3. Write scope: include explicit NON-goals/scope restrictions.
4. Write atomic tasks in imperative mood, each with a runnable success metric.
5. Add the gate list: build + verify after EVERY task; no unchecked task.
6. State dependencies and ordering between tasks.
7. Write acceptance criteria and the final validation sequence.
8. Update the doc index and related docs in the same change.

Runnable check after each step: spec contains scope, atomic tasks each with runnable metric, gate list; zero dangling `{{ }}`; an agent executing it reaches a defined end state.

## Rules

- Spec must be executable by an agent without clarifying questions.
- Size guard: festival file < 500 lines; split phases otherwise.
- Imperative language; no hedge words; no unchecked tasks.
- Update spec in the same change you execute it.
- Every task that touches code adds DDD-DOC: breadcrumbs to its spec per ddd-comments.

## Verification

- Artifact has scope + restrictions, tasks with runnable metrics, gate list; test run through first 2 tasks produces no ambiguity; tasks atomic (one outcome each).
