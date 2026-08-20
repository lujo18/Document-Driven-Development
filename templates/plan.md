# {{title}}

<!-- when to use: create a doc-first plan before any code. Fill every double-brace
     placeholder in a NEW file at docs/plans/<slug>.md; never edit this template.
     The plan is the contract code is written against: docs lead, code follows,
     each phase ends in a runnable gate, phases are never renumbered. -->

- **Status:** draft | review | accepted
- **Owner:** {{owner}} · **Reviewers:** {{reviewers}}
- **Date:** {{date}}

## Goals

- {{goal with metric}}

## Non-goals

- {{explicit non-goal}}

## Success

{{What "done" looks like, in observable terms.}}

## Acceptance Criteria

- {{criterion — Given/When/Then or a named runnable check}}
- {{criterion}}

## Phases

Each phase: doc changes → code changes → gate. The gate is a runnable check; no phase starts until the previous gate passed.

### Phase 1 — {{name}}

- **Doc changes:** {{which docs change first}}
- **Code changes:** {{what code follows}}
- **Gate:** {{runnable check that must pass}}
- **Definition of done:** {{observable outcome for this phase}}

### Phase 2 — {{name}}

- **Doc changes:** {{which docs change first}}
- **Code changes:** {{what code follows}}
- **Gate:** {{runnable check that must pass}}
- **Definition of done:** {{observable outcome for this phase}}

### Phase 3 — {{name}}

- **Doc changes:** {{which docs change first}}
- **Code changes:** {{what code follows}}
- **Gate:** {{runnable check that must pass}}
- **Definition of done:** {{observable outcome for this phase}}

## Definition of Done (overall)

- Plan under 150 lines; every phase names its gate and its doc/code outputs; no code was modified during planning; a reviewer can execute it without clarifying questions.
