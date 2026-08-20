# 04-templates-adr
> **Status:** done

## Purpose

**What:** Architecture Decision Record (ADR) formats — Nygard, MADR, and modern variants — with when-to-write guidance and ready-to-paste skeletons. **When to read:** Capturing or reviewing a design decision. **Not for:** Issue templates ([05-templates-issues](./05-templates-issues.md)) or roadmap/design/feature templates ([06-templates-roadmap-design-feature](./06-templates-roadmap-design-feature.md)).

## What Is an ADR

- An Architecture Decision Record (ADR) is a short text file capturing a single architecturally significant decision — its context, the decision itself, and its consequences. The collection of ADRs is the project's *decision log* (ADL). Term from Michael Nygard's 2011 post, which popularized the format as a response to the failure of large documents: "Large documents are never kept up to date… Bite sized pieces are easier for all stakeholders to consume." (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).
- The adr.github.io organization defines an Architectural Decision as "a justified design choice that addresses a functional or non-functional requirement that is architecturally significant" (source: https://adr.github.io/).

## When to Write / Not Write

- **Write** when a decision affects "structure, non-functional characteristics, dependencies, interfaces, or construction techniques"; store ADRs in the repo (original convention: `doc/arch/adr-NNN.md`); number sequentially and monotonically — never reuse numbers; when reversed, keep the old record but mark it superseded (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).
- **Write at decision time** — the record is created when the choice is made and the rationale is still fresh; the decision log is the audit trail for the architecture (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).
- **Skip** decisions that are "limited in scope and time and risk and cost, or are already covered elsewhere" (source: https://github.com/architecture-decision-record/architecture-decision-record).
- **One ADR = one decision**; ADRs are immutable — amend with date-stamped additions or supersede with a new ADR (source: https://github.com/architecture-decision-record/architecture-decision-record).
- **Keep superseded records**; the history stays intact, marked `deprecated`/`superseded by ADR-NNN` (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).
- **Review/approval workflow:** status-based lifecycle — `proposed` until stakeholders agree, then `accepted` (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions); fuller lifecycle — Initiating → Researching → Evaluating → Implementing → Maintaining → Sunsetting, with example governance (publish proposal for comments with a one-week timebox, vote by stakeholders, assign primary/secondary contacts and an accountable team, review at least yearly) (source: https://github.com/architecture-decision-record/architecture-decision-record).
- **Tooling:** `adr-tools` (5.6k stars): `adr init doc/architecture/decisions`, `adr new <title>`, `adr new -s <n>` creates a superseding ADR and marks the old one superseded in one step; default directory `doc/adr` (source: https://github.com/npryce/adr-tools). Enforcement: ADR Guard (a GitHub Action that fails PRs changing watched paths without an ADR) and fitness functions ("a decision record documents the decision, while a fitness function assures the decision") (source: https://github.com/architecture-decision-record/architecture-decision-record).

## Nygard ADR Skeleton

**When to use:** the original 2011 format — five short parts, 1–2 pages; ideal for small, fast decisions. "Write each ADR as if it is a conversation with a future developer" (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).

    # {Title — the decision in a short noun phrase}

    ## Status

    proposed | accepted | deprecated | superseded by {ADR-NNN}

    ## Context

    {The situation that forced the decision. Facts, forces in tension, constraints. 2–3 sentences.}

    ## Decision

    {The decision we made: what changed, what is now the rule. One paragraph.}

    ## Consequences

    {What becomes easier or harder, and what follow-ups are required. Bullets.}

## MADR Skeleton

**When to use:** the dominant modern variant (2.4k stars) — richer metadata, options analysis, and a confirmation step; best when decisions need recorded consultation and later verification. File convention `NNNN-title-with-dashes.md` in `docs/decisions`; metadata in YAML front matter (status, date, decision-makers, consulted, informed — a RACI-inspired split); supports categories via subdirectories (`decisions/backend/0001-*.md`); lintable with markdownlint (source: https://github.com/adr/madr; https://adr.github.io/madr/; full template: https://raw.githubusercontent.com/adr/madr/develop/template/adr-template.md).

    ---
    # Optional metadata — remove any field you don't need.
    status: proposed          # proposed | accepted | rejected | deprecated | superseded by ADR-NNNN
    date: YYYY-MM-DD          # date this ADR was last updated
    decision-makers:          # people who own the decision (RACI: Accountable/Responsible)
      - @you
    consulted:                # SMEs who gave opinions (two-way communication)
    informed:                 # people kept up to date (one-way communication)
    ---

    # {Short noun-phrase title: the solved problem + chosen solution}

    > *Placeholder guidance: one short title, e.g. "Use PostgreSQL for primary storage". 1–2 pages max.
    > Write as a conversation with a future developer. Full sentences; bullets only for lists.*

    ## Context and Problem Statement

    {Describe the situation and the problem, 2–3 sentences, value-neutral facts. What forces are in tension
    (tech, team, business, schedule)? Articulate the problem as a question if helpful, and link issues/boards.}

    ## Decision Drivers

    * {driver 1 — e.g. a quality attribute, constraint, or concern}
    * {driver 2}

    ## Considered Options

    * {Option A}
    * {Option B}
    * {Option C}

    ## Decision Outcome

    Chosen option: "{Option A}", because {justification — meets the k.o. driver / resolves the force / best trade-off, see below}.

    ### Consequences

    * Good, because {positive consequence}
    * Bad, because {negative consequence}
    * Neutral, because {trade-off that neither helps nor hurts}

    ### Confirmation

    {How will compliance with this decision be verified? e.g. code review checklist, ArchUnit/architecture test,
    a fitness function in CI, or a manual review gate.}

    ## Pros and Cons of the Options

    ### {Option A}

    {Description / example / pointer}

    * Good, because {argument}
    * Bad, because {argument}

    ### {Option B}

    * Good, because {argument}
    * Neutral, because {argument}
    * Bad, because {argument}

    ## More Information

    {Evidence, team agreement, when this should be revisited, links to related ADRs.}

## Comparison & Selection

| Dimension | Nygard | MADR |
|---|---|---|
| Parts | Title, Context, Decision, Status, Consequences; 1–2 pages (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) | Context & Problem, Decision Drivers, Considered Options, Decision Outcome (Consequences + Confirmation), Pros & Cons, More Info (source: https://raw.githubusercontent.com/adr/madr/develop/template/adr-template.md) |
| Metadata | Status only, in body | YAML front matter: status, date, decision-makers, consulted, informed (RACI-inspired) (source: https://raw.githubusercontent.com/adr/madr/develop/template/adr-template.md) |
| Options analysis | None built-in | Considered Options + Pros and Cons sections (source: https://raw.githubusercontent.com/adr/madr/develop/template/adr-template.md) |
| Confirmation step | None | Dedicated Confirmation (fitness function / architecture test / review gate) (source: https://raw.githubusercontent.com/adr/madr/develop/template/adr-template.md) |
| File convention | `doc/arch/adr-NNN.md` (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) | `docs/decisions/NNNN-title-with-dashes.md` + category subdirectories (source: https://adr.github.io/madr/) |
| Lintable | — | Yes — ships markdownlint config (source: https://adr.github.io/madr/) |
| Tooling | `adr-tools` CLI (source: https://github.com/npryce/adr-tools) | `adr-tools` CLI works; ADR Guard Action + fitness functions enforce (source: https://github.com/architecture-decision-record/architecture-decision-record) |

**When to pick which:** start with Nygard for velocity and minimal ceremony; adopt MADR when decisions need recorded consultation, explicit option analysis, and a verification step. Other variants live in the joelparkerhenderson collection — Jeff Tyree & Art Akerman's "more sophisticated" template, Alexandrian pattern (forces-based), business-case template (costs/SWOT), arc42, Planguage (QA-oriented), and Ignacio Larrañaga's "Important Technical Decisions" lean template "optimized for fast executive review" (source: https://github.com/architecture-decision-record/architecture-decision-record). ADRs sit below RFCs in weight: RFCs are the heavier, proposal-for-comment cousin used at Rust, Uber, HashiCorp, Sourcegraph, Monzo, etc.; ADRs are the lighter "decision already made / forcing function for alignment" layer — companies like Stedi use both, with RFCs for broad/complex mandates and decision records for codifying alignment (source: https://blog.pragmaticengineer.com/rfcs-and-design-docs/). Rust's RFC template shows the canonical RFC skeleton: Summary → Motivation → Guide-level explanation → Reference-level explanation → Drawbacks → Rationale and alternatives → Prior art → Unresolved questions → Future possibilities (source: https://raw.githubusercontent.com/rust-lang/rfcs/master/0000-template.md).

## Sources

- https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions — Nygard, original ADR post
- https://adr.github.io/ — ADR org
- https://github.com/adr/madr — MADR repo
- https://adr.github.io/madr/ — MADR docs
- https://raw.githubusercontent.com/adr/madr/develop/template/adr-template.md — full MADR template
- https://github.com/npryce/adr-tools — adr-tools CLI
- https://github.com/architecture-decision-record/architecture-decision-record — ADR examples, variants, governance, fitness functions
- https://blog.pragmaticengineer.com/rfcs-and-design-docs/ — RFC/design-doc structures across companies
- https://raw.githubusercontent.com/rust-lang/rfcs/master/0000-template.md — Rust RFC template
