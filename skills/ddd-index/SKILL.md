---
name: ddd-index
description: Keep the README/doc index in sync with the file tree: one-line descriptions, statuses, glossary; update in the same change as any file add/rename/remove; never renumber. Use when files are added, renamed, moved, or removed, when the index is stale, when ddd-validate-docs reports index drift, or when asked to update the index, add to the README list, or fix the doc map. Triggers: update the index, new doc added, renamed/moved a file, index is stale, add to the README list.
---
# Index Maintenance

## When to use

- Any file add, rename, move, or removal under the indexed directory (e.g. `docs/`).
- An index-stale report from `ddd-validate-docs` flags missing or orphaned entries.
- The user asks to "update the index", "add to the README list", or "fix the doc map".
- Not for authoring content — only for keeping the map accurate.

## Inputs

1. File tree under the indexed directory: list the actual `.md` files.
2. Current index file(s): the README index and any per-directory index files.
3. Index contract: `templates/index.md` — the fill-in skeleton the index must instantiate.
4. Git state or the prior index — to distinguish renames from adds/removes.

## Steps

1. Enumerate the tree: `find docs -type f -name '*.md' | sort` (use the repo's doc dir if not `docs/`).
2. Parse the current index's File Map into `{path, one-line description, status}` rows.
3. Diff tree vs index; flag (a) files with no index row and (b) rows pointing at missing files.
4. For each new file, add a row with a one-line description; take the next free number, never renumber.
5. For each rename/move, update the row path AND grep-update every inbound link to the old path.
6. For each removal, delete the row; never reuse or renumber remaining IDs.
7. Update statuses and glossary only where the index contract requires them.
8. Re-run the index checks in `ddd-validate-docs`; confirm zero drift.

Runnable check after each step: re-diff tree vs index — stop if drift is not zero, or a flagged duplicate description is awaiting a user decision.

## Rules

- Same-change rule: index updated in the SAME change as the file operation it reflects.
- Never renumber numbered IDs; renames only with a grep-update of all inbound links.
- One-line descriptions only; duplicate descriptions are flagged, never auto-merged.
- Every doc reachable from the index; every index entry exists.
- README stays minimal: entrypoint + install link only (AGENTS.md invariant).
- Detail lives behind links: index entries are pointers, not content summaries (see `docs/research/07-agent-indexing.md`).

## Verification

- Tree ↔ index 1:1: `comm -3 <(find <doc-dir> -type f -name '*.md' | sort) <(grep -o '\./[0-9a-z-]*\.md' <index-file> | sort | tr -d './')` shows no drift, where `<doc-dir>` and `<index-file>` are the values detected in Step 1 (the index file is whatever README index the repo has — not necessarily `docs/README.md`).
- `ddd-validate-docs` index-coverage checks pass with zero named violations.
- No ID was renumbered; renamed files have all inbound links updated in the same change.
- The index was updated in the same change as the file operation (git diff shows both).
