# 0003 Code-Comment Indexing

<!-- Materialized from templates/adr.md per the DDD build plan §10 (D-BLD-15). -->

> **Status:** accepted

- **Date:** 2026-08-15
- **Number:** 0003
- **Decision-makers:** architect + coder

## Context

The framework enforces doc-first indexing — README-as-index, ddd-index, ddd-validate-docs, research 07 — but ships nothing that makes agents leave code comments for indexing: no module-header or docstring conventions, no tagged TODO/FIXME discipline, no symbol-reference breadcrumbs from code to docs. Consumer codebases accumulate ad-hoc comments that neither trace to governing docs nor track owned debt, and agents cannot grep an index of code comments.

## Decision

- Ship skills/ddd-comments (SKILL.md) defining the tag vocabulary `DDD:`, `TODO:`, `FIXME:`, `HACK:`, `HACK-REF:`, `DDD-DOC:` with an owner + doc-link grammar, the anti-rot rule (comments link docs, never restate them), and a token budget (comments are cheap index surface, not prose).
- Ship templates/comments.md as the per-repo comment register (tags, owners, doc root, audit command); scaffold it when a consumer has none.
- Add a 9th ddd-validate-docs check: comment link/tag audit (tags owned, required links present, doc links resolve) when a code dir is configured.
- ddd-festival-file and ddd-design-doc instruct implementers to add `DDD-DOC:` breadcrumbs per this convention.
- No installer changes: existing skill/template globs pick up the new artifacts.

## Options Considered

- **No convention** — rejected: verified gap; ad-hoc comments keep docs and code decoupled and debt unowned.
- **Full comment style guide as a doc** — rejected: duplicates ecosystem style guides, heavy to maintain, and is a doc, not a skill agents route to.
- **Minimal greppable tag vocabulary + skill + template** — chosen: harness-free (grep/shell), portable across languages (one token set), discoverable as a skill.

## Rationale

Research 07 prescribes grep + curated index as the search strategy; a fixed tag vocabulary makes code comments part of that index surface. Research 09's docs-lead/code-follow is preserved because comments only point at docs and never introduce or restate design. The skill/template pair matches the framework's delivery model (AGENTS.md invariants) and zero-fence/size-bounded contracts.

## Consequences

- **Positive:** every code comment becomes greppable index surface; debt is owned and linked; code traces to plans/ADRs/design docs; anti-rot keeps comments from duplicating docs.
- **Negative:** legacy codebases carry unowned tags until cleaned; the per-repo owner map must be maintained in comments.md; the audit is a grep sketch, not a language-aware linter.
- **Follow-ups:** first consumer pilot validates the tag grammar; a future validate.sh (X3) may automate the audit across languages.

## Supersession

- **Supersedes:** none
- **Superseded by:** none
- **Links:** `docs/plans/ddd-build-festival-file.md` §10 (D-BLD-15); `skills/ddd-comments/SKILL.md`; `templates/comments.md`; `docs/research/07-agent-indexing.md`; `docs/research/09-flows-and-strategies.md`
