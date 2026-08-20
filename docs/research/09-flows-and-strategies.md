# 09-flows-and-strategies
> **Status:** done

## Purpose

**What:** The DDD framework's operational spec — the 7-stage flow, 5 gates, strategies, cadences, and metrics. **When to read:** Enforcing or executing the doc-driven pipeline. **Not for:** Pipeline mechanics ([02-ddd-flow](./02-ddd-flow.md)) or the skill inventory ([08-skills-to-build](./08-skills-to-build.md)).

## TL;DR

1. DDD is a 7-stage pipeline (0–6) with 5 gates; gates **block**, stages **produce artifacts**.
2. Docs lead, code follows: no code before an approved plan (Gates 1–2), no merge without docs in the same change (Gate 3).
3. Every doc is a unit of context with a token budget: split past ~400 lines, always linked from the README index.
4. Verification means evidence — tests plus doc-truth checks; prose claims do not pass Gate 3.
5. Maintenance is cadence-driven: ADR at decision time, index refresh on any add/rename, quarterly prune.
6. The framework ships templates and skills, so the default is a template, never a blank page.
7. RDD/DDD guardrails: bounded docs, never DDD-turned-waterfall, docs reviewed like code.
8. Metrics (drift rate, rework, token cost, orphans) are specified here and validated in a later phase.

## DDD Flow Spec

Pipeline 0–6 with gates (4-space indented block):

    install ─▶ 0 Context ─▶ 1 Plan ─▶ 2 Approve ─▶ 3 Implement ─▶ 4 Verify ─▶ 5 Review ─▶ 6 Maintain
               [Gate 0]      [Gate 1]    [Gate 2]                  [Gate 3]    [Gate 4]
               Indexed       Planned     Approved                  Verified    Signed-off
                    ▲            ▲           ▲                          ▲            ▲
                    └────────────┴───────────┴── gate FAIL: return to author, no merge ──┴──────────┘

### Stage 0 — Context & Onboarding

- **Purpose:** any new human or agent can answer "where do I look?" from the README index + AGENTS.md without reading the whole repo.
- **Artifacts in → out:** bare repo → `README.md` index (every doc/skill/script linked), `AGENTS.md` (invariants, conventions, roles), `docs/` skeleton.
- **Framework-owned actors:** README index template; AGENTS.md scaffold; install-time layout from `install.sh`.
- **Gate:** Gate 0 Indexed — README links all files. Pass: an agent asked "where do I look?" resolves correct paths for install, conventions, ADR log, skill catalog.
- **Failure mode if skipped:** agents guess from stale memories or invent structure; onboarding becomes "ask a colleague"; context rot starts before the first task.

### Stage 1 — Doc-First Plan

- **Purpose:** convert intent into a bounded plan — Goals, Non-goals, Success, Acceptance criteria. The plan is the contract code is written against.
- **Artifacts in → out:** README/AGENTS context → `docs/plans/<topic>.md` (or a festival file for execution-grade tasks).
- **Framework-owned actors:** plan template (`templates/plan.md`), festival-file template; the architect role defined in AGENTS.md.
- **Gate:** Gate 1 Planned — plan exists, scope bounded, success defined. Pass: doc states Goals, Non-goals, Success; a reviewer can bound effort from it.
- **Failure mode if skipped:** code starts from a blank page; scope unbounded; features drift; DDD-turned-waterfall — docs become process overhead instead of contracts. RDD guardrail: "punishes lengthy specs" (source: https://tom.preston-werner.com/2010/08/23/readme-driven-development.html).

### Stage 2 — Approval

- **Purpose:** a reviewer signs the plan before code exists; plans are reviewed like code.
- **Artifacts in → out:** drafted plan → approved plan (`status: accepted` in frontmatter).
- **Framework-owned actors:** reviewer role; approval-status convention.
- **Gate:** Gate 2 Approved — reviewer sign-off. Pass: plan marked accepted, no open revision requests.
- **Failure mode if skipped:** unreviewed plans silently become committed direction; rework multiplies at implementation.

### Stage 3 — Implementation, doc-anchored

- **Purpose:** execute the plan; every change maps to a plan section; doc and code move together.
- **Artifacts in → out:** approved plan → code + doc updates in the same change; ADRs for decisions taken during implementation.
- **Framework-owned actors:** task-breakdown convention (one plan section = one work item); same-PR doc rule.
- **Gate:** work stage — exits through Gate 3 at merge time.
- **Failure mode if skipped:** doc drift — code ships behavior docs never describe (source: https://www.writethedocs.org/guide/docs-as-code/).

### Stage 4 — Verification

- **Purpose:** evidence over prose — tests pass and doc-truth checks pass (docs still match behavior).
- **Artifacts in → out:** implemented change → test results + doc-truth evidence.
- **Framework-owned actors:** test-after-doc convention (acceptance criteria come from the doc); doc-truth check convention.
- **Gate:** Gate 3 Verified — tests pass, docs updated in same change. Pass: CI green; every behavior change carries a doc diff; doc examples are runnable.
- **Failure mode if skipped:** merges without evidence; unverifiable claims; regressions found by users.

### Stage 5 — Review & Sign-off

- **Purpose:** reviewer checklist gates the merge: scope adherence, one-doc-one-concern, index updated, ADRs present.
- **Artifacts in → out:** merge-ready change → signed-off change.
- **Framework-owned actors:** reviewer checklist (`templates/review-checklist.md`); Gate 4.
- **Gate:** Gate 4 Signed-off — checklist all pass.
- **Failure mode if skipped:** merged docs violate structure rules; orphan files accumulate; the index goes stale.

### Stage 6 — Maintenance & Living Docs

- **Purpose:** keep the index truthful and docs lean over time: ADRs at decision time, index refresh on add/rename, quarterly prune.
- **Artifacts in → out:** ADR log; refreshed README; pruned/archived docs.
- **Framework-owned actors:** ADR template + ADR index; prune checklist; status markers in README.
- **Gate:** none per change — cadence-driven; each refresh re-checks Gate 0 (index) and Gate 4 (size limits).
- **Failure mode if skipped:** doc rot; context grows unbounded; onboarding cost climbs; drift rate increases (source: https://ekline.io/blog/docs-as-code-engineering-teams).

## Gate Table

| # | Name | Condition (fixed) | Owner (fixed) | Exit condition | Verifier | On FAIL | validate.sh automation |
|---|------|-------------------|---------------|----------------|----------|---------|--------------------------|
| 0 | Indexed | README links all files | design-team-ia | agent resolves "where do I look?" for every artifact | design-team-ia | Fix index or move file; no new docs merge | crawl `docs/`; flag any `.md` not in README index unless `status: draft` or external |
| 1 | Planned | plan doc with goals/non-goals | architect | plan under `docs/plans/` has Goals, Non-goals, Success, Acceptance criteria | architect | Return to draft; block coding | assert active work items have a plan file; assert required sections exist |
| 2 | Approved | reviewer sign-off on plan | reviewer | plan frontmatter `status: accepted`; no open revisions | reviewer | Revise plan; no code | assert plan status; fail if a plan changed post-approval without re-review |
| 3 | Verified | tests pass, docs updated in same change | coder | CI green; behavior changes carry doc diff; doc-truth checks run | coder + CI | Add tests/docs; no merge | run tests + doc-truth checks; diff-scan code→doc mapping |
| 4 | Signed-off | checklist all pass | reviewer | checklist complete: scope, ≤400-line docs, index updated, ADRs present | reviewer | Back to author; re-review | length check on new docs; README index hash vs file list; ADR presence for new decisions |

## Strategies

Format per strategy: **Rule → Enforcement → Gate → Skill → Notes.** All 7 fixed strategies plus 5 research-backed additions.

### docs-lead / code-follow

- **Rule:** no code until a doc for it exists.
- **Enforcement:** Gates 1–2 block work without an approved plan; PRs must reference a plan section.
- **Gate it protects:** 1.
- **Skill to build:** `./08-skills-to-build.md` → `ddd-plan` skill (plan template + festival-file generator).
- **Notes:** Google's design-doc loop beats code-first (source: https://www.industrialempathy.com/posts/design-docs-at-google/). Answer the "docs update only when it hurts" objection by documenting *stable* things — goals, contracts, decisions (source: https://agilemodeling.com/essays/agileDocumentation.htm).

### test-after-doc

- **Rule:** the doc defines acceptance criteria; tests are written against them.
- **Enforcement:** the plan's Acceptance-criteria section seeds test names; Gate 3 requires those tests pass.
- **Gate it protects:** 3.
- **Skill to build:** `./08-skills-to-build.md` → `ddd-festival-file` execution skill (imperative language, atomic tasks, runnable success metrics, build-validity gate per task, scope restrictions).
- **Notes:** prevents "tests describe whatever the code happens to do"; makes acceptance criteria executable.

### change-in-same-commit

- **Rule:** a behavior change ships with its doc update in the same change/PR.
- **Enforcement:** Gates 3–4; CI diff-scan refuses merges that touch behavior without a doc diff.
- **Gate it protects:** 3.
- **Skill to build:** `./08-skills-to-build.md` → `ddd-run-flow` / `ddd-plan` (PR workflow).
- **Notes:** Write the Docs' core rule — same PR, block merges without docs (source: https://www.writethedocs.org/guide/docs-as-code/). "PR with no docs feels as dirty as one with no tests" (source: https://collectiveidea.com/blog/archives/2014/04/21/on-documentation-driven-development/).

### one-doc-one-concern

- **Rule:** one doc = one concern; split any doc past ~400 lines.
- **Enforcement:** Gate 4 checklist + validate.sh length check; frontmatter tracks `lines`/`tokens`.
- **Gate it protects:** 4.
- **Skill to build:** `./08-skills-to-build.md` → `ddd-validate-docs` / `ddd-index` (split/merge rules).
- **Notes:** RDD lineage — "punishes lengthy specs" (source: https://tom.preston-werner.com/2010/08/23/readme-driven-development.html); bounded docs beat encyclopedias; aligns with the skill-body cap (<500 lines per SKILL.md invariant).

### index-maintenance cadence

- **Rule:** the README index is updated in the same change that adds, renames, or removes a file.
- **Enforcement:** Gate 4; validate.sh orphan crawl; this repo's AGENTS.md invariant.
- **Gate it protects:** 4 (re-checks Gate 0).
- **Skill to build:** `./08-skills-to-build.md` → `ddd-index` skill.
- **Notes:** the index is the "where do I look?" contract; drift here silently breaks every agent's first hop.

### token-budget budgeting

- **Rule:** context-load cost is tracked per file; docs stay lean; detail lives behind links (progressive disclosure).
- **Enforcement:** frontmatter token estimate; Gates 0/4 review; ≤200-line guidance for agent-context files; split when over budget.
- **Gate it protects:** 0 and 4.
- **Skill to build:** `./08-skills-to-build.md` → `ddd-validate-docs` skill.
- **Notes:** "context rot" is the failure mode (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents); AGENTS.md lives by the per-line test (source: https://agents.md/; https://code.claude.com/docs/en/best-practices).

### verify-first

- **Rule:** evidence over prose — pass Gate 3 with tests and doc-truth evidence, not claims.
- **Enforcement:** Gate 3 requires runnable evidence; doc-truth checks execute examples in docs.
- **Gate it protects:** 3.
- **Skill to build:** `./08-skills-to-build.md` → `ddd-review-gate` skill (evidence checklist).
- **Notes:** merges without evidence are the primary drift source; an executable anchor is what makes docs drift measurable.

### template-not-blank-page (research addition)

- **Rule:** every doc starts from a template (plan, ADR, skill, status), never a blank file.
- **Enforcement:** install.sh ships templates; validate.sh asserts required frontmatter/sections.
- **Gate it protects:** 1 and 4.
- **Skill to build:** `./08-skills-to-build.md` → `ddd-apply-template` skill.
- **Notes:** the blank page is the biggest writing tax; Google's design-doc practice makes the template the review contract (source: https://www.industrialempathy.com/posts/design-docs-at-google/).

### executable-specs-over-prose (research addition)

- **Rule:** where the domain allows, acceptance criteria are runnable checks embedded in the doc.
- **Enforcement:** doc-truth checks run at Gate 3; test-after-doc seeds tests from doc criteria.
- **Gate it protects:** 3.
- **Skill to build:** `./08-skills-to-build.md` → `ddd-festival-file` skill.
- **Notes:** keeps drift measurable via the detect → classify → draft → review → measure loop (source: https://ekline.io/blog/docs-as-code-engineering-teams); constraint: checks must stay harness-free — convention-based, not framework-based.

### bounded-docs / no-DDD-waterfall (research addition, RDD guardrail)

- **Rule:** docs are allowed to be incomplete; speculative documentation is deferred; the flow must never become process theater.
- **Enforcement:** token budget + one-doc-one-concern + quarterly prune; plans are contracts for one change, not living novels.
- **Gate it protects:** 4 (and Gate 1 keeps plans small).
- **Skill to build:** `./08-skills-to-build.md` → `ddd-plan` skill.
- **Notes:** RDD warns against DDD-turned-waterfall (source: https://tom.preston-werner.com/2010/08/23/readme-driven-development.html); "document stable things, not speculative" (source: https://agilemodeling.com/essays/agileDocumentation.htm).

### docs-reviewed-like-code (research addition)

- **Rule:** docs get the same review standard as code — same PR, same reviewer, same definition of done.
- **Enforcement:** Gate 2 (plan review) and Gate 4 (doc-quality checklist items); reviewer role in AGENTS.md.
- **Gate it protects:** 2 and 4.
- **Skill to build:** `./08-skills-to-build.md` → `ddd-review-gate` skill.
- **Notes:** "PR with no docs feels as dirty as one with no tests" (source: https://collectiveidea.com/blog/archives/2014/04/21/on-documentation-driven-development/); docs drift precisely because they escape review.

### living-agent-context (research addition)

- **Rule:** AGENTS.md and nearest-file doc headers are living documents; updated in the same change that changes a convention.
- **Enforcement:** AGENTS.md convention-update invariant; nested nearest-file-wins overrides; Gate 4 review.
- **Gate it protects:** 0.
- **Skill to build:** `./08-skills-to-build.md` → `ddd-index` / `ddd-install` skill.
- **Notes:** nearest-file-wins resolution and ≤200-line context files with the per-line removal test (source: https://agents.md/; https://code.claude.com/docs/en/best-practices); fights context rot (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents).

## Cadences

### ADR cadence

- **Trigger:** an architectural decision is made — the ADR is written at decision time and referenced by the code it explains.
- **Owner:** architect.
- **In the framework:** ADR template (`templates/adr.md`); ADR index section in the README; lifecycle `proposed → accepted → superseded`; one decision per record; records are immutable (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions; https://adr.github.io/).

### Index refresh

- **Trigger:** any add, rename, or removal of a doc/skill/script.
- **Owner:** whoever made the change (enforced by Gate 4 + validate.sh).
- **In the framework:** README index; the validate.sh orphan crawl fails the PR when the index diverges from the file tree.

### Quarterly prune

- **Trigger:** calendar quarterly, or on feature deprecation.
- **Owner:** maintainer/reviewer.
- **In the framework:** README status column marks `stable | draft | stale`; prune moves stale docs to `docs/archive/` or deletes them; metrics (orphan count, drift rate) feed the prune list.

## Metrics the Framework Should Track

Defined now; validated in a later phase (after first consumer pilots). Collection must remain dependency-free — no runtime or harness in consumer repos.

| Metric | Definition | Direction | Phase validated |
|--------|-----------|-----------|-----------------|
| time-to-first-plan | time from install/first task to Gate 2 approval of the first plan | lower | later (metrics-validation phase) |
| rework rate | % of changes rejected at any gate | lower, but >0 is healthy — gates should catch issues | later |
| docs-to-code ratio | doc lines vs code lines per merged change | stable calibrated band (collapse = drift risk) | later |
| avg tokens to load a task's context | tokens read to start a task: README → AGENTS → plan → skill chain | lower, bounded | later |
| orphan-file count | docs/skills/scripts not linked from README or referenced anywhere | near zero | later |
| docs drift rate (add) | % of docs whose doc-truth checks fail, or whose referenced code changed without a doc update (source: https://ekline.io/blog/docs-as-code-engineering-teams) | lower | later |
| repeated-question count (add) | same question asked N times in issues/PRs — signal for a missing doc | lower | later |

## How a Consumer Repo Runs This

1. **Install:** run `install.sh` (POSIX-sh, dependency-free, idempotent). It copies scripts and templates and symlinks skills into per-agent dirs (`.opencode/`, `.claude/`, `.agents/`, …); never clobbers existing files without confirmation. No package.json, no runtime.
2. **Scaffold (Gate 0):** the installer drops the README index + AGENTS.md scaffold. Every doc/skill/script is linked. Pass check: an agent can answer "where do I look?".
3. **First plan (Gate 1):** pick the first task → open `templates/plan.md` → write Goals, Non-goals, Success, Acceptance criteria → save under `docs/plans/first-task.md`. The architect (or the `ddd-plan` skill) verifies scope is bounded.
4. **Approval (Gate 2):** a reviewer signs the plan (`status: accepted`). No code until this exists — the sign-off is the permission-to-code.
5. **Implementation (Gate 3):** code + doc changes land in one PR; every change maps to a plan section; acceptance criteria become tests; doc-truth checks run. CI blocks merges that lack the doc diff.
6. **First PR (Gate 4):** reviewer checklist — scope adherence, ≤400-line docs, README index updated, ADRs present. Merge.
7. **Maintenance (stage 6):** decisions made during implementation that shaped architecture become ADRs referenced by the code; index refreshes ride along with every change; the quarterly prune keeps the index truthful and context lean.

## Open Design Questions

1. **Harness-free metrics:** the framework cannot add runtime deps — how do consumer repos report the metrics table? (validate.sh log parsing vs. git-history analysis vs. opt-in CLI counters.)
2. **Portable doc-truth checks:** how do executable-spec/doc-truth checks stay language-agnostic when the framework must not assume any build system? (Markdown convention blocks vs. sidecar scripts in `scripts/`.)
3. **Self-review mode:** solo devs have no human reviewer for Gates 2/4 — do we define an explicit self-review checklist mode, or do those consumers run a degraded flow?
4. **Festival file placement:** do festival files live in `docs/plans/` alongside plan docs, and are they archived or pruned after implementation?
5. **Size thresholds:** is the ~400-line one-doc-one-concern limit (and its interaction with the 500-line SKILL.md cap) the right default across doc types — plans vs ADRs vs skills?
