# DDD Research Library — Index (READ THIS FIRST)
> Agents MUST read this file before opening any other file under docs/research/.

## Purpose

This is the indexed research library for the Document-Driven Development (DDD) framework: 10 files that define DDD, the doc-driven pipeline, best practices, template skeletons, agent indexing conventions, the skills scope, the flow spec, and the canonical bibliography. Consuming agents and developers install this framework read these files as their first context source. Token-budget philosophy: small index, dense per-file content, detail behind links, status single-sourced in-file — never duplicate content across files.

## File Map

| # | File | Purpose (what + when) | Size bound |
|---|---|---|---|
| 01 | [01-what-is-ddd](./01-what-is-ddd.md) | What DDD is — definition, origins, philosophy, benefits, critiques. Read first after this index. Keywords: ddd, definition, disambiguation | ≤400 lines |
| 02 | [02-ddd-flow](./02-ddd-flow.md) | End-to-end doc-driven pipeline — stages, gates, artifacts, owners. Read when planning flow. Keywords: pipeline, flow, stages | ≤400 lines |
| 03 | [03-best-practices](./03-best-practices.md) | Doc hygiene, agent-friendly writing, pitfalls, metrics. Read when writing/auditing docs. Keywords: best practices, pitfalls | ≤400 lines |
| 04 | [04-templates-adr](./04-templates-adr.md) | ADR formats — Nygard, MADR — with skeletons. Read when capturing a decision. Keywords: adr, decision | ≤500 lines |
| 05 | [05-templates-issues](./05-templates-issues.md) | Issue template anatomy + skeletons. Read when standardizing issues. Keywords: issue templates | ≤350 lines |
| 06 | [06-templates-roadmap-design-feature](./06-templates-roadmap-design-feature.md) | Roadmap/design-doc/PRD/festival skeletons. Read when planning an artifact. Keywords: roadmap, design doc, prd | ≤450 lines |
| 07 | [07-agent-indexing](./07-agent-indexing.md) | How agents discover docs — llms.txt, AGENTS.md, SKILL.md, token-efficient writing. Read when structuring docs for agents. Keywords: indexing, llms.txt, frontmatter | ≤500 lines |
| 08 | [08-skills-to-build](./08-skills-to-build.md) | The framework's v1 skill inventory — specs, skeletons, priorities. Read when scoping skills. Keywords: skills, ddd-plan | ≤500 lines |
| 09 | [09-flows-and-strategies](./09-flows-and-strategies.md) | Flow spec, gate table, strategies, cadences, metrics. Read for enforcement rules. Keywords: gates, strategies, cadences | ≤500 lines |
| 10 | [10-references](./10-references.md) | Canonical bibliography — every URL cited in 01–09 + pending register. Read to verify sources. Keywords: sources, references | ≤300 lines |

## Navigation Rules

| If you need X | Read | Not for — do NOT read when |
|---|---|---|
| What is DDD? | [01-what-is-ddd](./01-what-is-ddd.md) | Domain-Driven Design details — that is the other DDD |
| Pipeline/flow | [02-ddd-flow](./02-ddd-flow.md) | DDD definition — that's 01 |
| Best practices/pitfalls | [03-best-practices](./03-best-practices.md) | Pipeline mechanics — that's 02 |
| ADR templates | [04-templates-adr](./04-templates-adr.md) | Issue templates — that's 05 |
| Issue templates | [05-templates-issues](./05-templates-issues.md) | ADR templates — that's 04 |
| Roadmap/design/feature templates | [06-templates-roadmap-design-feature](./06-templates-roadmap-design-feature.md) | ADR/issue templates — that's 04/05 |
| Agent indexing/token efficiency | [07-agent-indexing](./07-agent-indexing.md) | Doc writing style — that's 03 |
| Which skills will the framework ship? | [08-skills-to-build](./08-skills-to-build.md) | Skill frontmatter format — that's 07 |
| Flow spec/strategies | [09-flows-and-strategies](./09-flows-and-strategies.md) | Pipeline overview — that's 02 |
| Sources/URLs | [10-references](./10-references.md) | Any content question — read the citing file |

## Reading Order for New Agents

1. README — this index; the map. Read first, always.
2. [01-what-is-ddd](./01-what-is-ddd.md) — what DDD is, and is not.
3. [02-ddd-flow](./02-ddd-flow.md) — the pipeline docs flow through.
4. [03-best-practices](./03-best-practices.md) — hygiene, pitfalls, metrics.
5. [07-agent-indexing](./07-agent-indexing.md) + [08-skills-to-build](./08-skills-to-build.md) — when working on agent tooling or skills.
6. [04-templates-adr](./04-templates-adr.md) / [05-templates-issues](./05-templates-issues.md) / [06-templates-roadmap-design-feature](./06-templates-roadmap-design-feature.md) — on demand when writing an artifact.
7. [09-flows-and-strategies](./09-flows-and-strategies.md) — flow/strategy specifics when executing the pipeline.
8. [10-references](./10-references.md) — on demand only, never in sequence.

## Status & Legend

- Status values: `draft` (in progress) → `review` (awaiting review) → `done` (reviewed and signed off). Transitions: `draft` → `review` → `done`; a failed review returns the file to `draft`.
- **Status is single-source:** the per-file `> **Status:**` line is canonical. This index never states a file's status. Query statuses with: `grep -R "Status:" docs/research/`
- Tag markers: `[UNVERIFIED]` claim not yet confirmed · `[NEEDS SOURCE]` claim lacks URL · `[DECISION PENDING]` design choice deferred. Every `[UNVERIFIED]`/`[NEEDS SOURCE]` appears in [10-references](./10-references.md) with owner + next action.

## Glossary

Canonical definitions for cross-cutting terms only. Do not re-define these in any other file — link to this section (`./README.md#glossary`) instead. Terms used in fewer than 2 files are defined inline where they first appear.

- **DDD (document-driven)** — docs-first methodology: document before you build.
- **Domain-Driven Design** — unrelated Evans methodology (the other DDD).
- **festival file** — execution-grade feature spec for agents.
- **ADR** — architecture decision record.
- **MADR** — Markdown ADR variant.
- **PRD** — product requirements doc.
- **RFC** — proposal-for-comment doc.
- **llms.txt** — agent-readable docs index file.
- **AGENTS.md** — "README for agents".
- **SKILL.md** — skill entrypoint with frontmatter.
- **README-as-index** — index-first navigation pattern.
- **progressive disclosure** — small index, detail behind links.
- **token-efficient** — minimal-token writing style.
- **doc rot** — stale or undiscoverable docs.
- **living docs** — docs kept true by process/CI.

## How to Extend This Library

- (a) Next free number = largest existing + 1 (numbers 11–99).
- (b) Slug rules: ≤40 chars, lowercase kebab-case, unique, stable.
- (c) New files default ≤400 lines and must declare their bound in the File Map row.
- (d) Create the file per the header contract (H1 = slug, `> **Status:**` line, `## Purpose`).
- (e) Add/update the File Map row + Navigation Rules row if the file answers a new need.
- (f) Never renumber or delete files; renames only with a grep-update of all inbound links.
- (g) Hard size gate — if over bound, split into the next free numbered file; never truncate silently.
- (h) At 20 numbered files, split into subdirectories, each with its own index.
- (i) Run the pre-flight checks in the festival file §8 before marking `done`.
