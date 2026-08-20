# {{title}}

<!-- when to use: create an execution-grade festival file (implementation brief)
     for an AI agent to build a feature or phase end-to-end. Fill every double-brace
     placeholder in a NEW file at docs/specs/<slug>-festival.md; never edit this
     template. Scope is sacrosanct: atomic tasks, runnable success metrics, and a
     build/verify gate after every task. -->

- **Status:** draft | review | accepted
- **Date:** {{date}} · **Slug:** {{slug}} · **Owner:** {{owner}}
- **Feature:** {{one-line user value}}
- **Depends on:** {{features/stores/services, or "None"}}
- **Estimated Complexity:** Low | Medium | High
- **Target Directory:** {{target-directory}}

## Context & Boundaries

**Objective:** {{exactly what the agent must produce; verifiable pass/fail}}

**Scope Restrictions:**

- MUST only modify files under {{target-directory}}.
- Do NOT touch global config / root navigation / shared state without human approval.
- Approved packages: {{list, or "none"}}

## Technical & Security Constraints

- The project must build after EVERY task ({{build-command}} before proceeding).
- Implement in dependency order: {{dependency-order}}.
- No hardcoded secrets; env vars only. Validate all user input. No PII in logs.

## Implementation Phases

### Phase 1 — {{phase-name}}

#### Task 1.1 — {{task-title}}

{{task-detail: precise behavior, edge cases, error handling}}

**Success metrics:** {{runnable check that must pass}}

#### Task 1.2 — {{task-title}}

{{task-detail}}

**Success metrics:** {{runnable check that must pass}}

### Phase 2 — {{phase-name}}

#### Task 2.1 — {{task-title}}

{{task-detail}}

**Success metrics:** {{runnable check that must pass}}

#### Task 2.2 — {{task-title}}

{{task-detail}}

**Success metrics:** {{runnable check that must pass}}

### Phase 3 — {{phase-name}}

#### Task 3.1 — {{task-title}}

{{task-detail}}

**Success metrics:** {{runnable check that must pass}}

## Build / Verify Gates

After EVERY task, run the build check and confirm it passes before moving on:

    {{build-command}}
    {{verify-command}}

No task is complete until its success metric passes.

## Acceptance Criteria & Validation

1. {{build-command}} passes.
2. {{lint-command}} passes.
3. {{test-command}} passes.
4. No files outside {{target-directory}} changed.
5. {{feature-specific criterion}}.
6. {{feature-specific criterion}}.

Final sequence (run in order, report each result):

    {{build-command}}
    {{lint-command}}
    {{test-command}}
    {{diff-check-command}}
