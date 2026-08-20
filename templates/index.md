# {{title}}

<!-- when to use: create or refresh the README-as-index for a docs directory so
     humans and agents can answer "where do I look?" from one small file. Fill
     every double-brace placeholder in a NEW file; never edit this template.
     Sections follow the index pattern: directive blockquote, file map,
     navigation rules, reading order, status & legend, glossary. -->

> Agents MUST read this file before opening any other file in this docs directory.

## Purpose

{{purpose}} — one paragraph: what this index maps, who uses it, and the
token-budget philosophy (small index, dense files, detail behind links, status
single-sourced in-file).

## File Map

| # | File | Purpose (what + when) | Size bound |
|---|---|---|---|
| {{num}} | [{{slug}}](./{{slug}}.md) | {{purpose}} — read when {{when}}. | ≤{{bound}} lines |
| {{num}} | [{{slug}}](./{{slug}}.md) | {{purpose}} — read when {{when}}. | ≤{{bound}} lines |

<!-- Add one row per file. # is the file number (01, 02, ...); slug matches the
     filename; purpose is a one-line "what + when"; bound is the declared line
     cap. Keep rows one line each; detail lives behind the links. -->

## Navigation Rules

| If you need X | Read | Not for — do NOT read when |
|---|---|---|
| {{need}} | [{{slug}}](./{{slug}}.md) | {{not-for}} |
| {{need}} | [{{slug}}](./{{slug}}.md) | {{not-for}} |

<!-- One row per common need; the "Not for" column steers readers away from the
     wrong file. -->

## Reading Order for New Agents

1. README — this index; the map. Read first, always.
2. [{{slug}}](./{{slug}}.md) — {{why-first}}.
3. [{{slug}}](./{{slug}}.md) — {{why-next}}.
4. Remaining files on demand — {{when}}.

## Status & Legend

- Status values: `draft` (in progress) → `review` (awaiting review) → `done` (reviewed and signed off). A failed review returns the file to `draft`.
- Status is single-source: the per-file `> **Status:**` line is canonical; this index never states a file's status.
- Tag markers: `[UNVERIFIED]` claim not yet confirmed · `[NEEDS SOURCE]` claim lacks URL · `[DECISION PENDING]` design choice deferred.

## Glossary

{{glossary-note}}

- **{{term}}** — {{definition}}.
- **{{term}}** — {{definition}}.

<!-- Define cross-cutting terms only; link to this section instead of
     re-defining in other files. -->

## How to Extend This Index

- (a) Next free number = largest existing + 1.
- (b) Add/update the File Map row and a Navigation Rules row when a file answers a new need.
- (c) Never renumber or delete files; renames require a grep-update of all inbound links.
- (d) Run pre-flight checks (links resolve, no orphans, no leftover placeholders) before marking `done`.
