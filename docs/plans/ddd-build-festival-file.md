# DDD Build Phase — Festival File

> **Target path:** `docs/plans/ddd-build-festival-file.md`
> **Status:** Living blueprint — edit in place; every change logged in §10.
> **Phase output:** the framework's distributable v1 — 10 skills under `skills/`, the POSIX-sh installer under `scripts/`, 8 templates under `templates/`, install docs + 2 ADRs under `docs/`, and this plan. Zero new harness, zero runtime deps, zero AGENTS.md drift.

## 1. Build Charter & KPIs

**Phase goal.** Materialize the framework artifacts scoped by the research phase: author the 10 fixed skills (`08-skills-to-build.md`), the installer `scripts/install.sh`, the template set, and the build-phase docs — in the festival-mandated authoring rank, each batch verified before the next starts. All artifacts honor `AGENTS.md` invariants: plain Markdown, portable `SKILL.md` format, POSIX-sh tooling, install-into-project only.

**Persona.** A consuming agent (OpenCode, Claude Code, generic .agents) and a developer who runs `install.sh` in an arbitrary repo. Skills must route on `description` alone and execute without clarifying questions; the installer must be safe (no clobber) and repeatable.

**Mission for this phase (one sentence).** Build and verify the framework's v1 distributable — 10 portable skills, a dependency-free installer, 8 templates, and install docs — with every artifact discoverable, size-bounded, and gate-signed.

**Primary success KPI (falsifiable).** All 10 skill folders exist at exact paths and pass the §4 format contract (name==folder, regex-valid, single-line description ≤1024 chars, body <500 lines, required sections); all 8 templates exist and pass the render smoke test (zero unresolved `{{ }}`); `install.sh` passes the full scratch-repo semantics test (dry-run → install → idempotent re-run → no-clobber → uninstall); every built artifact is discoverable from a doc/manifest; zero fences violations; zero broken internal links; all 5 batch gates + the final gate pass with zero FAIL (§10 log).

**KPI table (each scored pass/fail with evidence at the owning gate):**

| # | KPI | Measure | Gate |
|---|---|---|---|
| K1 | Skill format contract | 10/10 SKILL.md: frontmatter `name`==folder + `^[a-z0-9]+(-[a-z0-9]+)*$`; single-line `description` ≤1024 chars; body <500 lines; sections `## When to use`, `## Inputs`, `## Verification` present | each batch gate |
| K2 | Skill-validator gate | 10/10 skills pass the §6 manual validator with zero FAIL | batch gates A–E |
| K3 | Template completeness + render | 8/8 templates exist; `templates/catalog.md` lists them 1:1; each renders with sample params leaving zero `{{ }}` | gates B, C, D |
| K4 | Installer end-to-end | On a scratch consumer repo in a temp dir (POSIX shell available on the dev host): dry-run lists actions; install creates every manifest path; re-run = zero changes; pre-existing conflicting file untouched without `--yes`/`--force`; uninstall removes installed paths and no pre-existing files | gate E |
| K5 | Discoverability | Every skill listed in `docs/research/08-skills-to-build.md`; every template in `templates/catalog.md`; `scripts/install.sh` + ADRs + `docs/install.md` referenced from root `README.md` | final gate |
| K6 | Zero fences violations | `grep -rn '^```' skills templates scripts docs` (build-authored files) returns zero | every gate |
| K7 | Zero broken links / orphans | All `./` and `../` links in build-authored files resolve; every build-authored file is reachable from a manifest/doc | every gate |
| K8 | Size bounds | Every build-authored file ≤ its §3 bound (`wc -l`) | every gate |
| K9 | Gate discipline | All 5 batch gates + final gate signed with zero FAIL, logged in §10 | final gate |
| K10 | Invariants intact | Distribution `AGENTS.md` unchanged; no `package.json`, no runtime deps, no global install path | final gate |

**Anti-goals (this phase explicitly does NOT):**
1. Ship `validate.sh` or any automation beyond `install.sh` (X3 — build verification is manual per §6/§8; validate.sh's checks are documented as the future script's spec).
2. Generate or ship `llms.txt` for consumer repos (X1 — deferred from research; noted, not built).
3. Split `docs/research/` into subdirectories (X2 — deferred until the 21st research file).
4. Run a tree-test with consumers (X4 — deferred until 3+ consumer installs).
5. Build a keyword search layer or embeddings (X5 — deferred; research verdict: grep + curated index).
6. Author a PowerShell `install.ps1` (deferred as future work; `docs/install.md` documents Windows as unsupported in v1).
7. Create per-ecosystem skill variants, agent-specific proprietary formats, or any `package.json`/runtime in this repo or consumer repos.
8. Modify `AGENTS.md`, any `docs/research/*` file, or the research festival file; no renumbering or deletions.
9. Write to any real consumer repo — install testing happens only on scratch repos under temp dirs.
10. Introduce triple-backtick fences anywhere in built artifacts or this plan (zero-fence rule, 4-space indented blocks only).

## 2. Context & Scope

**Build phase covers.** Authoring and verifying the v1 distributable, driven by the fixed research outputs: `08-skills-to-build.md` (skill specs + authoring rank), `09-flows-and-strategies.md` (flow stages/gates the skills must support), `07-agent-indexing.md` (format caps: description ≤1024 chars / ≤1536 with `when_to_use`, SKILL.md body <500 lines, references one level deep), `04/06` (template skeletons), `10-references.md` (canonical bibliography, incl. local skills at `~/.agents/skills/festival-creator/SKILL.md` and `~/.agents/skills/agent-impdoc/SKILL.md`).

**Fixed constraints (from research; do not re-litigate).** Authoring rank = 1) index + validation (`ddd-index`, `ddd-validate-docs`), 2) ADR/design-doc/plan (`ddd-adr`, `ddd-design-doc`, `ddd-plan`), 3) template application (`ddd-apply-template`, `ddd-festival-file`; `ddd-prd` = trigger alias), 4) flow orchestration (`ddd-run-flow`, `ddd-review-gate`), 5) installer (`ddd-install`). One portable `SKILL.md` per skill; canonical name `ddd-festival-file`; default install targets `.opencode/`, `.claude/`, `.agents/`, `.cursor/` as applicable.

**Scope exclusions (re-listed from research, fixed).** X1 llms.txt mirror in consumer repos · X2 subdirectory split at the 21st research file · X3 `validate.sh` enhancements (link/status checks — the script itself is deferred; this build's §6/§8 document the check spec) · X4 tree-test after 3+ consumers · X5 keyword search layer.

## 3. Target Tree & Size Bounds

**Target tree (exact paths; only these build-authored files are created this phase):**

    <repo root>/
      README.md                            # root README, minimal (≤60 lines) — Batch E
      install.sh                           # POSIX shim → scripts/install.sh (≤30) — Batch E
      AGENTS.md                            # existing — UNTOUCHED
      skills/                              # 10 folders; each owns SKILL.md (<500 lines)
        ddd-plan/SKILL.md                  # Batch B
        ddd-run-flow/SKILL.md              # Batch D
        ddd-adr/SKILL.md                   # Batch B
        ddd-design-doc/SKILL.md            # Batch B
        ddd-festival-file/SKILL.md         # Batch C
        ddd-apply-template/SKILL.md        # Batch C
        ddd-validate-docs/SKILL.md         # Batch A
        ddd-review-gate/SKILL.md           # Batch D
        ddd-index/SKILL.md                 # Batch A
        ddd-install/SKILL.md               # Batch E
      scripts/
        install.sh                         # authoritative POSIX-sh installer (≤400) — Batch E
        # validate.sh: NOT in this build (X3 deferral); its check spec is §6/§8
      templates/                           # 8 files; copies on install; catalog is the manifest
        catalog.md                         # template manifest (≤120) — Batch C
        adr.md                             # ADR skeleton (≤80) — Batch B
        design-doc.md                      # Google-style design doc (≤100) — Batch B
        plan.md                            # doc-first plan (≤100) — Batch B
        festival.md                        # festival-file skeleton (≤150) — Batch C
        prd.md                             # PRD skeleton (≤100) — Batch C
        index.md                           # README-as-index skeleton (≤80) — Batch A
        flow.md                            # flow doc skeleton (≤100) — Batch D
      docs/
        install.md                         # install README; Windows-unsupported note (≤200) — Batch E
        adr/
          0001-installer-mechanics.md      # OQ1 resolution (≤80) — Batch B
          0002-skill-authoring-contract.md # OQ2/OQ3 + format contract (≤80) — Batch B
        plans/
          ddd-build-festival-file.md       # THIS plan (≤600 lines)
          ddd-research-festival-file.md    # existing — UNTOUCHED
        research/                          # existing 11 files — UNTOUCHED

**Template roster (file → purpose):** `adr.md` — one-decision record with proposed/accepted/superseded lifecycle (from 04) · `design-doc.md` — context, goals/non-goals, options, trade-offs, decision, risks (from 06) · `plan.md` — goals, non-goals, success, acceptance criteria, phase list with per-phase doc→code→gate ordering (from 02/09) · `festival.md` — execution-grade brief: header, scope restrictions, technical/security constraints, atomic tasks with runnable success metrics + build/verify gates, acceptance criteria (from 06 + local festival-creator) · `prd.md` — product-intent mode: problem, audience, goals/non-goals, imperative requirements, success metrics (from 06) · `index.md` — README-as-index: H1, blockquote directive, file-map table, nav rules, glossary (from 07) · `flow.md` — stage map 0–6 with per-stage artifacts/gates + gate table (from 02/09) · `catalog.md` — master template manifest (template → file → target path → required params → used-by skill). `plan.md` and `catalog.md` are added beyond the six task-named types because `08` Priority 2/3 mandates them (`ddd-plan` input contract; `ddd-apply-template` catalog).

**Size-bound table (enforced at every gate, K8):**

| Artifact type | Bound |
|---|---|
| SKILL.md body | <500 lines (target <250) |
| scripts/install.sh | ≤400 lines |
| root install.sh shim | ≤30 lines |
| root README.md | ≤60 lines |
| docs/install.md | ≤200 lines |
| docs/adr/*.md | ≤80 lines |
| templates/catalog.md | ≤120 lines |
| each other template | ≤150 lines |
| this plan | ≤600 lines |

**Naming / numbering conventions.** Skills: folder + `name` kebab-case (`^[a-z0-9]+(-[a-z0-9]+)*$`). Templates: `<artifact>.md`. ADRs: `NNNN-slug.md`, 4-digit monotonic from 0001, never renumbered. Plan/design/spec consumer docs: kebab slugs. All new artifact names: lowercase kebab, no spaces. Every build-authored path is relative to repo root; all shell references quote paths (repo path contains spaces).

## 4. Artifact Contracts

### 4.1 SKILL.md contract (all 10 skills)

- **Frontmatter (YAML between two `---` lines):** `name:` exactly the folder name; `description:` on ONE physical line, ≤1024 characters, phrased "what + when to use + triggers" so an agent routes on relevance alone (K1 measure is `line length − len("description: ")`). Optional `when_to_use:` only if needed; combined description+when_to_use must stay ≤1536 chars. No other frontmatter fields. v1 uses only `name` + `description` (D-BLD-7).
- **Body:** exactly one H1 (display name per 08 skeletons, e.g. `# Document-Driven Plan`); REQUIRED sections in order `## When to use`, `## Inputs`, `## Verification`; middle sections per 08 spec (`## Steps` / `## Flow` / `## Checks` / `## Rules` as the skill demands). Imperative voice; every step ends with a runnable check; no prose-only "hope it works" steps; no triple-backtick fences (code blocks 4-space indented); references to shared artifacts by relative path (`templates/<name>.md`, `docs/research/08-skills-to-build.md`); no environment-specific absolute paths; no secrets.
- **Reference depth:** zero per-skill `references/` dirs in v1 (D-BLD-6) — all shared material lives in `templates/*`, which the installer copies into the consumer repo; "references one level deep" remains the cap and is trivially satisfied.

Example of the required shape (abridged; full text lives in each skill):

    ---
    name: ddd-plan
    description: Plan features and changes document-first, before any code. Use when
      the user asks to build, change, add, refactor, or implement something and a plan
      must sequence doc changes ahead of code with per-phase gates and a definition of
      done. Triggers: build, change, add, refactor, implement, plan first.
    ---
    # Document-Driven Plan
    ## When to use
    - Any request that will change behavior, docs, or both. Not for read-only Q&A.
    ## Inputs
    1. AGENTS.md and repo README index (conventions, invariants)
    2. Doc index (related docs; ddd-index contract)
    3. Affected files + git state
    ## Steps
    - ... (per skill; every step ends in a runnable check)
    ## Rules
    - Docs before code, in the SAME change; plan < 150 lines; never renumber phases.
    ## Verification
    - Plan exists at docs/plans/<slug>.md; every phase maps to doc+code work and a
      gate; no code was modified during planning.

### 4.2 Template contract

- Filename == artifact slug. Exactly one H1 (`# {Title}`). Placeholders `{{param}}` (double-brace) for slug/date/status/title. A short `<!-- when to use -->` HTML comment near the top. Sections exactly per the research skeleton it instantiates. Example blocks 4-space indented (no fences). Templates are immutable at runtime: `ddd-apply-template` fills placeholders into a NEW file and never edits the template (verifiable by unchanged `mtime`).
- `catalog.md` contract: H1 + one table — `Template | File | Target path pattern | Required params | Used by` — covering all 8 templates 1:1. It is the discoverability home for templates (K5).

### 4.3 Installer behavior contract (`scripts/install.sh`)

- **Language/scope:** POSIX-sh only (no bashisms), no deps beyond POSIX tools (`ln`, `cp`, `mkdir`, `rm`, `sed`, `grep`, `cat`, `test`). Every path quoted. Handles repo paths with spaces.
- **Flags:** `--help` · `--dry-run` (print the full action manifest, execute nothing) · `--yes` (auto-confirm all prompts) · `--force` (overwrite pre-existing files without prompting — explicit opt-in) · `--uninstall` · `--target <dir>` (consumer root; default current dir) · `--dist <dir>` (distribution root; default: repo containing the script).
- **Symlink/copy matrix (fixed per AGENTS.md):**

    | Artifact | Action | Rationale |
    |---|---|---|
    | skills/ (10 folders) | symlink into detected agent skill dirs | live updates across installs |
    | templates/ (8 files) | copy to consumer `templates/` | templates are scaffolding, must be stable copies |
    | scripts/install.sh | copy to consumer `scripts/install.sh` | self-installed uninstall/repair entrypoint |
    | docs note + manifest | appended/written | see below |

- **Agent dirs (OQ2):** detect which of `.opencode/skills`, `.claude/skills`, `.agents/skills`, `.cursor/skills` exist (or create the first-class three when the parent agent dir exists); `.cursor/` is installed only when already present. Missing agent dirs are skipped and listed in the manifest.
- **Idempotency:** second run produces zero changes — existing symlink to the same distribution target = no-op; identical file content = no-op; differing content = prompt (or `--force`).
- **No-clobber:** never modify or delete a pre-existing consumer file without explicit confirmation; `--yes` counts as confirmation; `--force` skips the prompt for overwrite-only actions.
- **Manifest:** the installer writes `.ddd/manifest.txt` listing every path it created and the README-note marker, so `--uninstall` removes exactly those paths and never pre-existing files.
- **Windows:** on MSYS/MINGW/CYGWIN, if `ln -s` fails, fall back to a copy WITH a warning (no silent fallback, D-BLD-8). On non-POSIX shells (PowerShell/cmd), exit non-zero with a pointer to `docs/install.md` (Windows documented as unsupported in v1, D-BLD-1).
- **README note:** append a short install note to the consumer README only after confirmation, marking it so uninstall can remove it.

### 4.4 Naming & doc conventions

Kebab-case everywhere; ADRs monotonic `NNNN-`; plan docs `docs/plans/<slug>.md`; consumer per-agent dirs per 4.3. Build-authored docs use `> **Status:** draft | review | done` lines and `[UNVERIFIED]`/`[NEEDS SOURCE]` markers only when a claim lacks a source (expected: zero in build artifacts — every claim traces to `docs/research/*`).

## 5. Build Sequence (5 Batched Increments)

Serial chain A→B→C→D→E (each batch's gate must PASS before the next starts). Within a batch the coder authors files in any order.

**Batch A — Index & validation foundation (rank 1).**
- Deliverables: `skills/ddd-index/SKILL.md`, `skills/ddd-validate-docs/SKILL.md`, `templates/index.md`.
- Verification: §4 skill contract on both skills; index.md renders with sample params (zero `{{ }}`); all links resolve.
- Gate: `[reviewer:gate-batch-a]`.

**Batch B — Doc-writing core (rank 2).**
- Deliverables: `skills/ddd-adr/SKILL.md`, `skills/ddd-design-doc/SKILL.md`, `skills/ddd-plan/SKILL.md`, `templates/adr.md`, `templates/design-doc.md`, `templates/plan.md`, plus dogfooding ADRs `docs/adr/0001-installer-mechanics.md` and `docs/adr/0002-skill-authoring-contract.md` (materialized from `adr.md` + §10 resolutions; architect drafts content, coder materializes).
- Verification: template render smoke tests; ADRs pass the ADR pattern (required sections, valid status, unique monotonic numbers, index/supersession fields where applicable); skill contract.
- Gate: `[reviewer:gate-batch-b]`.

**Batch C — Template application & festival-file (rank 3).**
- Deliverables: `skills/ddd-apply-template/SKILL.md`, `skills/ddd-festival-file/SKILL.md`, `templates/festival.md`, `templates/prd.md`, `templates/catalog.md` (completed now that the template set is full).
- Verification: catalog lists all 8 templates 1:1 with the tree (orphan check for templates); festival.md + prd.md render smoke tests; apply-template's catalog-consumption path is coherent with catalog.md; skill contract.
- Gate: `[reviewer:gate-batch-c]`.

**Batch D — Flow orchestration & review gates (rank 4).**
- Deliverables: `skills/ddd-run-flow/SKILL.md`, `skills/ddd-review-gate/SKILL.md`, `templates/flow.md`.
- Verification: flow.md render smoke test; run-flow/review-gate bodies match 09's stages/gates (contiguous pass chain, blockers stop flow); review-gate embeds per-artifact checklists in-body (realizes 09's `templates/review-checklist.md` without a 9th template — D-BLD-13); skill contract.
- Gate: `[reviewer:gate-batch-d]`.

**Batch E — Installer & packaging (rank 5).**
- Deliverables: `skills/ddd-install/SKILL.md`, `scripts/install.sh`, root `install.sh` shim, `docs/install.md`, root `README.md`.
- Verification: full §6 installer semantics test on a scratch consumer repo; `docs/install.md` documents flags, Windows-unsupported note, symlink/copy matrix, uninstall; root README links to `docs/install.md`, `docs/research/README.md`, `docs/adr/`; K5/K7 checks.
- Gate: `[reviewer:gate-batch-e]`.

**Finalization:** `[coder:finalize]` runs the repo-wide KPI sweep (K1–K10) and `[reviewer:gate-final]` signs the whole library.

## 6. Validation Approach

No `validate.sh` ships this phase (X3). Verification is manual, repeatable, and documented as the future script's spec. Checks run at the owning batch gate; the final gate re-runs the repo-wide sweep.

- **Size audit (K8):** `wc -l <file>` per build-authored file against §3 bounds (PowerShell: `(Get-Content <file>).Count`).
- **Frontmatter/description audit (K1):** parse between the first two `---` lines; assert `name:` == folder and matches `^[a-z0-9]+(-[a-z0-9]+)*$`; count the `description:` line via `awk '/^description:/{print length($0)-length("description: ")}'` (single-line contract makes this exact); assert ≤1024. Body lines = file lines minus frontmatter.
- **Section audit (K1):** assert `## When to use`, `## Inputs`, `## Verification` present (`grep -E '^## (When to use|Inputs|Verification)'`).
- **Fence audit (K6):** `grep -rn '^```' skills templates scripts docs` → zero matches (K6 is the hard zero-fence rule).
- **Link audit (K7):** extract `](./` and `../` targets from build-authored md files; `test -f` each resolved target; report broken links. Orphan check: every build-authored file must be reachable from `docs/research/08` (skills), `templates/catalog.md` (templates), or `docs/install.md`/root `README.md` (scripts, ADRs, install docs).
- **Template render smoke test (K3):** for each template, substitute sample `{{slug}}`, `{{date}}`, `{{title}}` params into a scratch file, assert required sections present and `grep -c '{{'` = 0. Confirm template `mtime` unchanged.
- **Installer semantics test (K4)** — run on a POSIX shell available on the dev host (Git Bash or WSL; macOS/Linux where available). Scripted scenario on `$(mktemp -d)`:
    1. `sh scripts/install.sh --target <scratch>/consumer --dry-run` → every action printed, nothing written.
    2. Real install → all manifest paths exist (skills symlinked, templates + install.sh copied, `.ddd/manifest.txt` written).
    3. Re-run → zero changes (idempotent).
    4. Pre-seed a conflicting consumer file → default run refuses without confirmation; `--yes` and `--force` paths behave as specified.
    5. `--uninstall` → installed paths removed, pre-existing files untouched.
    6. Broken-symlink-fallback path forced → copy-with-warning behavior observed.
    If no POSIX shell exists on the dev host, the gate FAILs with an explicit environment blocker (no silent waiver) and the test is run on the user's machine/CI before sign-off.
- **Anti-rubber-stamp:** reviewer re-opens 1–2 files per batch and re-runs one check independently.

## 7. Agent Delegation Map

| Label | Task | Role | Depends on | Runs in parallel with |
|---|---|---|---|---|
| `[architect:build-plan]` | Author this festival file (design + OQ resolutions) | architect | research phase done | — |
| `[coder:batch-a]` | Author ddd-index, ddd-validate-docs, templates/index.md | coder | `[architect:build-plan]` | — |
| `[reviewer:gate-batch-a]` | Run §8 checklist A + log | reviewer | `[coder:batch-a]` | — |
| `[coder:batch-b]` | Author ddd-adr/design-doc/plan + 3 templates + materialize ADRs 0001/0002 | coder | gate A | — |
| `[reviewer:gate-batch-b]` | Run §8 checklist B + log | reviewer | `[coder:batch-b]` | — |
| `[coder:batch-c]` | Author ddd-apply-template, ddd-festival-file + festival.md, prd.md, catalog.md | coder | gate B | — |
| `[reviewer:gate-batch-c]` | Run §8 checklist C + log | reviewer | `[coder:batch-c]` | — |
| `[coder:batch-d]` | Author ddd-run-flow, ddd-review-gate + flow.md | coder | gate C | — |
| `[reviewer:gate-batch-d]` | Run §8 checklist D + log | reviewer | `[coder:batch-d]` | — |
| `[coder:batch-e]` | Author ddd-install, scripts/install.sh, root shim, docs/install.md, root README | coder | gate D | — |
| `[reviewer:gate-batch-e]` | Run §8 checklist E (incl. K4 scratch test) + log | reviewer | `[coder:batch-e]` | — |
| `[coder:finalize]` | Repo-wide KPI sweep; fix any drift found | coder | gate E | — |
| `[reviewer:gate-final]` | Final zero-FAIL sign-off + log | reviewer | `[coder:finalize]` | — |

**Quality-gate sequencing.** Strictly serial: batches A→E; no two coder batches run in parallel (catalog/templates/installer build on prior outputs). Within a batch the coder authors files in any order. Any reviewer FAIL routes the batch back to its coder lane with the failed checklist item; re-gate until zero FAIL.

## 8. Review Gates & Sign-off Rule

**Definition of done per artifact:** exists at exact §3 path; meets its §4 contract; within its §3 size bound; no fences; linked from its manifest/index; discoverable per K5.

**Per-batch reviewer checklist (each item scored pass/fail with evidence; runs for the batch's files):**
1. **Frontmatter valid** — `name`==folder, regex, single-line description ≤1024 chars, no unknown required fields.
2. **Body contract** — <500 lines; H1 present exactly once; required sections present; imperative voice; every step ends in a runnable check.
3. **Fence audit** — zero triple-backtick sequences.
4. **Reference depth** — no per-skill `references/` dirs; shared refs point at `templates/*` (one level of indirection max).
5. **Link audit + orphans** — all internal links resolve; no unreferenced file.
6. **Discoverability** — skills listed in `08`; templates listed in `catalog.md`; scripts/ADRs/docs listed in `docs/install.md` or root README.
7. **Size audit** — every file within §3 bound.
8. **Spec fidelity** — content matches `08` skill specs / `09` flow spec / `04`+`06` skeletons without drift; same-change rule honored (index/catalog updated in the same change as the artifact).
9. **Template smoke render** (batches B/C/D) — zero `{{ }}` remaining; required sections present; template `mtime` unchanged.
10. **Installer semantics** (batch E) — K4 scratch-repo scenario passes on an available POSIX shell.
11. **Anti-rubber-stamp** — reviewer independently re-runs one check on 1–2 files.
12. **Plan-vs-execution** — no structural deviation unlogged; any deviation recorded in §10 before sign-off.

**Sign-off rule.** Zero FAIL → batch `done`, statuses updated, §10 gate log appended. Any FAIL blocks the phase and routes back to the owning lane with the failed item named. The final gate applies the same checklist repo-wide (K1–K10).

## 9. Dependencies & Risks

**Dependencies.** Inputs that must exist before each batch: `docs/research/08` (skill specs/rank), `09` (flow/gates), `07` (format caps), `04`/`06` (template skeletons), `10` + local skills (`festival-creator`, `agent-impdoc`) for festival-file format, `AGENTS.md` invariants. Batch E additionally depends on a POSIX shell (Git Bash/WSL) or an alternate POSIX host for the K4 test.

**Risks & mitigations:**

| # | Risk | L/I | Mitigation |
|---|---|---|---|
| 1 | SKILL.md format drift across agent products (1024 vs 1536 caps, folding) | M/M | Single-line description ≤1024 (stricter cap); contract in §4.1; validated at every gate (K1) |
| 2 | Windows dev host cannot execute POSIX-sh install.sh | H/H | K4 runs on Git Bash/WSL or user's POSIX host; environment blocker FAILs gate rather than waiving; `docs/install.md` documents Windows unsupported |
| 3 | Symlink permission failures on consumer repos | M/M | Copy fallback WITH warning (D-BLD-8); forced-fallback case tested in K4 scenario 6 |
| 4 | Installer edge cases (conflicts, partial installs, re-run, uninstall) | M/H | Idempotency + no-clobber contract; `.ddd/manifest.txt`; full scratch-repo scenario (K4) |
| 5 | Paths with spaces ("Document Driven Development") | M/H | Every shell command quotes paths; installer quotes everything; tested on the real repo path |
| 6 | Template placeholders leak into consumer docs | M/M | Render smoke tests; zero-`{{ }}` check (K3); apply-template dry-run before write |
| 7 | Orphan artifacts / discoverability drift | M/M | catalog.md + root README + §8 orphan/link audits; K5/K7 gates |
| 8 | Plan-vs-execution drift | M/M | Living plan; §10 log; reviewer criterion 12 |
| 9 | Skill body bloat past <500 lines | M/M | Hard bounds + size audit (K8); overflow rule: split content into `templates/*` not longer bodies |
| 10 | Agent-specific features creeping into portable skills | M/H | Authoring contract (portable SKILL.md only); criterion 8 spec fidelity; no per-ecosystem variants (anti-goal 7) |

## 10. Decisions Log & Open Questions

**Open-question resolutions (OQ1–OQ4).**

| # | Question | Resolution | Status |
|---|---|---|---|
| OQ1 | Installer mechanics | POSIX-sh `install.sh` primary; skills symlinked, templates + scripts copied; Windows documented as unsupported in `docs/install.md`; PowerShell variant deferred as future work | D-BLD-1 — **CONFIRMED by user 2026-08-15** |
| OQ2 | First-class agent dirs | Interactive agent-directory selection at install time (detect + prompt with detected defaults; `--yes` uses detected dirs; `.cursor/` only when present or chosen) | D-BLD-14 — **CONFIRMED by user 2026-08-15 (OQ2 with modification → D-BLD-14)** |
| OQ3 | Framework name | Keep "Document Driven Development (DDD)" for v1; rename is cosmetic and must not block the build | D-BLD-3 — **CONFIRMED by user 2026-08-15** |
| OQ4 | llms.txt in consumer repos | Stay deferred (research X1); noted here, not built | D-BLD-4 — no user action |

**Decisions (logged, dated 2026-08-15):**

| # | Decision | Rationale | Downstream impact |
|---|---|---|---|
| D-BLD-1 | POSIX-sh `install.sh` primary; Windows documented as unsupported; PowerShell deferred | AGENTS.md: macOS/Linux first, shell-first, no harness; keeps v1 surface minimal; dev-on-Windows ≠ consumer-on-Windows | `docs/install.md` Windows note; K4 POSIX-shell dependency |
| D-BLD-2 | `.opencode/` + `.claude/` + `.agents/` first-class; `.cursor/` if present | AGENTS.md "as applicable"; three dirs cover the documented v1 consumers | Installer detection matrix (§4.3) |
| D-BLD-3 | Keep "Document Driven Development (DDD)" for v1 | Rename is cosmetic; blocking the build on branding risks drift | No action now; rename later = root README + install.md wording |
| D-BLD-4 | llms.txt in consumer repos deferred (X1) | Research verdict: convention still drifting (v2 changes); not a v1 install artifact | Tracked as deferred build item |
| D-BLD-5 | Root `install.sh` shim → authoritative `scripts/install.sh` | AGENTS.md wants a root entrypoint AND `scripts/` holds the installer | Two real files; shim is `exec` only |
| D-BLD-6 | Skill folders ship SKILL.md only; shared material lives in `templates/*` | 07 dedup rule (point, don't copy); one source of truth for templates; installer copies templates into the consumer | No per-skill `references/` dirs in v1 |
| D-BLD-7 | Single-line `description` ≤1024 chars; no `when_to_use` required | Makes K1 mechanically checkable; satisfies the stricter OpenCode cap; one portable SKILL.md serves all agents | §4.1 authoring contract |
| D-BLD-8 | Symlink failure → copy WITH warning; non-POSIX shells exit with docs pointer | Never silent fallback (08 ddd-install spec); honest platform degradation | Installer Windows behavior |
| D-BLD-9 | Installer writes `.ddd/manifest.txt` for safe uninstall | Uninstall must never delete pre-existing files; manifest is the only safe mechanism | `--uninstall` contract (§4.3) |
| D-BLD-10 | v1 template set = 8 files; `catalog.md` is the template manifest | Task-specified 6 + `plan.md`/`catalog.md` required by 08; discoverability for templates | §3 tree; Batch C completion |
| D-BLD-11 | ADRs `docs/adr/0001` + `0002` materialized in Batch B (dogfooding `ddd-adr`) | AGENTS.md documents ADRs in `docs/`; 08 Priority 5 wants the platform decision in an ADR | Batch B deliverables; ADR pattern gate |
| D-BLD-12 | `validate.sh` not shipped this phase (X3); §6/§8 document its check spec | Research deferral; build verification stays manual and repeatable | Future increment authors validate.sh against §6 |
| D-BLD-13 | 09's `templates/review-checklist.md` realized inside `ddd-review-gate` body | Dedup: checklist is the skill's operating procedure; no 9th template needed | §3 template count stays 8 |
| D-BLD-14 | Agent-directory selection done interactively at install time: detect + prompt with detected defaults; `--yes` uses detected dirs (fallback `.opencode/` + `.claude/` + `.agents/`); `.cursor/` only when present or explicitly chosen | OQ2 ratified with modification 2026-08-15 — the fixed first-class matrix assumed consumer dirs; interactive detection matches reality and keeps `.cursor/` opt-in | Supersedes D-BLD-2's fixed-matrix wording; installer §4.3 prompt behavior + D-BLD-2 marked superseded by D-BLD-14 |

**Research-phase context (carried forward, unchanged):** D-GATE-1 — README File Map uses the 4-column form with no Status column (status single-source in-file) · D-GATE-2 — README line 2 is the index directive blockquote, not a `> **Status:**` line · N-GATE-1 — 01-what-is-ddd Purpose at the ≤50-word boundary, within bound · N-GATE-2 — one unreachable URL (Blacklane, 403) kept as `[UNVERIFIED]` with owner + re-fetch action in 10-references.

**Gate log (template for build-phase sign-offs).** Append one entry per gate; any divergence gets a `D-BLD-G-N` decision and any note a `N-BLD-N` entry:

    **Gate sign-off** — `[reviewer:gate-batch-X]` run on <date>: **N/M checks PASS**
    (<list failed items, or "none">). Files statused `done`: <paths>. KPI evidence:
    K1 <n/10>, K3 <n/8>, K4 <pass/fail + shell used>, K6/K7/K8 <pass>. Anti-rubber-stamp
    spot-checks on: <files>. Any divergence: D-BLD-G-N / N-BLD-N (below).

**Execution note for the orchestrator.** Dispatch per §7 labels in strict order A→E; never start a batch before its predecessor's gate log entry; loop back on any reviewer FAIL with the named item; log every deviation from this plan in §10 before proceeding; escalate the three PENDING USER CONFIRMATION decisions (OQ1–OQ3) to the user at batch-E kickoff so installer/README wording is final before packaging.

**Build-plan gate log:**

**Gate sign-off** — `[reviewer:gate-build-plan]` run on 2026-08-15: **8/8 checks PASS** (conventions; structure completeness; fidelity vs research outputs; internal consistency; KPI mechanical checkability; decision-log hygiene; anti-rubber-stamp; delegation-map sanity).

| # | Note | Detail | Action |
|---|---|---|---|
| N-BLD-1 | X4 provenance correction | "tree-test with consumers" does NOT trace to a research-phase deferral (X1, X2, X3, X5 do: research OQ4, research README:84, research-plan anti-goal 2, 07:140). Recorded as a build-phase scope exclusion (deferred until 3+ consumer installs) | §2 wording stands; no other edit |
| N-BLD-2 | Batch C sub-batching note | 08 Priority 2 groups ddd-festival-file with the rank-2 core, but the plan authors it in Batch C with ddd-apply-template + festival.md/prd.md/catalog.md | Internally consistent (co-authored with its templates and catalog); no change |
| N-BLD-3 | 08 Open Design Questions resolved implicitly | OQ1 (run-flow vs scripts/gate-check.sh): no gate-check.sh ships; run-flow orchestrates, review-gate performs checks. OQ3 (AGENTS.md update placement): installer appends a marked README note, not an AGENTS.md section | No change |

**Gate sign-off** — `[reviewer:gate-batch-a]` run on 2026-08-15: **10 PASS + 1 N/A** of 12 checklist items (item 10 installer semantics is batch E). Files statused `done`: `skills/ddd-index/SKILL.md`, `skills/ddd-validate-docs/SKILL.md`, `templates/index.md`. KPI evidence: K1 2/10, K3 1/8, K6/K7/K8 pass for batch files. Anti-rubber-stamp spot-checks on: `skills/ddd-index/SKILL.md` + `templates/index.md`.

| # | Note | Detail | Action |
|---|---|---|---|
| N-BLD-4 | ddd-index Verification snippet path parameterized | Verification comm/grep snippet hardcoded `docs/README.md` (does not exist in this repo; contradicted the skill's own Step 1 doc-dir detection). Reworded to operate on `<doc-dir>` / `<index-file>` detected in Step 1 | Minor robustness fix per gate-batch-a note; line count stays <500; zero fences |

**Gate sign-off** — `[reviewer:gate-batch-b]` run on 2026-08-15: **12/12 checklist items PASS (item 10 N/A)**. First gate FAIL on item 8 (spec fidelity — ADR status lines carried the template's raw lifecycle enumeration; single-brace template tokens violated §4.2 double-brace contract) → coder fixes → re-gate **SIGN-OFF ZERO FAIL**. Files statused `done`: `skills/ddd-adr/SKILL.md`, `skills/ddd-design-doc/SKILL.md`, `skills/ddd-plan/SKILL.md`, `templates/adr.md`, `templates/design-doc.md`, `templates/plan.md`, `docs/adr/0001-installer-mechanics.md`, `docs/adr/0002-skill-authoring-contract.md`. KPI evidence: K1 5/10, K3 3/8, K6/K7/K8 pass for batch files. Anti-rubber-stamp spot-checks on: `templates/adr.md` + `docs/adr/0001-installer-mechanics.md`.

| # | Note | Detail | Action |
|---|---|---|---|
| N-BLD-5 | templates/index.md H1 single-brace token conversion | `# {Title}` → `# {{title}}` — the single-brace fill-in token found during the gate-batch-b re-gate; converted to the §4.2 double-brace form for consistency with design-doc.md and plan.md H1s | Authorized consistency fix per gate-batch-b re-gate note; index.md line count stays ≤80; zero fences |

**Gate sign-off** — `[reviewer:gate-batch-c]` run on 2026-08-15: **12/12 checklist items PASS (item 10 N/A)**. Files statused `done`: `skills/ddd-apply-template/SKILL.md`, `skills/ddd-festival-file/SKILL.md`, `templates/festival.md`, `templates/prd.md`, `templates/catalog.md`. KPI evidence: K1 7/10, K3 7/8 (flow.md documented as the forward row), K6/K7/K8 pass for batch files. Anti-rubber-stamp spot-checks on: `skills/ddd-apply-template/SKILL.md` + `templates/catalog.md`.

| # | Note | Detail | Action |
|---|---|---|---|
| N-BLD-6 | catalog.md adr row precision | Required params `status` → `status (choose from lifecycle)` — templates/adr.md has no literal `{{status}}` placeholder; status is set by lifecycle selection (proposed/accepted/superseded) | Tweak applied per gate-batch-c note; catalog.md stays 23 lines ≤120 |

**Gate sign-off** — `[reviewer:gate-batch-d]` run on 2026-08-15: **12/12 checklist items PASS (item 10 N/A)**. Files statused `done`: `skills/ddd-run-flow/SKILL.md`, `skills/ddd-review-gate/SKILL.md`, `templates/flow.md`. KPI evidence: K1 9/10, K3 8/8 (template set complete; catalog 1:1), K6/K7/K8 pass for batch files. Anti-rubber-stamp spot-checks on: `skills/ddd-review-gate/SKILL.md` + `templates/flow.md`.

**OQ ratification record** (dated 2026-08-15): OQ1 ratified as recommended (D-BLD-1 confirmed) · OQ3 ratified (D-BLD-3 confirmed) · OQ2 ratified with modification → **D-BLD-14** (interactive agent-directory selection in install setup; detect + prompt with detected defaults; `--yes` uses detected dirs, fallback `.opencode/`/`.claude/`/`.agents/`; `.cursor/` only when present or explicitly chosen) supersedes D-BLD-2's fixed matrix wording. OQ table status cells updated accordingly.

**Gate sign-off** — `[reviewer:gate-batch-e]` run on 2026-08-15: **12/12 checklist items PASS (re-gate)**. First gate FAIL on item 10 (K4 installer semantics — two defects in `scripts/install.sh`: manifest rebuilt on every run without re-appending no-op entries, so `--uninstall` after a re-run left installed artifacts; `link_or_copy` fallback used `cp -f` on skill directories, so the symlink-fallback copy silently failed) → coder fixes → re-gate **SIGN-OFF ZERO FAIL**. Files statused `done`: `skills/ddd-install/SKILL.md`, `scripts/install.sh`, `install.sh`, `docs/install.md`, `README.md`. KPI evidence: K1 10/10, K3 8/8, K4 PASS (Git Bash; 25/25 assertions: dry-run writes nothing; install manifest = 31 entries incl. all skills/templates/installer; re-run keeps manifest complete and count-stable; uninstall after re-run leaves zero artifacts incl. copy-fallback dirs; no-clobber refusal + `--force` overwrite; symlink-fallback copies skill dirs WITH warning and manifest entries; copy-failure exits non-zero with visible ERROR), K6/K7/K8 pass for batch files. Anti-rubber-stamp spot-checks on: `scripts/install.sh` (raw-read fix hunks; `sh -n` exit 0) + Git Bash K4 execution.

| # | Note | Detail | Action |
|---|---|---|---|
| N-BLD-7 | Manifest rebuild / no-op re-append fix | plan_and_install rebuilds `.ddd/manifest.txt` each run; the four no-op branches (symlink-to-same-target, identical-copy dir, identical template, identical installer) now re-append installer-owned paths, so the manifest always lists every installed artifact after re-runs; conflicting foreign-file skip branches remain out of the manifest | Fixes gate-batch-e FAIL 1 — `--uninstall` after a re-run removes all installed artifacts |
| N-BLD-8 | link_or_copy fallback `cp -rf` + loud failure | Fallback used `cp -f` on skill directories (omitting dir → silent failure). Now `cp -rf`, plus `ERROR: copy failed for <label>` on stderr with non-zero return; `do_uninstall` gained an `elif [ -d ] → rm -rf` branch so copy-fallback directories are removable | Fixes gate-batch-e FAIL 2 and enables clean uninstall of copied skill dirs |

**Gate sign-off** — `[reviewer:gate-final]` run on 2026-08-15: **repo-wide sweep ZERO FAIL — phase complete**. All five batches + final KPI sweep signed. KPI evidence: K1 10/10 (name==folder + kebab regex; single-line description ≤1024 — measured 476–701 across the ten; body <500; one H1; required sections; zero fences); K2 PASS (ddd-validate-docs 8-rule spec matches §6; all skills passed per-batch validator gates); K3 8/8 (templates exist; catalog.md 1:1 with templates/ tree; sample render zero `{{` / zero single-brace); K4 PASS (Git Bash: dry-run writes nothing; install manifest 31 entries; re-run keeps manifest complete and stable; uninstall after re-run leaves zero artifacts incl. copy-fallback dirs; no-clobber refusal + `--force` overwrite; symlink-fallback copies skill dirs WITH warning + manifest entries; copy-failure exits non-zero with visible ERROR); K5 PASS (10/10 skills listed in docs/research/08; all templates catalogged; installer/ADRs/install.md linked from root README + docs/install.md); K6 PASS (zero fence lines in build-scope skills/templates/scripts/docs; only pre-existing fences remain in out-of-scope AGENTS.md + research plan); K7 PASS (README/install.md links resolve; internal refs resolve; no orphan build files); K8 PASS (plan 360 ≤600, install.sh 229 ≤400, shim 16 ≤30, README 40 ≤60, install.md 94 ≤200, ADRs 44/47 ≤80, skills 40–63 <500, templates 23–93 ≤150); K9 PASS (six gate sign-offs + two re-gates logged: build-plan, batch-a, batch-b+re-gate, batch-c, batch-d, batch-e+re-gate; N-BLD-1..8 present); K10 PASS (AGENTS.md 41 lines byte-unchanged; no package.json/node_modules/global install; distribution-repo-only layout). Deferred: X1 llms.txt mirror · X2 research subdir split at the 21st research file · X3 validate.sh · X4 tree-test after 3+ consumer installs · X5 keyword search layer. Anti-rubber-stamp: raw reads across all artifact classes; fresh mechanical sweep; `sh -n` exit 0; AGENTS.md byte-compare; 10/10 desc-length re-measure; template render + catalog 1:1; D-BLD-14 consistency across plan/ADR 0002/skill/script/docs.

| # | Note | Detail | Action |
|---|---|---|---|
| N-BLD-9 | gate-final residual notes | Accuracy correction: repo-wide fence lines are exactly FOUR across TWO pre-existing out-of-scope files (AGENTS.md lines 22/27 repository-layout block; research-plan lines 61/77 target-tree block) — K6 build-scope zero-fence unaffected. `.serena/` at repo root is environment tool metadata, not a build artifact | Logged for accuracy at gate-final |

| D-BLD-15 | Code-comment indexing conventions | New capability: skills/ddd-comments tag vocabulary (DDD:, TODO:, FIXME:, HACK:, HACK-REF: with owner, DDD-DOC: breadcrumbs), anti-rot rule (comments link docs, never restate), templates/comments.md per-repo register, ddd-validate-docs check 9 (comment link/tag audit), DDD-DOC: hooks in ddd-festival-file + ddd-design-doc. No installer changes (glob coverage) | User-approved follow-up to gate-final; ADR 0003 proposed -> accepted at gate |
| N-BLD-10 | ddd-comments discoverability home deviation | New skill is referenced from README, docs/install.md, ADR 0003, and the plan §10 because docs/research/08 is frozen (research library lock); K5 home documented as moved | Documented deviation per architect note |

**Gate sign-off** — `[reviewer:gate-code-comment-indexing]` run on 2026-08-15: **12/12 checklist items PASS (re-gate)**. First gate FAIL on item 8 (ddd-comments Verification grep #1 false-flagged every well-formed owned+linked tag and every DDD: module header because its exclusion matched the literal placeholder `owner [docs/`) → coder fix → re-gate **SIGN-OFF ZERO FAIL**. Fixed grep #1 (skills/ddd-comments/SKILL.md:68) now 3-stage: exclude `DDD:` headers, exclude well-formed `DDD-DOC:` breadcrumbs, exclude `owner-handle [docs/` links. Seeded acceptance harness (Git Bash, 16/16): unowned TODO / bare HACK / linkless HACK-REF / non-doc DDD-DOC flagged; owned+linked FIXME+TODO, DDD: headers, well-formed DDD-DOC breadcrumbs NOT flagged; broken link reported by grep3; clean tree = zero named violations. Files statused `done`: `skills/ddd-comments/SKILL.md`, `templates/comments.md`, `docs/adr/0003-code-comment-indexing.md` (**status flipped proposal → accepted at this sign-off**), `templates/catalog.md`, `skills/ddd-validate-docs/SKILL.md` (check 9), `README.md`, `docs/install.md`, `skills/ddd-festival-file/SKILL.md`, `skills/ddd-design-doc/SKILL.md`. KPI-relevant evidence: K1 11/11 skills (desc 476–730 all ≤1024); K3 9/9 templates (catalog 1:1); K5 discoverability; K6/K7/K8 pass. Anti-rubber-stamp: raw-read fix + seeded harness + byte-identity of other 9 files + frozen counts.

| # | Note | Detail | Action |
|---|---|---|---|
| N-BLD-11 | ddd-comments grep #1 false-positive fix | First-gate FAIL: grep #1 exclusion matched the literal placeholder `owner [docs/`, flagging every well-formed owned+linked tag and every `DDD:` header. Now 3-stage (line 68): exclude `DDD:` headers, exclude well-formed `DDD-DOC:` breadcrumbs, exclude owner-handle `[docs/` links. Verified 16/16 seeded acceptance scenarios incl. clean-tree zero violations | Fixes gate FAIL item 8; re-gate ZERO FAIL |

| D-BLD-16 | Publish-readiness package | MIT license (`LICENSE`, copyright `Copyright (c) 2026 Document Driven Development contributors`), root-minimal exception for `LICENSE`/`.gitignore`/`.gitattributes`, one-time frozen-research unfreeze (06 + 10 path generalization), containment guard + agent-dir validation + `DIR:` empty-dir sweep in `scripts/install.sh`, `DDD:` header on the installer, exec-bit first-commit checklist | ADR 0004 proposed -> accepted at gate; publish-blocking items resolved; research unfreeze preserves line counts |
| N-BLD-12 | Frozen-unfreeze exception + plan-vs-execution | §3 said AGENTS.md/docs/research untouched — ADR 0004 one-time exception amends both: AGENTS.md gains the root-minimal publish exception; research 06/10 have the developer-specific absolute path replaced by `~/.agents/skills/` (research line counts preserved 292/130). No other research edits; all other files frozen | Documented exception per architect note |

**Gate sign-off** — `[reviewer:gate-publish-readiness]` run on 2026-08-15: **12/12 checklist items PASS**. Publish-readiness package verified independently: ADR 0004 (47, proposed); plan §10 D-BLD-16 + N-BLD-12 (378 ≤600, one H1, zero fences, no sign-off yet); AGENTS.md 42 (single root-exception sentence at line 30, byte-identical otherwise); LICENSE (21, MIT, exact copyright line); .gitignore (5 patterns); .gitattributes (2 rules); install.md 114 (Smoke test + First commit sections, zero fences); README 42 (smoke pointer). scripts/install.sh 343 ≤400: `sh -n` exit 0; POSIX-only; **containment guard validated by an independent seed set B** (absolute path, `../../`, mid-string `..`, NOTE→junction-to-outside, junction-first plain path → all WARN+skip, sentinels byte-identical, valid entries removed, `#` header skipped without WARN, exit 0); **`--uninstall --dry-run` mutates nothing** (README note + manifest intact — pre-existing defect fixed); agent-dir validation (6 invalid tokens WARN+skip; valid answer works when dirs exist); K4-reduced smoke (dry-run writes nothing; DIR:+NOTE: manifest; re-run manifest byte-stable; uninstall leaves only the pre-existing README with empty dirs swept; no-clobber refusal + `--force` overwrite; copy-fallback works); dogfooding (DDD: header line 2; audit greps clean; DEFAULT_AGENT_DIRS ×5); research unfreeze (06=292 / 10=130; zero `C:\Users\asplo`; 8+2 `~/.agents/skills` occurrences). Files statused `done`: `docs/adr/0004-publish-readiness.md` (**status flips `> **Status:** proposed` → `> **Status:** accepted` at this sign-off**), plan §10 (D-BLD-16, N-BLD-12, N-BLD-13), `LICENSE`, `.gitignore`, `.gitattributes`, `AGENTS.md` (root-exception line), `docs/install.md`, `README.md`, `scripts/install.sh`, `docs/research/06-templates-roadmap-design-feature.md`, `docs/research/10-references.md`. Anti-rubber-stamp: raw-reads of the guard/do_uninstall hunks; own seed set B; own no-clobber harness; fence/bounds/AGENTS-diff sweeps.

| N-BLD-13 | Research unfreeze portability note | The one-time unfreeze replaced `C:\Users\asplo\` with `~/` but left trailing backslash separators — e.g. `~/.agents/skills/festival-creator\SKILL.md` — a literal `\` in the filename on Unix. Line counts preserved (292/130); documentation references only, not executed | Recommend normalizing remaining `\` → `/` in research 06/10 for full portability before public publish (cosmetic, non-blocking at this gate) |
