---
name: ddd-design-doc
description: Produce a Google-style design document for non-trivial features. Use when the user asks for a design doc, wants a feature designed before implementation, or needs architecture review with context, goals/non-goals, options with trade-offs, an explicit decision, and risks. Writes docs/design/<slug>.md from templates/design-doc.md, funnels durable choices into ddd-adr records, and updates index and related docs in the same change. Triggers: write a design doc, design this feature, non-trivial feature, architecture review, design before coding.
---
# Design Document

## When to use

- Non-trivial, cross-cutting, or risky features.
- The user asks for a design doc or wants a feature designed before implementation.
- Not for small changes — route those to `ddd-plan` only.

## Inputs

1. Request + context: problem, constraints, prior art, prototypes.
2. Design-doc template: `templates/design-doc.md`.
3. Related docs index (find and link related docs; `ddd-index` contract).
4. ADR log, if durable decisions already exist to reference.

## Steps

1. Load `templates/design-doc.md`; fill every placeholder into `docs/design/<slug>.md`.
2. Write Context and Scope: objective facts about the landscape and what is being built.
3. Write Goals and Non-goals: non-goals are things that could reasonably be goals but are explicitly excluded.
4. Write Options with trade-offs: at least 2 options, each with its trade-offs, before any decision section.
5. Write the Decision: name the chosen option explicitly, with rationale.
6. Write Risks and Open Questions; list cross-cutting concerns (security, privacy, observability).
7. Extract durable choices into `ddd-adr` records and link them from the design doc.
8. Update the doc index and related docs in the same change.

Runnable check after each step: every template section present and non-empty; ≥2 options recorded before the Decision section; decision section names a choice; risks listed.

## Rules

- ≥2 options with trade-offs before any decision section is written.
- Extract durable choices into an ADR (`ddd-adr`); link it from the design doc.
- Design doc < 300 lines; split sections if larger.
- Same-change rule: update index and related docs when the design lands.
- When implemented, code referencing this design carries DDD-DOC: breadcrumbs per ddd-comments (anti-rot: link, don't restate).

## Verification

- All template sections present and non-empty; Decision section names a choice; risks listed; linked from the doc index; durable decisions have ADRs.
