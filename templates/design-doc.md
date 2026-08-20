# {{title}}

<!-- when to use: produce a Google-style design document for a non-trivial feature
     before implementation. Fill every double-brace placeholder in a NEW file at
     docs/design/<slug>.md; never edit this template. Write the doc in whatever
     form serves the project; the point is recorded TRADE-OFFS, not an
     implementation manual. -->

- **Status:** Draft | In review | Approved | Implemented
- **Author(s):** {{authors}} · **Reviewers:** {{reviewers}}
- **Date:** {{date}} · **Links:** {{related ADRs, issues, prototypes}}

## Context and Scope

{{Objective facts about the landscape and what is being built. Keep it succinct; assume prior knowledge; link details.}}

## Goals and Non-goals

**Goals:**

- {{goal}}

**Non-goals:**

- {{explicit non-goal — something that could reasonably be a goal but is excluded}}

## Options Considered

For each option: trade-offs it makes, and why it wins or loses given the goals.

- **{{option-a}}** — {{trade-offs and verdict}}
- **{{option-b}}** — {{trade-offs and verdict}}
- **{{option-c}}** — {{trade-offs and verdict}}

## Decision

{{The chosen option, stated explicitly, with rationale. Durable choices are extracted into an ADR via ddd-adr.}}

## Risks and Open Questions

- {{risk or open question}}
- {{risk or open question}}

## Cross-Cutting Concerns

- **Security:** {{impact and mitigation}}
- **Privacy:** {{impact and mitigation}}
- **Observability:** {{impact and mitigation}}

## Rollout and Testing Plan

- **Rollout:** {{steps}}
- **Testing:** {{approach}}
- **Rollback:** {{how to undo}}
- **Metrics & monitoring:** {{what to watch}}

## References and Prior Art

- {{related design docs, ADRs, papers, prototypes}}
