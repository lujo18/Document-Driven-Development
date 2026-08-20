# DDD Research Phase — Festival File

> **Target path:** `docs/plans/ddd-research-festival-file.md`
> **Status:** Living blueprint — edit in place; every change logged in §10.
> **Phase output:** an indexed, token-efficient research library under `docs/research/` (10 topic files + README index) plus this plan. Zero code, zero tooling, zero AGENTS.md drift.

## 1. Project Charter

**Phase goal.** Produce a verified research library under `docs/research/` that (a) defines Document-Driven Development (DDD) as a methodology and separates it from Domain-Driven Design, (b) maps the end-to-end doc-driven pipeline and inventories working pieces, best practices, pitfalls, and metrics, (c) embeds ready-to-use markdown template skeletons (ADR, issues, roadmaps, design docs/RFCs, PRD/feature/festival files), (d) defines agent indexing and token-efficient search conventions, and (e) scopes the framework's future skills (`08-skills-to-build.md`) and flows/strategies (`09-flows-and-strategies.md`). Every artifact obeys `AGENTS.md` invariants: plain Markdown source of truth, no harness/runtime deps, shell-first, distribution-repo-only.

**Persona.** A consuming agent (OpenCode, Claude Code, etc.) and a developer who installs this framework into an arbitrary repo. The persona reads `docs/research/` as its first context source; it needs fast, low-token, authoritative answers, not prose.

**Mission for this phase (one sentence).** Build a verified, index-first, size-bounded research library that grounds every later framework phase — with zero code, zero tooling, zero AGENTS.md drift.

**Primary success KPI (falsifiable).** All 11 research files exist at their exact paths; every file is within its §3 size bound; every file is listed in `docs/research/README.md`; every internal cross-link resolves at pre-flight; the reviewer gate (§8) passes with zero FAIL items; ≥60% of factual claims in files 01–07 carry inline URLs from real, reachable sources.

**Anti-goals (this phase explicitly does NOT):**
1. Scaffold an application, create `package.json`, or add any runtime/build dependency to this repo.
2. Invent tools, commands, or scripts — no `validate.sh` this phase; verification is manual and documented in §8.
3. Present unverified claims as fact — anything unverified is tagged `[UNVERIFIED]` and listed in `10-references.md`.
4. Build a docs-site generator, MDX, or any rendering toolchain — plain Markdown only.
5. Modify any consumer project or write consumer-facing code.
6. Author any skill folder — this phase writes the skills inventory (`08`) only; each real skill needs its own doc + SKILL.md in a later phase per AGENTS.md.
7. Modify `AGENTS.md` — the repo layout is unchanged this phase.
8. Let any single file balloon past its size bound (§3); overflow becomes a new numbered file.
9. Conflate Domain-Driven Design with Document-Driven Development — R1 must disambiguate and the README glossary fixes the terms.
10. Produce orphan files — every file must be linked from `README.md` before sign-off.

## 2. Research Plan (R1–R4)

All four briefs run in PARALLEL (see §7). Each researcher owns distinct output files — no shared-file writes except the README (written by coder, updated once at the end). Every brief: objective, key questions, search strategy, source types, output contract.

### R1 — What is DDD → `docs/research/01-what-is-ddd.md` (≤400 lines)
- **Objective:** Define Document-Driven Development as a methodology: what it is, where it came from, its philosophy, working pieces, benefits, critiques; and explicitly separate it from Domain-Driven Design and data-driven development.
- **Key questions:** What is DDD in both human-era practice (design docs, ADRs, PR/FAQ, Shape Up pitches) and AI-agent-era practice (spec-driven development, festival files, AGENTS.md, llms.txt)? What is the lineage/timeline? How does it differ from TDD, BDD, and Domain-Driven Design (comparison table)? What benefits are claimed (alignment, async review, audit trail, agent-readability, context) and what critiques exist (doc rot, ceremony, staleness)? What are the "working pieces" of a doc-driven system (spec, plan, festival file, ADR, issue, roadmap, design doc, README index)?
- **Search strategy:** Prefer primary sources: Google Engineering Practices, martinfowler.com, adr.github.io, Basecamp Shape Up guide, GitHub spec-kit, OpenAI and Anthropic engineering blogs, llmstxt.org. Target 10–15 sources; allow ≤5 `[UNVERIFIED]` items. Do not invent URLs.
- **Output contract:** Dense markdown per the §3 skeleton; inline URLs after every sourced claim; `[UNVERIFIED]` markers; ends with a numbered `## Sources` list. No frontmatter, no fluff.

### R2 — Flow & Best Practices → `docs/research/02-ddd-flow.md` (≤400) + `docs/research/03-best-practices.md` (≤400)
- **Objective:** (02) Map the end-to-end doc-driven pipeline: stages, artifacts at each stage, gates, and ownership. (03) Inventory best practices, pitfalls, and metrics so the framework can encode them.
- **Key questions (02):** What stages exist (context/onboarding → doc-first plan → gate → implementation → verification → review/sign-off → maintenance)? What artifact is produced at each stage and by whom? Where do approval gates sit and what are their pass criteria? How do docs become acceptance criteria for code?
- **Key questions (03):** What makes docs effective for agent consumption (density, structure, indexing)? What are the failure modes (doc rot, speculative docs, giant files, orphan files, duplicated content)? What metrics matter (rework rate, time-to-first-plan, docs-to-code ratio, token cost of loading context)?
- **Search strategy:** Google/ThoughtWorks eng practices, BDD living documentation (Cucumber), Shape Up, Anthropic/OpenAI agent engineering posts, popular AI-agent repos' AGENTS.md patterns. 10–15 sources each; ≤5 `[UNVERIFIED]` each.
- **Output contract:** Dense markdown per §3 skeletons; ASCII stage diagram in 02; pitfall table in 03; inline URLs; `[UNVERIFIED]` markers; `## Sources` ending.

### R3 — Template Formats → `04-templates-adr.md` (≤500), `05-templates-issues.md` (≤350), `06-templates-roadmap-design-feature.md` (≤450)
- **Objective:** Collect, compare, and embed ready-to-use markdown skeletons for the template families the framework will ship: ADRs (04), issues (05), roadmaps/design docs/RFCs/PRD/festival files (06).
- **Key questions:** ADR: Nygard format, MADR (adr.github.io/madr), ThoughtWorks variations — structure, pros/cons, when to write, how to number. Issues: GitHub YAML-frontmatter + body convention, bug/feature/chore anatomy, acceptance criteria, labels. Roadmaps: Now/Next/Later, outcome-based, Shape Up cycle. Design docs/RFCs: Google design-doc structure (context, goals/non-goals, design, alternatives, risks), Rust/React RFC patterns, IETF-inspired structure. Feature docs: one-pager PRD, feature brief, festival-file structure (the methodology this repo uses).
- **Search strategy:** adr.github.io, MADR repo, GitHub docs on issue templates, Google eng practices design docs, RFC repos (rust-lang/rfcs, reactjs/rfcs), Shape Up, product-brief sources. 10–15 sources; template skeletons must be transcribed accurately from sources or marked `[UNVERIFIED]`/`[NEEDS SOURCE]`.
- **Output contract:** Each file embeds 3–6 complete, copy-paste-ready skeletons as indented (4-space) code blocks — NOT triple-backtick fences — plus a short "when to use" note per skeleton and a `## Sources` list. Skeletons must render cleanly when pasted.

### R4 — Agent Indexing & Token-Efficient Search → `docs/research/07-agent-indexing.md` (≤500)
- **Objective:** Define the indexing and writing conventions that make a doc library cheap for agents to search and load: llms.txt, AGENTS.md conventions, SKILL.md frontmatter, README-as-index, file organization/numbering, token-efficient style.
- **Key questions:** What is llms.txt (spec, placement, limits, example)? What are AGENTS.md/CLAUDE.md/opencode.md/Cursor-rules conventions and the per-agent directories (.opencode/, .claude/, .agents/, .cursor/)? What is the SKILL.md frontmatter contract (name + description, body)? Why README-as-index, and what must it contain? What file-organization rules make search cheap (stable numeric prefixes, glob-friendly kebab names, single H1 per file, table-of-contents for long files, status markers)? What writing style minimizes tokens (bullets, keyword-first headings, inline links, no duplicated prose)? Keyword search vs embeddings vs hybrid — what fits a plain-markdown repo?
- **Search strategy:** llmstxt.org, agent-framework docs (OpenCode, Claude Code, Cursor), Anthropic/OpenAI agent engineering posts, and the observed conventions in popular repos. 10–15 sources.
- **Output contract:** Dense markdown per §3 skeleton; concrete examples (small llms.txt excerpt, AGENTS.md excerpt, SKILL.md frontmatter sample — all as indented code blocks); inline URLs; `## Sources`.

## 3. Target Deliverables & Information Architecture

**Target tree (exact paths, nothing else created this phase):**
```
docs/
  plans/
    ddd-research-festival-file.md          # THIS plan (≤500 lines)
  research/
    README.md                              # mandatory index (≤150 lines)
    01-what-is-ddd.md                      # R1 (≤400 lines)
    02-ddd-flow.md                         # R2a pipeline (≤400 lines)
    03-best-practices.md                   # R2b practices/pitfalls/metrics (≤400 lines)
    04-templates-adr.md                    # R3a ADR skeletons (≤500 lines)
    05-templates-issues.md                 # R3b issue skeletons (≤350 lines)
    06-templates-roadmap-design-feature.md # R3c roadmap/design/feature skeletons (≤450 lines)
    07-agent-indexing.md                   # R4 indexing & token-efficient search (≤500 lines)
    08-skills-to-build.md                  # skills scope (architect) (≤500 lines)
    09-flows-and-strategies.md             # flows & strategies scope (architect) (≤500 lines)
    10-references.md                       # consolidated sources (≤300 lines)
```
Total library ≈ 4,150 lines ≈ 33k tokens — inside budget for an agent context seed.

**Naming / numbering conventions:**
- Files are `NN-kebab-slug.md`; NN is a fixed two-digit number 01–10. Numbers are permanent — never renumber; new files take the next free number.
- README.md carries no number; it is the index and sits at the top of the directory.
- Cross-linking: from within `research/` use `[slug](./NN-slug.md)`; from `plans/` use `[slug](../research/NN-slug.md)`; from repo root use `docs/research/NN-slug.md`. All links must resolve at pre-flight (§8).
- Header contract per research file: `# NN-slug` H1 exactly matching the filename slug; second line `> **Status:** draft | review | done`; one-paragraph `## Purpose`; optional `## Contents` if >200 lines.
- Tag markers: `[UNVERIFIED]` (claim not yet confirmed), `[NEEDS SOURCE]` (claim lacks URL), `[DECISION PENDING]` (design choice deferred).

**Per-file skeleton (headers; one-line purpose each):**
- **README.md** — see §4 (full Index Contract).
- **01-what-is-ddd.md** — `## Summary (TL;DR)` ≤10 bullets, the whole file in one screen · `## Defining DDD` working definition + why agents care · `## Disambiguation` document-driven vs domain-driven vs data-driven; adopt canonical terms · `## Origins & Lineage` timeline from design docs/PR-FAQ/Shape Up/ADR through AI-era llms.txt/AGENTS.md/festival files · `## Philosophy` writing-as-thinking, docs-as-contract, async review · `## DDD vs TDD/BDD/Domain-Driven Design` comparison table · `## Benefits` sourced list · `## Critiques & Failure Modes` sourced list · `## Working Pieces Inventory` cross-ref 02 · `## Sources`.
- **02-ddd-flow.md** — `## TL;DR` · `## Pipeline Overview` ASCII stage diagram · `## Stage 0 Context & Onboarding` (README index, AGENTS.md, llms.txt) · `## Stage 1 Doc-First Plan` (spec/plan/festival file) · `## Stage 2 Gate & Approval` · `## Stage 3 Implementation (doc-anchored)` · `## Stage 4 Verification` · `## Stage 5 Review & Sign-off` · `## Stage 6 Maintenance & Living Docs` · `## Artifact Map` stage → artifact → owner · `## Sources`.
- **03-best-practices.md** — `## TL;DR` · `## Doc Hygiene` density, single H1, status lines · `## Agent-Friendly Writing` cross-ref 07 · `## Process Practices` doc-in-same-commit, review-before-code · `## Pitfalls & Anti-Patterns` table · `## Metrics & Signals` table · `## Sources`.
- **04-templates-adr.md** — `## What Is an ADR` · `## When to Write / Not Write` · `## Nygard ADR Skeleton` indented block + usage note · `## MADR Skeleton` indented block + usage note · `## Comparison & Selection` · `## Sources`.
- **05-templates-issues.md** — `## GitHub Issue Anatomy` (YAML frontmatter + body) · `## Bug Report Skeleton` · `## Feature Request Skeleton` · `## Chore Skeleton` · `## Labels & Acceptance Criteria` · `## Sources`.
- **06-templates-roadmap-design-feature.md** — `## Roadmap Skeletons` (Now/Next/Later, outcome-based) · `## Design Doc / RFC Skeleton` (Google-style) · `## PRD / Feature Brief Skeleton` · `## Festival File Skeleton` (this repo's methodology) · `## When to Use Which` · `## Sources`.
- **07-agent-indexing.md** — `## TL;DR` · `## llms.txt` spec + example · `## AGENTS.md / per-agent dirs` · `## SKILL.md Frontmatter` contract + sample · `## README-as-Index` · `## File Organization & Numbering` · `## Token-Efficient Writing Style` · `## Search Strategy` keyword vs embeddings vs hybrid · `## Sources`.
- **08-skills-to-build.md** — `## TL;DR` · `## Skill Category Map` · `## Skill Specs` per category (name, purpose, trigger, inputs/outputs, SKILL.md skeleton) · `## Priorities & Sequencing` · `## Relationship to Research Library`.
- **09-flows-and-strategies.md** — `## TL;DR` · `## DDD Flow Spec` stages + gates · `## Gate Table` · `## Strategies` rule + enforcement each · `## Cadences` ADR cadence, index maintenance, quarterly prune · `## Metrics the Framework Should Track` · `## Open Design Questions`.
- **10-references.md** — `## How to Use` · `## Primary Sources` grouped by topic (URL, accessed date, one-line note) · `## Sources by Research File` cross-ref 01–07 · `## Unverified / Pending` (`[UNVERIFIED]` items with owner + next action).

## 4. Index Contract (README.md)

`docs/research/README.md` is the MANDATORY entry point. AGENTS.md dogfooding requires discoverability, and R4 (07-agent-indexing) will confirm this pattern; the contract below is fixed now so writers and reviewers have a stable target.

**Mandatory contents, in order:**
1. `# DDD Research Library — Index (READ THIS FIRST)` and a blockquote line: "Agents MUST read this file before opening any other file under docs/research/."
2. `## Purpose` — one paragraph: what the library is, who uses it, the token-budget philosophy.
3. `## File Map` — a table: `# | File | Purpose (one line) | Status | Size bound`. Every file in the directory MUST appear here; reviewer pre-flight checks this (orphan check).
4. `## Navigation Rules` — a table "If you need X → read Y": What is DDD? → 01 · Pipeline/flow → 02 · Best practices/pitfalls → 03 · ADR templates → 04 · Issue templates → 05 · Roadmap/design/feature templates → 06 · Agent indexing/token efficiency → 07 · Which skills will the framework ship? → 08 · Flow spec/strategies → 09 · Sources/URLs → 10.
5. `## Reading Order for New Agents` — ordered list: 01 → 02 → 03 → 07 → 09 → (04/05/06 on demand) → 08 → 10. Rationale: understand DDD, see the pipeline, learn hygiene, learn indexing, then specifics.
6. `## Status & Legend` — status values (draft/review/done) and markers (`[UNVERIFIED]`, `[NEEDS SOURCE]`, `[DECISION PENDING]`) with definitions.
7. `## Glossary` — ≤15 terms: DDD (document-driven), Domain-Driven Design, festival file, ADR, MADR, PRD, RFC, llms.txt, AGENTS.md, SKILL.md, README-as-index, token-efficient, doc rot, living docs, gate.
8. `## How to Extend This Library` — step-by-step: (a) pick the next free number, (b) create `NN-slug.md` per the header contract in §3, (c) add a row to `## File Map`, (d) add a `## Navigation Rules` row if it answers a new need, (e) respect the size bound or split, (f) never renumber or delete files, (g) run the pre-flight checks in §8 before marking `done`.

## 5. Skills-to-Create Scope (contents of `08-skills-to-build.md`)

This phase only writes the inventory doc. Each entry below is a SPEC for that doc's `## Skill Specs` section; the doc must also carry a SKILL.md skeleton sketch per skill (indented code block: `---` / `name:` / `description:` / `---` / `# Name` / `## When to use` / `## Inputs` / `## Steps` / `## Outputs` / `## Verification`).

| Category | Skill (name) | Purpose | Trigger | Inputs → Outputs |
|---|---|---|---|---|
| Flow orchestration | `ddd-plan` | Turn a request into a doc-first plan before any code | user asks to build/change something | request + context → plan doc |
| Flow orchestration | `ddd-run-flow` | Execute the pipeline stages with gates | user starts a plan | plan → gated execution log |
| Doc/plan writing | `ddd-adr` | Capture an architecture decision | a design choice is made | context + decision → ADR file |
| Doc/plan writing | `ddd-design-doc` | Produce a Google-style design doc | non-trivial feature | request → design doc |
| Doc/plan writing | `ddd-prd` / `ddd-festival-file` | Produce PRD or festival-file specs | feature/phase kickoff | request → PRD/festival file |
| Template application | `ddd-apply-template` | Scaffold a doc from a research skeleton | user names a template | template name + params → doc |
| Validation/review gates | `ddd-validate-docs` | Run pre-flight checks on the library | before merge/sign-off | docs → pass/fail report |
| Validation/review gates | `ddd-review-gate` | Reviewer checklist enforcement | before a phase ships | artifacts → sign-off |
| Index maintenance | `ddd-index` | Keep README index in sync | files added/renamed | file list → updated index |
| Installer | `ddd-install` | Install skills/docs/scripts/templates into a consumer repo | user installs framework | repo → installed framework |

`## Priorities & Sequencing` must rank: 1) index maintenance + validate-docs (protect the library), 2) ADR + design-doc + plan (core value), 3) template application, 4) flow orchestration, 5) installer (blocks on §10 OQ1/OQ2). `## Relationship to Research Library` must map each skill back to the research files that justify it (e.g., ddd-adr ← 04; ddd-index ← 07 + §4).

## 6. Flows & Strategies Scope (contents of `09-flows-and-strategies.md`)

**DDD flow spec** (stages, artifact, gate): 0 Context & Onboarding (README index + AGENTS.md; gate: agent can answer "where do I look?") · 1 Doc-First Plan (plan/spec/festival file; gate: plan exists, scope bounded, success defined) · 2 Approval (gate: plan reviewed and accepted before code) · 3 Implementation, doc-anchored (every change maps to a plan section) · 4 Verification (tests + doc-truth checks; gate: evidence exists) · 5 Review & Sign-off (reviewer checklist) · 6 Maintenance & Living Docs (ADR cadence, quarterly prune, index refresh).

**Gate table** (name, condition, owner): Gate 0 Indexed — README links all files; design-team-ia · Gate 1 Planned — plan doc with goals/non-goals; architect · Gate 2 Approved — reviewer sign-off on plan; reviewer · Gate 3 Verified — tests pass, docs updated in same change; coder · Gate 4 Signed-off — §8 checklist all pass; reviewer.

**Strategies to encode** (rule + enforcement): docs-lead/code-follow (no code until doc exists; gate 1) · test-after-doc (doc defines acceptance criteria; gate 3) · change-in-same-commit (behavior change ships with its doc update; gate 3) · one-doc-one-concern (split files over 400 lines; gate 4) · index-maintenance cadence (README updated in the same change that adds a file; gate 4) · token-budget budgeting (context-load cost tracked per file; gate 0/4) · verify-first (evidence over prose; gate 3).

**Cadences:** ADR written at decision time and referenced by the code it explains; index refresh on any add/rename; quarterly prune of stale docs flagged in README status.

**Metrics the framework should track (validated in a later phase):** time-to-first-plan, rework rate (changes rejected at gates), docs-to-code ratio, average tokens to load a task's context, orphan-file count.

## 7. Agent Delegation Map

| Task | Agent role | Label | Depends on | Runs in parallel with |
|---|---|---|---|---|
| Author festival file (this doc) | architect | `[architect:festival]` | — | — (done) |
| Write plan file + README skeleton | coder | `[coder:scaffold]` | `[architect:festival]` | — |
| R1 research → 01 draft content | general/researcher | `[researcher:r1]` | `[coder:scaffold]` | R2, R3, R4, IA review |
| R2 research → 02 + 03 draft content | general/researcher | `[researcher:r2]` | `[coder:scaffold]` | R1, R3, R4, IA review |
| R3 research → 04 + 05 + 06 draft content | general/researcher | `[researcher:r3]` | `[coder:scaffold]` | R1, R2, R4, IA review |
| R4 research → 07 draft content | general/researcher | `[researcher:r4]` | `[coder:scaffold]` | R1, R2, R3, IA review |
| Validate IA: naming, numbering, README contract | design-team-ia | `[design-team-ia:ia-review]` | `[coder:scaffold]` | all research lanes |
| Synthesize skills scope → 08 | architect | `[architect:skills-scope]` | R1–R4 complete | architect:flows-scope |
| Synthesize flows/strategies → 09 | architect | `[architect:flows-scope]` | R1–R4 complete | architect:skills-scope |
| Materialize research files + finalize README statuses | coder | `[coder:finalize]` | all lanes complete | — |
| Pre-flight checks + sign-off | reviewer | `[reviewer:gate]` | `[coder:finalize]` | — |

**Quality-gate sequencing:** 1. `[architect:festival]` → 2. `[coder:scaffold]` → 3. four research lanes + `[design-team-ia:ia-review]` in parallel → 4. `[architect:skills-scope]` and `[architect:flows-scope]` in parallel → 5. `[coder:finalize]` → 6. `[reviewer:gate]` → 7. orchestrator reports sign-off (or loops back to the failing lane). Only the four research lanes and the two architect lanes ever run in parallel; scaffold and finalize are serial.

## 8. Quality Gates & Verification

**Definition of done per file:** exists at exact path; H1 matches filename slug; `> **Status:**` line present; §3 section skeleton present; within size bound; research files 01–07 and 10 contain ≥3 inline URLs each; no `[UNVERIFIED]` without an owner note in `10-references.md`; listed in README `## File Map`.

**Reviewer criteria (each scored pass/fail with evidence):**
1. Accuracy vs user intent — content answers the brief's key questions; no drift into application-building or consumer-code advice.
2. Citation honesty — every URL is real and reachable; no invented citations; unverifiable claims are `[UNVERIFIED]` or `[NEEDS SOURCE]`.
3. Token-efficiency — within size bound; no filler paragraphs, no repeated definitions that belong in the README glossary.
4. Formatting/parseability — valid markdown; no triple-backtick fences inside template skeletons (must be 4-space indented so they survive paste); consistent headers.
5. Discoverability — file linked from README; cross-links resolve; nav rules cover it.

**Pre-flight checks (manual, run by reviewer before sign-off; documented for a future validate.sh):**
- File existence: `dir /b "docs\research" "docs\plans"` (Windows) or `ls docs/research docs/plans` — expect 11 + 1 files.
- H1 audit: grep for `^# ` across `docs/research/*.md` — exactly one H1 per file, matching slug.
- Cross-link audit: extract all `](./` and `../research/` links and verify targets exist; report any broken link.
- Size audit: count lines per file (PowerShell `(Get-Content <file>).Count` or `wc -l`) against §3 bounds.
- Tag audit: grep for `[UNVERIFIED]` and `[NEEDS SOURCE]`; every match must have a `10-references.md` owner entry.
- Anti-rubber-stamp: reviewer must re-open 2 files at random and verify one claim each against its URL.

**Sign-off rule:** zero FAIL items → `done` statuses in README; any FAIL blocks the phase and routes back to the owning lane with the failed checklist item.

## 9. Risks & Mitigations

| # | Risk | L/I | Mitigation |
|---|---|---|---|
| 1 | Scope creep into app scaffolding or consumer-code advice | H/H | Anti-goals #1/#5; reviewer criterion 1; every file skeleton fixes scope |
| 2 | Researchers invent or misremember citations | H/H | Citation-honesty gate; `[UNVERIFIED]` markers; pre-flight URL check; 10-references audit |
| 3 | Token bloat per file | H/M | Hard size bounds; overflow rule (split to new numbered file); size audit at pre-flight |
| 4 | Windows path issues (spaces in "Document Driven Development") | M/H | Every shell command in this plan quotes paths; pre-flight commands provided with quotes; no script run in this phase |
| 5 | Agent drift from AGENTS.md invariants | M/H | Each lane re-reads AGENTS.md at task start; reviewer criterion 1; anti-goal #7 (no AGENTS.md edit) |
| 6 | Orphan files not linked in index | M/M | README file-map contract; `[coder:finalize]` updates README; pre-flight link audit |
| 7 | Plan-vs-execution drift | M/M | Festival file is a living doc; every structural change logged in §10; reviewer checks plan adherence |
| 8 | Reviewer rubber-stamping | M/M | Evidence-based checklist; random spot-check of 2 files per gate; zero-FAIL rule |
| 9 | DDD ambiguity (document-driven vs domain-driven) | M/H | R1 disambiguation section; README glossary; reviewers check terminology consistency |
| 10 | Parallel lanes collide on shared content (glossary, sources) | M/M | Lanes own disjoint files; glossary lives only in README (single writer); 10-references written by `[coder:finalize]` from lane-supplied URL lists |

## 10. Decisions Log & Open Questions

**Decisions (logged):**

| # | Decision | Rationale | Downstream impact |
|---|---|---|---|
| D1 | Fixed numbering 01–10, never renumber | Stable links; cheap glob searches; predictable navigation | New files append at next free number; renames forbidden |
| D2 | README.md is the mandatory index with the §4 contract | Discoverability invariant; single entry point for agents | Every future phase must update README in the same change that adds docs |
| D3 | R2 splits into 02+03; R3 splits into 04+05+06 | Token efficiency: readers load only the family they need | Nav rules and size bounds adjusted accordingly |
| D4 | Research files use a `> **Status:**` line, no YAML frontmatter | Plain-markdown invariant; parseable by any agent | Status lives in-file and in README table (dual-source, reconciled at finalize) |
| D5 | Per-file size bounds enforced at pre-flight | Token-budget philosophy; guards against bloat | Files exceeding bounds must split; bounds auditable by script later |
| D6 | Skills (08) and flows (09) are scoped, not authored, this phase | Research-first dogfooding; no SKILL.md without its own doc | Build phase takes 08/09 as the source of truth for skill specs |
| D7 | AGENTS.md is not modified this phase | Layout unchanged; invariant #3 untouched | If IA later warrants layout changes, a separate ADR precedes the AGENTS.md edit |
| D8 | URLs inline in research files AND consolidated in 10-references | Findability at point of claim + single audit list | 10-references written at finalize from lane-supplied lists; no duplicate authorship |

**Open questions:**

| # | Question | Blocks | Trigger to resolve |
|---|---|---|---|
| OQ1 | Installer mechanics: POSIX `install.sh` only, or also a PowerShell variant? Symlink vs copy per artifact type? | `ddd-install` skill, `scripts/` layout | Start of build phase; user decision; AGENTS.md notes win32 dev |
| OQ2 | Which agent ecosystems get first-class support (OpenCode first, then Claude Code, etc.)? | Skill descriptions/triggers, per-agent dirs in installer | After R4 completes (07-agent-indexing) |
| OQ3 | Framework name/brand (repo is currently "Document Driven Development" — is that final?) | Root README, installer messaging | User decision at build-phase kickoff |
| OQ4 | Should the framework generate `llms.txt` in consumer repos? | Index-maintenance skill scope | After R4; depends on llms.txt findings in 07 |

**Execution note for the orchestrator:** dispatch per §7 labels; run research lanes and architect lanes in parallel; loop back on any reviewer FAIL; log every deviation from this plan in the table above before proceeding.

**Gate log (reviewer gate sign-off):**

**Gate sign-off** — `[reviewer:gate]` run on 2026-08-14: **8/8 checks PASS** (file existence, H1/header audit, size audit, fence audit, cross-link audit, tag audit, §1 KPIs incl. ≥60% inline sourcing at ~85–90% actual, anti-rubber-stamp spot-checks on 02 + 05). Research library statuses stay `done`.

| # | Decision | Rationale | Downstream impact |
|---|---|---|---|
| D-GATE-1 | Plan-vs-execution divergence: delivered README File Map uses the 4-column `# | File | Purpose (what + when) | Size bound` form with NO Status column | §4 originally specified a `Status` column; status is single-source in-file (`> **Status:**` line per file, README:52 documents this) — the delivered form supersedes the plan text | Approved divergence; §4 Index Contract reads the 4-column form going forward |
| D-GATE-2 | README line 2 is the §4-mandated blockquote directive, not a `> **Status:**` line | §4 index contract supersedes §3 research-file header contract for the README; the README is the index, not a research file | No change required; §3 header contract applies to numbered research files 01–10 only |

| # | Note | Detail | Action |
|---|---|---|---|
| N-GATE-1 | 01-what-is-ddd Purpose sits at the ≤50-word boundary (≈49 readable words) | Within bound | No action |
| N-GATE-2 | Citation honesty: one unreachable URL (Blacklane, 403) kept in-place as `[UNVERIFIED]` with owner + re-fetch action in 10-references | Not silently asserted per §8 citation-honesty gate | No action; tracked in 10-references pending register |
