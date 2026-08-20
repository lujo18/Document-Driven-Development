---
name: ddd-apply-template
description: Scaffold a document from a framework template using templates/catalog.md as the lookup manifest. Use when the user names a template (ADR, design doc, PRD, plan, festival file) or asks to create a new doc from a skeleton; fills every {{param}} double-brace placeholder into a NEW file at the catalog's target path pattern, never edits the template itself (mtime check), dry-runs before write, and leaves zero dangling placeholders. Triggers: use template X, scaffold an ADR/design doc/PRD/plan/festival file, new doc from skeleton, create a doc.
---
# Template Application

## When to use

- The user names a template: "use template X" or "scaffold an ADR/design doc/PRD/plan/festival file".
- Any doc should start from a canonical skeleton, never a blank page.
- Not for content authoring — this skill applies the shape, not the substance.

## Inputs

1. Template name (e.g., `adr`, `design-doc`, `plan`, `festival`, `prd`) — must resolve in `templates/catalog.md`.
2. Params: slug, title, date, status, and the template-specific placeholder set from the catalog row.
3. The template file itself: `templates/<name>.md`.
4. The catalog manifest: `templates/catalog.md` (target path pattern + required params per template).

## Steps

1. Look up the template in `templates/catalog.md`; read its target path pattern and required params.
2. Resolve the target path from the pattern (e.g., `docs/adr/NNNN-slug.md`, `docs/plans/<slug>.md`); pick the concrete values.
3. Load `templates/<name>.md`; record its mtime before any write.
4. Copy the template to a NEW file at the resolved target path — never edit the template file.
5. Fill every `{{param}}` placeholder with the gathered values; leave none dangling.
6. Dry-run preview: list the file to be written and the placeholder→value map before writing.
7. Write the file; run `ddd-validate-docs` on it.

Runnable check after each step: `grep -c '{{' <new-file>` equals 0 (no dangling placeholders); template mtime unchanged.

## Rules

- Fill every `{{param}}`; leave none dangling.
- Path comes from the catalog pattern, never invented.
- Never modify the template file; verify by unchanged mtime.
- Validate after fill (`ddd-validate-docs`).
- Dry-run list of files to be created before writing (installer-style safety).

## Verification

- Output has all template sections; zero unresolved `{{ }}` (`grep -c '{{'` = 0); template untouched (mtime same); `ddd-validate-docs` passes on the new file; path follows the catalog pattern.
