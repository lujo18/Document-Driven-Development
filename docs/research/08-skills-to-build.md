# 08-skills-to-build
> **Status:** done

## Purpose

**What:** The framework's v1 skill inventory — 10 skills with specs, skeletons, priorities, and research justification — scoped per festival §5 for the build phase. **When to read:** Planning the build phase or scoping skills. **Not for:** Indexing/search conventions ([07-agent-indexing](./07-agent-indexing.md)) or skill-routing format details ([07-agent-indexing](./07-agent-indexing.md)).

## TL;DR

- Ship **10 skills** exactly as fixed by festival §5 — `ddd-plan`, `ddd-run-flow`, `ddd-adr`, `ddd-design-doc`, `ddd-prd`/`ddd-festival-file`, `ddd-apply-template`, `ddd-validate-docs`, `ddd-review-gate`, `ddd-index`, `ddd-install`.
- One portable `SKILL.md` per skill; no per-ecosystem variants in v1 (OpenCode, Claude Code, .agents all read the same frontmatter format).
- Author in festival-mandated rank: **index + validation → ADR + design-doc + plan (+ festival-file) → template application → flow orchestration + review gates → installer**.
- Format gates enforced by `ddd-validate-docs`: name pattern, description caps (1024 / 1,536), body <500 lines, links resolve, index coverage.
- `ddd-run-flow` and `ddd-review-gate` define the gated pipeline; every stage ends with a runnable pass/fail check, never prose claims.
- Templates drive doc creation (`templates/adr.md`, `design-doc.md`, `plan.md`, `festival-file.md`, `prd.md`); `ddd-apply-template` scaffolds from them; templates are **copies** on install.
- `ddd-install` is the last artifact: idempotent, symlink skills, copy templates/scripts, never clobber without confirmation, honor per-agent dirs (`.opencode/`, `.claude/`, `.agents/`, `.cursor/`).
- Every skill self-verifies with concrete runnable checks; each justified by ≥1 research file in `docs/research/`.

## Skill Category Map

| Category | Skills | Why the category exists |
|---|---|---|
| Flow orchestration | `ddd-plan`, `ddd-run-flow` | Turn an ambiguous request into a doc-first plan, then execute it through gated stages. Make document-driven development the default path for any change. |
| Doc/plan writing | `ddd-adr`, `ddd-design-doc`, `ddd-prd` / `ddd-festival-file` | Produce the core artifacts (decision records, design docs, kickoff specs). Most frequent outputs; instantiate all numbering/template conventions. |
| Template application | `ddd-apply-template` | Scaffold docs from skeletons so writing is cheap, consistent, never from a blank file. |
| Validation/review gates | `ddd-validate-docs`, `ddd-review-gate` | Pre-flight checks and sign-off enforcement; give `ddd-run-flow` its gates. |
| Index maintenance | `ddd-index` | Keep the README/doc index a reliable map for humans and agents. Without it docs become undiscoverable and links rot. |
| Installer | `ddd-install` | Deliver the whole framework into a consumer repo per AGENTS.md invariants. |

## Skill Specs

Format shared by all: frontmatter `name` (== folder name) + `description` (what+when), body opens with **When to use**, then input gathering, artifact rules, verification. Referenced files live one level deep under the skill folder (`references/`) — never deeper. SKILL.md skeletons are 4-space-indented blocks (frontmatter `---`, `name:`, `description:`, `---`, `# Name`, `## When to use`, `## Inputs`, `## Steps`, `## Outputs`, `## Verification`).

### ddd-plan

**Purpose.** Turn a user request into a doc-first plan before any code: sequence doc changes ahead of code, attach a gate to every phase, define "done" per phase.
**Triggers.** "build/implement/add/change/refactor X"; "make a plan first"; "before you write code"; "how should we approach this"; "plan this feature".
**Inputs → Outputs.** Request + repo context (AGENTS.md, doc index, affected docs, git state) → `docs/plans/<slug>.md` with phases, doc-first ordering, per-phase gates, definition of done.
**SKILL.md skeleton (indented block):**

    ---
    name: ddd-plan
    description: Plan features and changes document-first, before any code. Use when
      the user asks to build, change, add, refactor, or implement something and you
      need a plan that sequences doc changes ahead of code, with per-phase gates and
      a definition of done. Triggers: build, change, add, refactor, implement, plan.
    ---
    # Document-Driven Plan
    ## When to use
    - Any request that will change behavior, docs, or both. Not for read-only Q&A.
    ## Inputs to gather (in order)
    1. AGENTS.md and README (conventions, invariants)
    2. Doc index (find related docs; follow ddd-index contract)
    3. Affected files + git status
    ## Plan structure (template: references/plan-template.md)
    - Goal, non-goals, constraints
    - Phase list, each: doc changes → code changes → gate (dd: verify)
    - Every phase ends with a runnable check; no "hope it works" tasks
    - Definition of done per phase
    ## Rules
    - Docs before code, in the SAME change (docs-as-code)
    - Plan < 150 lines; split into multiple plans if larger
    - Update the plan in the same change you execute it (never renumber phases)
    - Hand off to ddd-run-flow only after the plan is accepted
    ## Verification
    - Plan exists at canonical path; every phase maps to doc+code work and a gate;
      no code was modified during planning.

**Verification.** Plan doc exists at `docs/plans/`; every phase names its gate and its doc/code outputs; the plan contains no code edits; a reviewer can execute it without clarifying questions.
**Justification.** ← `./02-ddd-flow.md` (same-PR docs+code, block merges without docs), `./03-best-practices.md` (document what's planned, not speculative), `./06-templates-roadmap-design-feature.md` (imperative phases, runnable success metrics), README contract.

### ddd-run-flow

**Purpose.** Execute a `ddd-plan` stage by stage, blocking at gates, producing a gated execution log proving each stage passed before the next started.
**Triggers.** "start/run/execute the plan"; "kick off the flow"; "continue the pipeline"; "run phase N"; "what's the status".
**Inputs → Outputs.** Accepted plan + repo → gated execution log (per-stage pass/fail, gate sign-offs, artifacts touched, same-PR doc+code updates, machine-readable summary).
**SKILL.md skeleton (indented block):**

    ---
    name: ddd-run-flow
    description: Execute a document-driven plan stage by stage with verification gates
      between stages. Use when the user says to start, run, execute, or kick off a plan,
      or to continue a gated pipeline. Produces a gated execution log with pass/fail
      per stage, gate sign-offs, and a machine-readable report for CI.
    ---
    # Gated Execution Flow
    ## When to use
    - Only with an accepted plan from ddd-plan. No plan → return to ddd-plan.
    ## Stage protocol (repeat per stage)
    1. Load stage spec (docs first, then code)
    2. Implement; run the stage's runnable check (ddd-validate-docs for doc stages)
    3. Gate: run ddd-review-gate checklist; blockers stop the flow
    4. Record result in the execution log (append-only); continue or abort
    ## Rules
    - No stage starts until the previous gate passed
    - Every task ends with build+verify (festival discipline); no unchecked task
    - Abort = stop + log + report, never silent skip
    - Update plan/log in the same change as the work it records
    ## Verification
    - Log shows every stage with explicit PASS/FAIL at its gate; artifacts exist;
      final summary lists gates, artifacts, and remaining work.
    - Optional: emit a short plain-text gate report that a consumer CI can parse.

**Verification.** Execution log append-only, contiguous pass chain; no stage skipped or reordered; abort paths recorded; exit semantics usable in a consumer CI hook.
**Justification.** ← `./06-templates-roadmap-design-feature.md` (build/verify-after-every-task gates), `./02-ddd-flow.md` (CI gate integration), `./03-best-practices.md` (executable specs over prose).

### ddd-adr

**Purpose.** Capture an architecture decision in one record with a status lifecycle (proposed → accepted → superseded), monotonic numbering, supersession links.
**Triggers.** "record an ADR"; "architecture decision"; "decide between X and Y"; "why did we choose"; "capture this decision"; "mark an ADR superseded".
**Inputs → Outputs.** Decision context + options + chosen option → `docs/adr/NNNN-slug.md`; index and supersession links updated in the same change.
**SKILL.md skeleton (indented block):**

    ---
    name: ddd-adr
    description: Capture an architecture decision record (ADR) when a design choice
      is made. Use when the user chooses between options, asks why a decision was made,
      or wants decisions recorded with a proposed/accepted/superseded status lifecycle,
      one decision per file, monotonic numbering.
    ---
    # ADR
    ## When to use
    - A decision with durable consequences; one decision per ADR
    ## Numbering & lifecycle (reference: references/adr-template.md)
    - Monotonic NNNN; never renumber or reuse (ADR discipline)
    - Status: proposed → accepted → superseded; superseded links to successor
    ## Template sections
    - Status, Date, Context, Decision, Consequences, Options considered
    - Options with trade-offs, not just the winner
    ## Rules
    - Update index + links in the same change (ddd-index contract)
    - Do not rewrite history: supersede, don't edit an accepted ADR
    ## Verification
    - File at docs/adr/NNNN-slug.md; unique monotonic number; status field valid;
      superseded ADRs link successors; index entry present.

**Verification.** ADR exists with required sections and valid status; number monotonic and unique; superseded records link forward; `ddd-validate-docs` passes the ADR pattern check.
**Justification.** ← `./04-templates-adr.md` (one decision per record, status lifecycle, monotonic numbering), `./03-best-practices.md` (document stable decisions, not speculation).

### ddd-design-doc

**Purpose.** Produce a Google-style design document for non-trivial features: goals/non-goals, options, trade-offs, explicit decision before implementation.
**Triggers.** "write a design doc"; "design this feature"; "non-trivial feature"; "architecture review"; "design before coding".
**Inputs → Outputs.** Request + context → `docs/design/<slug>.md` following the design-doc template; decisions inside funnel into `ddd-adr` records.
**SKILL.md skeleton (indented block):**

    ---
    name: ddd-design-doc
    description: Produce a Google-style design document for non-trivial features.
      Use when the user asks for a design doc, wants a feature designed before
      implementation, or needs architecture review with context, goals/non-goals,
      options, trade-offs, decision, and risks.
    ---
    # Design Document
    ## When to use
    - Non-trivial, cross-cutting, or risky features. Small changes → ddd-plan only.
    ## Template (reference: references/design-doc-template.md)
    - Context, Goals / Non-goals, Options, Trade-offs, Decision, Risks, Open questions
    ## Rules
    - ≥2 options with trade-offs before any decision section is written
    - Extract durable choices into an ADR (ddd-adr); link it
    - Design doc < 300 lines; split sections if larger
    - Same-change rule: update index and related docs when the design lands
    ## Verification
    - All template sections present and non-empty; decision section explicit; risks listed;
      linked from the doc index; ADR created for durable decisions.

**Verification.** Every template section present and non-empty; Decision section names a choice; risks listed; indexed; durable decisions have ADRs.
**Justification.** ← `./06-templates-roadmap-design-feature.md` (Google-style structure), `./04-templates-adr.md` (decisions live in ADRs), `./02-ddd-flow.md` (design reviewed in-PR).

### ddd-prd / ddd-festival-file

**Purpose.** Produce a PRD (product intent) or a festival file (agent implementation brief) at feature/phase kickoff. One skill, two artifact modes sharing the same discipline: imperative language, atomic tasks with runnable success metrics, explicit scope restrictions, build+verify gates after every task. **Naming decision for v1:** ship a single skill under canonical name `ddd-festival-file`; `ddd-prd` stays a trigger alias routed to the same skill (PRD mode = product-focused template, festival mode = implementation-focused template).
**Triggers.** "feature/phase kickoff"; "write a PRD"; "create a festival file"; "implementation brief"; "spec it before building"; "hand this to an agent".
**Inputs → Outputs.** Request + context + mode (prd | festival) → `docs/specs/<slug>-prd.md` or `docs/specs/<slug>-festival.md`.
**SKILL.md skeleton (indented block):**

    ---
    name: ddd-festival-file
    description: Write a product requirements document (PRD) or festival-file
      implementation brief at feature or phase kickoff. Use when the user starts a
      feature/phase and needs an imperative, task-atomic spec with runnable success
      metrics, scope restrictions, and build/verify gates. Triggers: PRD, festival
      file, kickoff, implementation brief.
    ---
    # PRD / Festival File
    ## When to use
    - Feature/phase kickoff; mode = prd (product intent) or festival (agent build brief)
    ## Structure (references: references/prd-template.md, references/festival-template.md)
    - Scope + explicit NON-goals/restrictions (scope restrictions section)
    - Atomic tasks, imperative mood, each with a runnable success metric
    - Gate list: build + verify after EVERY task; no unchecked task
    - Dependencies and ordering between tasks
    ## Rules
    - Spec must be executable by an agent without clarifying questions
    - Size guard: festival file < 500 lines; split phases otherwise
    - Update spec in the same change you execute it
    ## Verification
    - Spec contains scope, atomic tasks each with runnable metric, gate list;
      an agent executing it reaches a defined end state.

**Verification.** Artifact has scope + restrictions, tasks with runnable metrics, gate list; test run through first 2 tasks produces no ambiguity; tasks atomic (one outcome each).
**Justification.** ← `./06-templates-roadmap-design-feature.md` (imperative language, atomic tasks, build/verify gates), `./02-ddd-flow.md`, `./03-best-practices.md` (executable specs over prose).

### ddd-apply-template

**Purpose.** Scaffold a document from a research/template skeleton so every new doc starts from the framework's canonical shape instead of a blank file.
**Triggers.** "use template X"; "scaffold an ADR/design doc/PRD/plan/festival file"; "new doc from skeleton"; "create a doc".
**Inputs → Outputs.** Template name + params (slug, date, status, title) → filled doc at canonical path; template file itself never modified.
**SKILL.md skeleton (indented block):**

    ---
    name: ddd-apply-template
    description: Scaffold a document from a framework template. Use when the user
      names a template (ADR, design doc, PRD, plan, festival file) or asks to create
      a new doc from a skeleton; fills placeholders, applies path conventions, and
      never edits the template itself.
    ---
    # Template Application
    ## When to use
    - User names a template or asks for a new doc from a skeleton
    ## Template catalog (reference: references/template-catalog.md)
    - Table: template name → target path pattern → required params
    ## Rules
    - Fill every {{placeholder}}; leave none dangling
    - Path from catalog pattern (e.g., docs/adr/NNNN-slug.md)
    - Never modify the template file; validate after fill (ddd-validate-docs)
    - Dry-run list of files to be created before writing (installer-style safety)
    ## Verification
    - Output has all template sections, placeholders replaced; template untouched;
      doc passes format checks; index updated.

**Verification.** Output matches template's section list with zero unresolved `{{ }}`; template mtime unchanged; `ddd-validate-docs` passes on the new file.
**Justification.** ← `./04-templates-adr.md` (templates as the ADR/design skeleton source), `./07-agent-indexing.md` (frontmatter discipline), README contract.

### ddd-validate-docs

**Purpose.** Run pre-flight checks on the doc library before merge/sign-off: frontmatter validity, name pattern, description caps, link resolution, index coverage, template adherence, size limits, placeholder leaks.
**Triggers.** "validate docs"; "pre-flight check"; "check the docs"; "lint the library"; "before merge"; "is the doc library healthy".
**Inputs → Outputs.** Docs tree → pass/fail report listing each rule and its result; nonzero exit on failure so CI can consume it.
**SKILL.md skeleton (indented block):**

    ---
    name: ddd-validate-docs
    description: Run pre-flight checks on the doc library before merge or sign-off.
      Use when the user asks to validate, check, lint, or audit docs; verifies
      frontmatter, description caps, naming, links, index coverage, template
      adherence, and size limits; returns a pass/fail report usable in CI.
    ---
    # Doc Validation
    ## When to use
    - Before merge/sign-off, after any docs change, or on demand
    ## Checks (reference: references/checklist.md)
    - Frontmatter: name present, matches ^[a-z0-9]+(-[a-z0-9]+)*$, folder name
    - Description: what+when phrasing; ≤1024 chars; ≤1536 with when_to_use
    - Body < 500 lines; references one level deep
    - Links resolve; every doc reachable from index; index lists every doc
    - Templates: sections match, no unresolved {{placeholders}}
    ## Rules
    - Fail = nonzero exit + named violations (no silent pass)
    - v1: dependency-free grep/shell checks; Vale documented as a future gate
    - Same-change rule: validate after every doc change
    ## Verification
    - Known-bad repo fails with named violations; known-good passes; each rule
      reported individually with pass/fail.

**Verification.** Deterministic: seeded violations (bad name, oversized description, broken link, stale index) each produce a named failure; a clean tree passes with every rule reported.
**Justification.** ← `./07-agent-indexing.md` (all caps tested here), `./02-ddd-flow.md` (CI doc quality gates), README contract (index coverage).

### ddd-review-gate

**Purpose.** Enforce a reviewer checklist before a phase ships: per-artifact-type checklists, blockers vs nits, recorded sign-off decision.
**Triggers.** "review gate"; "sign off"; "phase review"; "is this ready to ship"; "run the checklist"; "blockers?".
**Inputs → Outputs.** Artifacts + phase → checklist results + sign-off record (PASS / FAIL-BLOCKED with named blockers).
**SKILL.md skeleton (indented block):**

    ---
    name: ddd-review-gate
    description: Enforce a reviewer checklist before a phase ships. Use when the user
      asks for a review gate, sign-off, phase review, or whether work is ready; checks
      artifacts against per-type checklists, separates blockers from nits, and records
      the sign-off decision.
    ---
    # Review Gate
    ## When to use
    - End of any phase; consumed by ddd-run-flow gates; on-demand sign-off
    ## Checklists by artifact (reference: references/checklists.md)
    - plan: goals explicit, phases gated, size ok
    - ADR: one decision, status valid, numbered, linked
    - design doc: all sections, decision present, risks listed
    - festival file: atomic tasks, runnable metrics, scope restrictions
    - code: tests/checks pass; docs updated in same change
    ## Rules
    - Blockers must be resolved before sign-off; nits are logged, not blocking
    - Record the decision (PASS or FAIL + blockers) into the artifact/execution log
    - Agent may run the checklist; final human sign-off is recorded where required
    ## Verification
    - Every checklist item answered PASS/FAIL; no unresolved blockers; decision
      recorded; gate feeds ddd-run-flow.

**Verification.** Checklist output all-answered with explicit blocker classification; a gated flow refuses to advance on unresolved blockers; sign-off decision recorded.
**Justification.** ← `./02-ddd-flow.md` (review as a merge gate), `./06-templates-roadmap-design-feature.md` (phase gates), `./03-best-practices.md`.

### ddd-index

**Purpose.** Keep the README/doc index in sync with the file tree: one-line descriptions, statuses, glossary; update in the same change as any file add/rename/remove; never renumber.
**Triggers.** "update the index"; "new doc added"; "renamed/moved a file"; "index is stale"; "add to the README list".
**Inputs → Outputs.** File list (tree diff) → updated index (README + per-dir index files) with 1:1 tree coverage.
**SKILL.md skeleton (indented block):**

    ---
    name: ddd-index
    description: Keep the README/doc index in sync with the file tree. Use when files
      are added, renamed, moved, or removed, or when the index is stale; maintains
      one-line descriptions, statuses, and glossary; never renumbers; updates the
      index in the same change.
    ---
    # Index Maintenance
    ## When to use
    - Any file add/rename/remove; stale-index report from ddd-validate-docs
    ## Index contract (reference: references/index-format.md)
    - Small curated index; one-line description per entry; status field
    - Glossary for domain terms; IDs/numbers never renumbered
    - README stays minimal (AGENTS.md): entrypoint + install link only
    ## Rules
    - Same-change rule: index updated in the SAME change as the file operation
    - Detect staleness: compare file tree vs index; every doc reachable,
      every index entry exists
    - Duplicate descriptions → flag, never auto-merge
    ## Verification
    - Tree ↔ index 1:1; entries one-line with status; no renumbered IDs;
      ddd-validate-docs index check passes.

**Verification.** Tree-vs-index diff shows zero drift after the skill runs; entries one line each with status; no ID renumbering; index check passes.
**Justification.** ← `./07-agent-indexing.md` (llms.txt/agents.md index discipline: small, curated, one-line, statused), `./02-ddd-flow.md`, AGENTS.md README-minimal contract.

### ddd-install

**Purpose.** Install skills, docs, scripts, templates into a consumer repo per AGENTS.md: per-agent directories, symlinked skills, copied templates/scripts, no clobber without confirmation, idempotent.
**Triggers.** "install the framework"; "set up ddd"; "bootstrap this repo"; "install skills/docs/scripts".
**Inputs → Outputs.** Consumer repo → installed framework (manifest of every written/symlinked path; agent dirs populated; README note appended with confirmation).
**SKILL.md skeleton (indented block):**

    ---
    name: ddd-install
    description: Install the document-driven development framework into a consumer
      repository. Use when the user says install, setup, or bootstrap the framework;
      copies/symlinks skills, docs, scripts, and templates into per-agent
      directories; idempotent, never clobbers without confirmation.
    ---
    # Install
    ## When to use
    - Consumer repo setup or re-run (idempotent repair)
    ## Flow
    1. Detect agent dirs present: .opencode/, .claude/, .agents/, .cursor/
    2. Dry-run manifest of every action BEFORE writing (safety, AGENTS.md)
    3. Symlink skills (live updates); COPY templates + scripts
    4. Confirm any overwrite; never clobber silently
    5. Append install note to consumer README (with confirmation)
    6. Re-run is a no-op (idempotent); uninstall notes included
    ## Platform
    - POSIX-first; on Windows where symlinks fail, fall back to copies and
      document the trade-off (no live updates)
    ## Verification
    - Second run produces zero changes; every path in the manifest exists;
      no pre-existing file modified without explicit confirmation.

**Verification.** Running twice yields identical state (idempotent); manifest lists every installed path and all exist; pre-seeded conflicting file untouched unless confirmed; skills discoverable in target agent dirs.
**Justification.** ← AGENTS.md invariants 1–2 (no harness, installs into project), symlink/copy + overwrite-safety decisions, `./07-agent-indexing.md` (what a skill folder must contain).

## Priorities & Sequencing

1. **Index maintenance + validation — `ddd-index`, `ddd-validate-docs`.** Encode the format contract, so every later skill is authorable against a verifiable bar and the doc tree stays discoverable. *Must exist first:* `docs/` tree with `research/` populated, README index contract, first index skeleton; `skills/` format decision recorded in `./07-agent-indexing.md`.
2. **ADR + design-doc + plan (+ festival-file/PRD) — `ddd-adr`, `ddd-design-doc`, `ddd-plan`, `ddd-festival-file`.** The doc-creation core; instantiate numbering, template, and doc-first rules; `ddd-plan` is the flow's entry point. *Must exist first:* `templates/adr.md` and `templates/design-doc.md` (from `./04-templates-adr.md`/`./06-templates-roadmap-design-feature.md` research), `docs/adr/` + `docs/design/` conventions, decision on `ddd-prd` vs `ddd-festival-file` naming (this doc: one skill, canonical `ddd-festival-file`, `ddd-prd` alias).
3. **Template application — `ddd-apply-template`.** Depends on a complete template catalog; worthless before the templates exist. *Must exist first:* full template set (`adr.md`, `design-doc.md`, `plan.md`, `festival.md`, `prd.md`) plus `template-catalog.md`.
4. **Flow orchestration + review gates — `ddd-run-flow`, `ddd-review-gate`.** Execution and sign-off meaningful once the doc skills produce artifacts to gate. *Must exist first:* accepted-plan convention from `ddd-plan`, per-type review checklists, `ddd-validate-docs` as the doc-stage gate.
5. **Installer — `ddd-install`.** Last: packages everything that came before. *Must exist first:* all skills, docs, scripts, templates; `install.sh` script (scripts are **copies**, per AGENTS.md); platform decision (POSIX-first, Windows fallback) recorded in an ADR.

## Relationship to Research Library

| Skill | Justifying research files |
|---|---|
| `ddd-plan` | `./02-ddd-flow.md`, `./03-best-practices.md`, `./06-templates-roadmap-design-feature.md`, README contract |
| `ddd-run-flow` | `./06-templates-roadmap-design-feature.md`, `./02-ddd-flow.md`, `./03-best-practices.md` |
| `ddd-adr` | `./04-templates-adr.md`, `./03-best-practices.md` |
| `ddd-design-doc` | `./06-templates-roadmap-design-feature.md`, `./04-templates-adr.md`, `./02-ddd-flow.md` |
| `ddd-festival-file` / `ddd-prd` | `./06-templates-roadmap-design-feature.md`, `./02-ddd-flow.md`, `./03-best-practices.md` |
| `ddd-apply-template` | `./04-templates-adr.md`, `./07-agent-indexing.md`, README contract |
| `ddd-validate-docs` | `./07-agent-indexing.md`, `./02-ddd-flow.md`, README contract |
| `ddd-review-gate` | `./02-ddd-flow.md`, `./06-templates-roadmap-design-feature.md`, `./03-best-practices.md` |
| `ddd-index` | `./07-agent-indexing.md`, `./02-ddd-flow.md`, AGENTS.md (minimal README) |
| `ddd-install` | AGENTS.md invariants 1–2 + symlink/copy + overwrite-safety; `./07-agent-indexing.md` |

## Open Design Questions

1. **`ddd-run-flow` vs consumer CI.** Does `ddd-run-flow` only *produce* a machine-readable gate report for the user's existing CI, or should the framework ship a dependency-free `scripts/gate-check.sh` that CI invokes directly? (no-runtime-deps invariant permits a shell script, but adds installer surface and Windows testing).
2. **One portable `SKILL.md` vs per-ecosystem variants.** OpenCode/agentskills cap description at 1024 chars; Claude Code caps description + `when_to_use` at 1,536. If one description must serve both, it must be written under the stricter cap — accept, or generate per-agent trimmed variants at install time (violates "no per-agent proprietary formats" unless decided in a doc)?
3. **Where AGENTS.md updates plug in.** Installing the framework should document itself in the consumer's AGENTS.md — a `ddd-install` step (appended with confirmation), a post-install `ddd-plan` task, or a deliberate non-goal? (`ddd-index` + `ddd-validate-docs` same-change rule is the likely home).
4. **Symlink vs copy fallback on Windows.** Windows consumers may lack symlink privileges — fall back to copies silently, or prompt? Affects the update story for every skill.
5. **`ddd-prd` vs `ddd-festival-file`.** This doc ships one skill (`ddd-festival-file`) with `ddd-prd` as trigger alias and two templates (PRD vs festival mode). Right split, or do the artifacts diverge enough to warrant separate skills later?
6. **Vale vs shell-only validation.** Docs-as-code research recommends Vale for prose gates, but no-runtime-deps forbids adding it to consumer repos. Permanently grep/shell-only, or detect and optionally invoke a consumer's existing Vale install?
