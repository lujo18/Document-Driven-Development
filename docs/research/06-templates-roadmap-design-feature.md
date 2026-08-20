# 06-templates-roadmap-design-feature
> **Status:** done

## Purpose

**What:** Roadmap, design-doc/RFC, PRD/feature-spec, and festival-file templates with ready-to-paste skeletons and when-to-use guidance. **When to read:** Choosing the right planning artifact for a body of work. **Not for:** ADR templates ([04-templates-adr](./04-templates-adr.md)) or issue templates ([05-templates-issues](./05-templates-issues.md)).

## Roadmap Skeletons

- A roadmap communicates what the product will deliver and when, to align teams and stakeholders. Markdown roadmaps are the version-control-friendly form — no external tooling required, reviewable in PRs. Lenny Rachitsky's template roundup (the PM industry's canonical collection) covers 1-pagers/PRDs, strategy, vision, GTM, and roadmap spreadsheets — evidence that roadmap structure varies by audience (source: https://www.lennysnewsletter.com/p/my-favorite-templates-issue-37).
- **Now / Next / Later:** time-bucketed view — "Now" = in progress this cycle, "Next" = committed soon, "Later" = considered but unscheduled. *(Caveat: no canonical spec URL could be verified this session — treat the skeleton as a synthesis of common public practice, not a quote.)* [NEEDS SOURCE]
- **OKR-linked quarterly roadmap:** ties roadmap items to Objectives and Key Results; GitLab publishes its OKR process publicly in its handbook — the standard reference for handbook-first planning docs (source: https://handbook.gitlab.com/handbook/company/okrs/).
- **Cycle-based "bets" (Shape Up):** a "betting table" commits teams to shaped pitches in fixed six-week cycles; roadmaps become short lists of potential bets (source: https://basecamp.com/shapeup).
- **Public roadmap:** typically shows status (Planned / In progress / Shipped) rather than dates [NEEDS SOURCE].

**Now/Next/Later skeleton — when to use:** quick alignment across a quarter or release; no OKR machinery required; works for any team size.

    # Product Roadmap — {Product} · {Quarter, e.g. Q3 2026}

    <!-- A roadmap communicates intent, not guarantees. Update as commitments change.
         Prefer "why" + "who it helps" over feature titles. Link every row to an epic/issue. -->

    Status key: [Now] [Next] [Later]

    ## Now — in progress this cycle
    <!-- Only what the team is actively building. 3–7 items max. -->
    - **{Initiative}** — {Problem solved + target metric}. Owner: {team}.
      - Epics: {links} · Exit criteria: {definition of done}

    ## Next — committed, not started
    <!-- Highest confidence upcoming commitments. Usually 1–2 cycles out. -->
    - **{Initiative}** — {Problem solved + target metric}. Owner: {team}.

    ## Later — exploring
    <!-- Considered, not committed. Being shaped — may change or drop. -->
    - **{Initiative}** — {Why we're interested}.

    ## Recently shipped
    - {Item} — {date} — {impact so far, if measurable}

**OKR-linked quarter roadmap skeleton — when to use:** teams that must trace every initiative to a measurable objective; GitLab-style handbook-first planning (source: https://handbook.gitlab.com/handbook/company/okrs/).

    # {Team} Quarter Roadmap — {Quarter}

    <!-- One page. Every initiative must roll up to an OKR; if it doesn't,
         it doesn't go on this roadmap. Review cadence: weekly in planning. -->

    ## Objectives this quarter
    1. **O1:** {Objective}  →  **KR1:** {Key result, metric + baseline → target}
    2. **O2:** {Objective}  →  **KR2:** {Key result}

    ## Initiatives mapped to OKRs
    ### O1 — {Objective}
    | Initiative | Why | KR it moves | Status | Owner | Ship date |
    |---|---|---|---|---|---|
    | {Name} | {problem} | KR1 | In progress | {person} | {date} |
    | {Name} | {problem} | KR1 | Planned | {person} | {date} |

    ### O2 — {Objective}
    | Initiative | Why | KR it moves | Status | Owner | Ship date |
    |---|---|---|---|---|---|
    | {Name} | {problem} | KR2 | Exploring | {person} | TBD |

    ## Non-goals for the quarter
    <!-- Explicitly deferred so stakeholders know what was considered and cut. -->
    - {Item} — {why deferred}

    ## Review process
    <!-- e.g. Monthly: update statuses. End of quarter: score KRs 0–1.0, retrospect,
         then build next quarter's roadmap from what was learned. -->

## Design Doc / RFC Skeleton

- A design doc is "a relatively informal document" written before coding that documents "the high level implementation strategy and key design decisions with emphasis on the trade-offs that were considered during those decisions." Functions: early issue identification, organizational consensus, cross-cutting concerns, scaling senior knowledge, organizational memory (source: https://www.industrialempathy.com/posts/design-docs-at-google/).
- **When to write one:** when the solution is ambiguous — due to problem or solution complexity. "A clear indicator that a doc might not be necessary are design docs that are really implementation manuals." Sweet spot 10–20 pages; 1–3 page "mini design doc" for incremental work. If yes to 3+ of the article's questions (uncertainty, need for senior review, contentiousness, forgetting cross-cutting concerns, need for legacy insight), write one (source: https://www.industrialempathy.com/posts/design-docs-at-google/).
- **Lifecycle:** Creation and rapid iteration → Review → Implementation and iteration (update the doc until the system ships) → Maintenance and learning (source: https://www.industrialempathy.com/posts/design-docs-at-google/).
- **Variants across companies:** Uber (services) — approvers, abstract, architecture changes, SLAs, dependencies, load/performance, multi-DC, security, testing & rollout, metrics & monitoring, support; Monzo — why now, goals/non-goals, API, tooling, legal/privacy, risks (must-have), observability & graceful degradation, unknowns; HashiCorp — background, proposal, abandoned ideas; Razorpay — summary, motivation, detailed design, drawbacks, alternatives, adoption strategy, open questions; Couchbase adds a signoff section; Sourcegraph — summary, background, problem, proposal, definition of success (source: https://blog.pragmaticengineer.com/rfcs-and-design-docs/). Rust's RFC adds Guide-level explanation ("teach it to another Rust programmer") and Reference-level explanation (source: https://raw.githubusercontent.com/rust-lang/rfcs/master/0000-template.md).

**Google-tradition design doc skeleton — when to use:** a non-trivial system design that needs trade-offs and alternatives on record before implementation; 10–20 pages (1–3 for a mini doc).

    # Design Doc: {Project name}

    <!-- Rule #1 from Google: write in whatever form makes the most sense for the project.
         Aim for ~10-20 pages for a large project, 1-3 pages for a mini design doc.
         The doc is the place to write down TRADE-OFFS, not an implementation manual. -->

    - **Author(s):** {names} · **Status:** Draft | In review | Approved | Implemented
    - **Last updated:** {date} · **Reviewers:** {who must sign off}
    - **Links:** {related ADRs, issues, prototypes}

    ## Context and Scope
    <!-- Objective facts about the landscape and what is being built. Not a requirements doc.
         Keep it succinct; assume prior knowledge; link details. -->

    ## Goals and Non-goals
    <!-- Bullets. Non-goals are things that could reasonably be goals but are explicitly
         chosen not to be. Example: "ACID compliance" for a database design. -->
    **Goals:**
    - {goal}
    **Non-goals:**
    - {explicit non-goal}

    ## The Actual Design
    <!-- Start with an overview, then go into detail. Focus on the trade-offs you made. -->
    - **System-context diagram** (the system as part of the larger landscape)
    - **APIs** (sketch only what matters to the design; don't paste full interfaces)
    - **Data storage** (rough form, not full schemas)
    - **Code / pseudo-code** (only for novel algorithms; link to prototypes instead)
    - **Degree of constraint** (greenfield vs. constrained legacy — shapes how much is enumerated)

    ## Alternatives Considered
    <!-- One of the most important sections. For each reasonable alternative:
         what trade-offs it makes, and why those trade-offs lost given the goals. -->

    ## Cross-Cutting Concerns
    <!-- Standardized short sections your org requires — security, privacy, observability,
         accessibility, compliance. How does the design impact each, and how is it addressed?
         (Google requires dedicated privacy + security reviews before launch.) -->

    ## Rollout and Testing Plan
    <!-- Rollout strategy (feature flag, canary, migration), testing approach, rollback. -->
    - **Rollout:** {steps}
    - **Testing:** {unit/integration/e2e approach}
    - **Rollback:** {how to undo}
    - **Metrics & monitoring:** {what to watch to confirm the design works}
    - **Customer support considerations:** {known issues, docs needed}

    ## Risks and Open Questions
    <!-- What could make this fail? What is still unknown? (Monzo treats risks as must-have.) -->

    ## References and Prior Art
    <!-- Related design docs, ADRs, papers, prototypes. -->

## PRD / Feature Brief Skeleton

- The product-side spec is the PRD; engineering-side specs are feature/implementation specs; the newest form is the *festival file / implementation doc* — a feature specification written explicitly as an instruction document for an AI coding agent. "PRDs are commonly run side by side with an engineering design document. …if product managers don't specify what they'd like the team to build, it's likely the company doesn't have a writing culture" (source: https://blog.pragmaticengineer.com/rfcs-and-design-docs/).
- **Lean PRD variants:** Lenny's 1-pager starts every project; Kevin Yien's PRD (Square) is prized for its "Non-Goals" section; Asana's project brief for its problem-statement framework; Product Hunt's PRD starts "Who, Why, What"; Amazon's working-backwards PR writes the press release before the product (source: https://www.lennysnewsletter.com/p/my-favorite-templates-issue-37).
- **Spec by example / Given-When-Then:** Gherkin makes specs executable: `Feature:` groups scenarios; each `Example`/`Scenario` is `Given` (initial context) → `When` (event/action) → `Then` (observable outcome); `Background`, `Rule`, `Scenario Outline` with `Examples:` tables add structure. "As a whole, your examples are an *executable specification* of the system" (source: https://cucumber.io/docs/gherkin/reference/).

**Lean feature spec skeleton — when to use:** a single feature that needs measurable goals, explicit non-goals, and executable acceptance criteria; one page if possible.

    # Feature Spec: {Feature name}

    <!-- One page if possible. Sections mirror the strongest sources: Goals/Non-goals
         (Google), Problem/Appetite/No-Gos (Shape Up), Given-When-Then (Gherkin),
         Success metrics (festival file). -->

    - **Status:** Draft | Reviewed | Approved | In build | Shipped
    - **Owner:** {person} · **Reviewers:** {list} · **Last updated:** {date}

    ## Problem
    <!-- Who is this for, what pain, why now? One paragraph. Falsifiable. -->

    ## Goals
    <!-- What success looks like, measurable. -->
    - {goal with metric}

    ## Non-Goals
    <!-- Things that could reasonably be included but are explicitly cut. -->
    - {non-goal}

    ## Users
    <!-- Personas / segments; who is NOT a user. -->

    ## Requirements (spec by example)
    <!-- Write the core acceptance criteria as executable examples. Gherkin: Given → When → Then.
         Keep steps observable; 3–5 steps per example. -->
    Feature: {feature}
      Rule: {business rule}
        Example: {happy path}
          Given {precondition}
          When {action/event}
          Then {observable outcome}
        Example: {edge case}
          Given {precondition}
          When {action}
          Then {different outcome}

    ## Solution Sketch
    <!-- Rough UI/UX or interaction outline — fat-marker level, not pixel level.
         Reference design/design-doc links. -->

    ## Rabbit Holes and Risks
    <!-- What is unknown, complex, or open-ended enough to blow the budget? -->

    ## No-Gos
    <!-- Explicitly out of bounds for this feature. -->

    ## Rollout and Measurement
    - **Ship plan:** {flag/migration/launch steps}
    - **Metrics to watch:** {north star + guardrail metrics}
    - **Open questions:** {list with owners}

## Festival File Skeleton

- Festival file / implementation doc (for AI agents): "an enterprise-grade feature specification… It tells an AI agent exactly what to build, in what order, under what constraints, and how to verify each piece is correct at every step" — blocks: Header (feature, depends-on, complexity, target directory), Context & Boundaries (objective, scope restrictions, architecture rules), Technical & Security Constraints (build integrity, dependency order, security mandates), Implementation Phases (dependency-ordered agentic loop: types → utils → services → stores → nav → screens → logic → tests → polish), Acceptance Criteria & Validation (named criteria + a final command sequence). Every task has a concrete success metric; the build must pass after every task (source: local skill `~/.agents/skills/festival-creator/SKILL.md`).
- The ImpDoc variant adds a 10-section structure — Charter, Architecture, Agent Design Spec, Data Layer, Sprint Plan, API/Integration Contracts, Error Handling & Resilience, Testing Strategy, Launch Checklist, Decisions Log — and requires every external integration to have "a contract AND a fallback" (source: local skill `~/.agents/skills/agent-impdoc/SKILL.md`).
- Shape Up "pitch" is the human-side equivalent: Problem, Appetite (time budget), Solution, Rabbit Holes, No-Gos (source: https://basecamp.com/shapeup).
- **What makes a spec executable by an AI coding agent:** system instructions "extremely clear," at the "right altitude," organized into distinct sections, minimal high-signal set — plus curated examples, because "for an LLM, examples are the 'pictures' worth a thousand words" (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents). Festival-file discipline: imperative language (no hedge words), atomic tasks each with a runnable success metric, explicit scope restrictions, mandatory build check per task (source: local skill `~/.agents/skills/festival-creator/SKILL.md`).

**Compact festival file skeleton (agent instruction doc) — when to use:** this repo's methodology — a feature/phase that an AI coding agent will execute with per-task verification.

    # {Feature Name} Festival

    **Feature:** {one-line user value}
    **Depends on:** {features/stores/services, or "None"}
    **Estimated Complexity:** Low | Medium | High
    **Target Directory:** `src/features/{feature-name}`

    ## Context & Boundaries
    **Objective:** {exactly what the agent must produce; verifiable pass/fail}
    **Scope Restrictions:**
    - MUST only modify files under `src/features/{feature-name}`.
    - Do NOT touch global config / root navigation / shared state without human approval.
    - Approved packages: {list, or "none"}

    ## Technical & Security Constraints
    - The app must compile after EVERY task (`yarn tsc --noEmit` before proceeding).
    - Implement in dependency order: types → utils → services → stores → UI → tests → polish.
    - No hardcoded secrets; env vars only. Validate all user input. No PII in logs.

    ## Implementation Phases

    ### Phase 1 — Foundation & Types
    #### Task 1.1 — Define domain + API types
    {fields with precise types, no `any`}
    **Success metrics:** `tsc` passes; payload types omit server-generated fields.

    ### Phase 2 — Tests first (Red)
    #### Task 2.1 — Write unit + screen tests
    {what each test covers: happy path, edge cases, error states}
    **Success metrics:** tests exist and FAIL (implementations not yet present).

    ### Phase 3 — Core implementation (Green)
    #### Task 3.1 — Service layer → 3.2 State → 3.3 Navigation → 3.4 UI → 3.5 Validation
    {each task: precise behavior, edge cases, error handling}
    **Post-task build check:** `yarn tsc --noEmit` must pass before moving on.
    **Success metrics:** relevant tests turn green; described flow works in simulator.

    ### Phase 4 — Hardening
    #### Task 4.1 — Lint + security audit
    **Success metrics:** zero lint/tsc errors; security checklist fully checked.

    ## Acceptance Criteria & Validation
    1. `yarn tsc --noEmit` passes. 2. `yarn lint` passes.
    3. Feature test suite passes. 4. No files outside the feature directory changed (`git diff --name-only`).
    5. {feature-specific criterion}. 6. {feature-specific criterion}.

    Final sequence (run in order, report each result):
    yarn tsc --noEmit
    yarn lint
    yarn test -- src/features/{feature-name}
    git diff --name-only | grep -v "src/features/{feature-name}"   # expect empty

## When to Use Which

| Artifact | Use when | Weight | Source |
|---|---|---|---|
| Lightweight ADR | A single decision; codify alignment on a choice already made | 1–2 pages | https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions |
| RFC | Ambiguous, multi-team proposal needing comment and sign-off before implementation | Heavy proposal doc | https://blog.pragmaticengineer.com/rfcs-and-design-docs/ |
| Design doc | Full system design with explicit trade-offs; ambiguous solution | 10–20 pages (1–3 mini) | https://www.industrialempathy.com/posts/design-docs-at-google/ |
| PRD / feature brief | Product-side ask: what to build and why; often run beside the design doc | 1 page | https://blog.pragmaticengineer.com/rfcs-and-design-docs/; https://www.lennysnewsletter.com/p/my-favorite-templates-issue-37 |
| Festival file / implementation doc | Agent-executed feature or phase with per-task verification | Full implementation doc | local skill `~/.agents/skills/festival-creator/SKILL.md` |

**Template authoring best practices (applies to every skeleton above):**
1. **Keep it short enough to be read** — "Large documents are never kept up to date. Small, modular documents have at least a chance at being updated" (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).
2. **Make non-goals a mandatory section** — the most-copied idea from PRD/design-doc culture; "things that could reasonably be goals, but are explicitly chosen not to be goals" (source: https://www.industrialempathy.com/posts/design-docs-at-google/; https://www.lennysnewsletter.com/p/my-favorite-templates-issue-37).
3. **Force structure with placeholders, not paragraphs** — MADR uses `{curly-brace placeholders}` (source: https://raw.githubusercontent.com/adr/madr/develop/template/adr-template.md); GitHub forms force structure with required fields (source: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema).
4. **Make every task/claim verifiable** — festival files require a runnable success metric per task (source: local skill `~/.agents/skills/festival-creator/SKILL.md`); acceptance criteria as observable outcomes (source: https://cucumber.io/docs/gherkin/reference/).
5. **Write imperatively for agents, conversationally for humans** — Nygard: "as if it is a conversation with a future developer" (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions); festival files: "The agent reads instructions, not suggestions" (source: local skill `~/.agents/skills/festival-creator/SKILL.md`); Anthropic: "right altitude" instructions (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents).
6. **Codify review, not just structure** — ADRs proposed → accepted → superseded (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions); design docs four-phase lifecycle (source: https://www.industrialempathy.com/posts/design-docs-at-google/); RFCs require signoff (source: https://blog.pragmaticengineer.com/rfcs-and-design-docs/).
7. **Ship examples with every template** — MADR ships four variants (full, minimal, bare, bare-minimal) (source: https://github.com/adr/madr); Rust's RFC template doubles as its own worked example (source: https://raw.githubusercontent.com/rust-lang/rfcs/master/0000-template.md).
8. **Make templates lintable/validatable** — MADR ships markdownlint config (source: https://adr.github.io/madr/); GitHub validates form YAML (source: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository).

## Sources

- https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions — Nygard, original ADR post
- https://adr.github.io/ — ADR org
- https://github.com/adr/madr — MADR repo
- https://adr.github.io/madr/ — MADR docs
- https://raw.githubusercontent.com/adr/madr/develop/template/adr-template.md — full MADR template
- https://www.industrialempathy.com/posts/design-docs-at-google/ — Google design docs
- https://blog.pragmaticengineer.com/rfcs-and-design-docs/ — RFC/design-doc structures across companies
- https://raw.githubusercontent.com/rust-lang/rfcs/master/0000-template.md — Rust RFC template
- https://www.lennysnewsletter.com/p/my-favorite-templates-issue-37 — PM template collection
- https://cucumber.io/docs/gherkin/reference/ — Gherkin executable specification reference
- https://basecamp.com/shapeup — Shape Up
- https://handbook.gitlab.com/handbook/company/okrs/ — GitLab OKR handbook
- https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents — context engineering for AI agents
- https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema — GitHub form schema
- https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository — GitHub, configuring issue templates
- Local skills (primary sources for agent-facing formats): `~/.agents/skills/festival-creator/SKILL.md`, `~/.agents/skills/agent-impdoc/SKILL.md`
