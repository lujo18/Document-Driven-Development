---
name: ddd-validate-docs
description: Run pre-flight checks on the doc library before merge or sign-off. Use when the user asks to validate, check, lint, audit, or review docs, runs a pre-flight gate, or asks if the doc library is healthy; verifies frontmatter (name == folder, kebab regex, single-line description caps), header contract (H1 matches slug, status line, Purpose word count), size bounds, zero triple-backtick fences, link resolution, index coverage, template placeholder leaks, tag audit with owners, and code-comment link/tag audit; returns a pass/fail report with named violations and a nonzero exit on failure so CI can consume it. Triggers: validate docs, pre-flight check, check the docs, lint the library, before merge, is the doc library healthy.
---
# Doc Validation

## When to use

- Before merge or sign-off of any docs change.
- After any docs change, as a same-change sanity check.
- On demand: "validate docs", "pre-flight check", "lint the library".
- Not for enforcing review judgment — structure and links only.

## Inputs

1. The doc tree to validate: `docs/`, `skills/`, `templates/`, and any changed `.md` files.
2. The format contract: frontmatter rules from `docs/plans/ddd-build-festival-file.md` §4.1; header contract from §4.4.
3. The index contract: `templates/index.md` and the repo's README index.
4. The tag-audit register: the references file's Unverified/Pending table (owner + next action per marker).

## Checks

1. Frontmatter: every SKILL.md has `name` == folder, matches `^[a-z0-9]+(-[a-z0-9]+)*$`; `description:` on one physical line, ≤1024 chars (≤1536 with `when_to_use`); no unknown required fields.
2. Header contract: H1 == filename slug; `> **Status:**` line present with a valid value; `## Purpose` ≤50 words where the doc type requires one.
3. Size bounds: line count per file within its declared bound (SKILL.md <500; templates and plans per their bound tables).
4. Fence audit: zero lines starting with triple-backtick anywhere in built artifacts.
5. Link audit: every `](./` and `../` target resolves to an existing file.
6. Index coverage: every doc reachable from the index; every index entry exists (orphan + phantom check).
7. Template adherence: docs scaffolded from templates contain no unresolved double-brace placeholders.
8. Tag audit: every `[UNVERIFIED]` / `[NEEDS SOURCE]` marker has an owner + next action row in the references file.
9. Comment link & tag audit (when a code dir is configured): scan the code tree for TODO:/FIXME:/HACK:/HACK-REF:/DDD-DOC: tags; every tag has an owner; every HACK-REF:/DDD-DOC: carries a doc link; every doc link resolves to an existing file. **N/A** (pass with note) when no code dir is configured.

Runnable check per rule: produce `PASS` or `FAIL <named violation>` for each of the 9 rules; any FAIL means the library does not pass pre-flight.

## Rules

- Fail = report with named violations and a nonzero exit code — no silent pass.
- v1 runs dependency-free grep/shell checks only; Vale-style prose linting is a documented future gate, not required.
- Same-change rule: validate after every doc change, before merge.
- Do not modify the docs being validated; report only.

## Verification

- A clean tree passes all 9 rules with every rule reported individually.
- Seeded violations (bad name, oversized description, broken link, stale index, fence, unowned tag) each produce a named FAIL.
- The exit code is nonzero when any rule fails; zero when all pass.
