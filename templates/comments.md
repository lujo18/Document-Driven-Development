# {{title}}

<!-- when to use: register this repo's code-comment indexing conventions so agents
     and humans use one tag vocabulary and one owner map. Fill every double-brace
     placeholder in a NEW file (e.g. docs/comments.md); never edit this template.
     The convention itself is skills/ddd-comments/SKILL.md; this file is the
     per-repo register: tags, owners, doc root, and the audit command. -->

- **Status:** {{status}} · **Owner:** {{owner}} · **Date:** {{date}}
- **Doc root:** {{doc-root}} — links in comments resolve relative to this directory.
- **Code dir:** {{code-dir}} — the source tree the audit scans.

## Tag Vocabulary

| Tag | Meaning | Owner | Doc-link | Example |
|---|---|---|---|---|
| DDD: | module header — one line atop every module file | {{owner}} | optional | `DDD: payment module (see plan p3)` |
| TODO: | owned, dated debt | {{owner}} | optional | `TODO: alice [docs/plans/x.md] dedupe` |
| FIXME: | owned defect | {{owner}} | optional | `FIXME: bob [docs/adr/0002.md] off-by-one` |
| HACK: | owned workaround | {{owner}} | optional | `HACK: carol [docs/design/x.md] timeout` |
| HACK-REF: | workaround + REQUIRED doc link | {{owner}} | REQUIRED | `HACK-REF: dave [docs/adr/0001.md]` |
| DDD-DOC: | symbol-reference breadcrumb | {{owner}} | REQUIRED | `DDD-DOC: docs/adr/0001.md#decision` |

## Anti-Rot Rule

- Comments link docs, never restate them — a fact in a doc appearing in a comment is a FAIL.
- Cheap index surface, not prose: header ≤1 line, docstring ≤3, tagged ≤1.

## Audit

Run at Stage 4 Verification and Stage 5 Review:

    {{audit-command}}

## Verification

- {{verification-note}}
