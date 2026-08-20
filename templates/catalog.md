# Template Catalog

<!-- when to use: this is the discoverability manifest for every template in this
     directory. ddd-apply-template reads this table to resolve a template name to
     its target path pattern and required params. Keep it 1:1 with the templates/
     tree; add or update a row in the same change as the template. -->

| Template | File | Target path pattern | Required params | Used by |
|---|---|---|---|---|
| index | `templates/index.md` | consumer docs index file (e.g., `docs/README.md`) | title, purpose, num, slug, when, bound, need, not-for, why-first, why-next, glossary-note, term, definition | `ddd-index` |
| adr | `templates/adr.md` | `docs/adr/NNNN-slug.md` | nnnn, title, date, status (choose from lifecycle), superseded-by, who decides, option-a/b/c, trade-offs, context, decision, rationale, consequences, supersession, links | `ddd-adr` |
| design-doc | `templates/design-doc.md` | `docs/design/<slug>.md` | title, authors, reviewers, date, context, goal, non-goal, option-a/b/c, trade-offs and verdict, decision, risks, concerns, rollout, references | `ddd-design-doc` |
| plan | `templates/plan.md` | `docs/plans/<slug>.md` | title, owner, reviewers, date, goal with metric, non-goal, success, criterion, phase name, doc changes, code changes, gate, definition of done | `ddd-plan` |
| festival | `templates/festival.md` | `docs/specs/<slug>-festival.md` | title, date, slug, owner, feature, depends-on, complexity, target-directory, objective, scope-restrictions, constraints, phase/task/task-detail/success-metrics, build/verify/lint/test/diff-check commands, acceptance-criteria | `ddd-festival-file` (festival mode) |
| prd | `templates/prd.md` | `docs/specs/<slug>-prd.md` | title, date, slug, owner, problem, audience, goal, non-goal, requirement, success metric, open question | `ddd-festival-file` (PRD mode / `ddd-prd` alias) |
| flow | `templates/flow.md` | `docs/flow/<slug>.md` | title, date, slug, owner, pipeline-summary, stage-0-artifacts, stage-1-artifacts, stage-2-artifacts, stage-3-artifacts, stage-4-artifacts, stage-5-artifacts, stage-6-artifacts, gate-0-pass, gate-1-pass, gate-2-pass, gate-3-pass, gate-4-pass | `ddd-run-flow` |
| comments | `templates/comments.md` | consumer comment register (e.g., `docs/comments.md`) | title, status, owner, date, doc-root, code-dir, audit-command, verification-note | `ddd-comments` |
| catalog | `templates/catalog.md` | `templates/catalog.md` (manifest) | none — reference table only | `ddd-apply-template` |

Notes:

- The catalog itself is not a fill-in template; it is the manifest (reference only).
- flow.md is a forward row: the file is authored in Batch D per the plan §3/§5 contract and `docs/research/09-flows-and-strategies.md` (stages 0–6 with per-stage artifacts/gates + gate table). Its row must match the final file.
- Add a row in the same change you add a template; never renumber template names.
