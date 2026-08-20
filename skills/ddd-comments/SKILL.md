---
name: ddd-comments
description: Annotate code with greppable doc-index comments so agents and humans trace code to its governing docs and track owned debt. Use when implementing code, reviewing a PR, or auditing comment hygiene; applies the tag vocabulary (DDD: module header, TODO:/FIXME:/HACK:/HACK-REF: with owner and optional doc link, DDD-DOC: symbol-reference breadcrumbs), enforces the anti-rot rule (comments link docs, never restate them), and runs a dependency-free grep audit at Stage 4 Verification and Stage 5 Review. Triggers: code comments, comment convention, comment audit, comment tags, doc-index comments, TODO audit, add header comments.
---
# Code-Comment Indexing

## When to use

- Any code implementation, review, or audit where comments must point at governing docs.
- Repos with no comment conventions — establish the tag vocabulary once.
- At Stage 4 Verification (Gate 3) and Stage 5 Review (Gate 4) as the comment half of the doc-truth check.
- Not for authoring docs — this skill annotates code.

## Inputs

1. Comment register: `templates/comments.md` (per-repo tags, owners, doc root, audit command).
2. Doc root + code dir to audit (which directories hold governing docs and source code).
3. Governing docs: `docs/plans/`, `docs/adr/`, `docs/design/`.
4. Flow/gate context: `docs/research/09-flows-and-strategies.md`.

## Conventions

Tag vocabulary (greppable, one token set across languages):

    DDD:       module header — one line atop every module file
    TODO:      owner [docs/...] — owned, dated debt, optional doc link
    FIXME:     owner [docs/...] — owned defect, optional doc link
    HACK:      owner [docs/...] — owned workaround, optional doc link
    HACK-REF:  owner [docs/...] — workaround + REQUIRED doc link
    DDD-DOC:   docs/... [#section] — breadcrumb; REQUIRED link

Owner = handle/initials/team, no spaces. Doc-link is relative from the doc root. Rules:

- Header rule: one `DDD:` line atop every module file (>~100 lines or imported/called); small scripts may skip.
- Docstring rule: 1–3 line comment on non-trivial functions (>15 lines, non-obvious, public API); state what and why, link decisions.
- Breadcrumb rule: code implementing a plan section/ADR/design-doc decision carries `DDD-DOC:` link, one per block.

Per-language delimiters:

    //   C/C++/Java/JS/TS/Go/Rust/Swift
    #    Python/Ruby/Shell/YAML/Makefile
    --   SQL
    <!-- HTML/XML/JSX/TSX -->

## Steps

1. Load the register (`templates/comments.md`); confirm the doc root and code dir.
2. Identify the governing doc (plan section, ADR, design doc) before writing code.
3. Add a `DDD:` module header on new files.
4. Add docstrings and `DDD-DOC:` breadcrumbs where code implements a decision.
5. Tag debt with owner; hacks get `HACK-REF:` + a tracking doc link.
6. Run the audit; fix named violations.

Runnable check after each step: the tag grep returns only owned, linked, non-restating comments.

## Rules

- Anti-rot: comments point at docs, never restate — a fact in a doc appearing in a comment is a FAIL.
- Cheap index surface, not prose: header ≤1 line, docstring ≤3, tagged ≤1.
- Every `HACK:` becomes `HACK-REF:` or is removed.
- No trivia comments.
- Same-change rule for breadcrumbs + code + referenced doc.

## Verification

Run these four greppable checks (code dir configured):

    grep -rnE '(TODO|FIXME|HACK-REF|HACK|DDD-DOC|DDD):' <code-dir> | grep -vE 'DDD:[[:space:]]*[A-Za-z]' | grep -vE 'DDD-DOC:[[:space:]]*docs/' | grep -vE '[A-Za-z0-9_.-]+ \[docs/'
    head -n 8 <file> | grep 'DDD:'      # every module file has a header
    grep -rhoE 'docs/[A-Za-z0-9._/-]+\.md' <code-dir> | sort -u | while read -r _f; do [ -f "$_f" ] || echo "BROKEN LINK: $_f"; done
    grep -rnE 'HACK:' <code-dir>        # no bare HACK without HACK-REF

Seeded violations (unowned tag, bare HACK, missing header, broken doc link) each produce a named FAIL; a clean tree passes with every rule reported.
