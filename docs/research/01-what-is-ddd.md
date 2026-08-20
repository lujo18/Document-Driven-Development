# 01-what-is-ddd
> **Status:** done

## Purpose

**What:** A sourced definition of Document-Driven Development (DDD) as a methodology — its philosophy, origins, benefits, critiques, and working pieces — and how it relates to TDD, BDD, and Domain-Driven Design. **When to read:** First stop for anyone new to the library. **Not for:** Pipeline mechanics ([02-ddd-flow](./02-ddd-flow.md)) or hands-on practices ([03-best-practices](./03-best-practices.md)).

## Summary (TL;DR)

- Document what you're going to build **before** you build it; documentation drives design, tests, and code (source: https://gds.blog.gov.uk/2022/05/09/using-documentation-driven-development-for-gov-uk-sign-in/).
- DDD is a family of docs-first practices (README-driven, docs-as-code, spec-driven, design-doc culture, RFC-driven), not a single settled standard (source: https://collectiveidea.com/blog/archives/2014/04/21/on-documentation-driven-development/).
- Order matters: docs → tests → code; "if you ever find yourself thinking 'It's done, I just need to update the docs', then you've violated this process" (source: https://blog.izs.me/2017/06/documentation-driven-development/).
- From the user's eye: "if a feature is not documented, then it doesn't exist, and if a feature is documented incorrectly, then it's broken" (source: https://gist.github.com/zsup/9434452).
- "DDD" collides with Domain-Driven Design (Evans 2003); this repo adopts DDD = Document-Driven Development (source: https://en.wikipedia.org/wiki/Domain-driven_design).
- Mature forms already exist: BDD's Given/When/Then living documentation, specification by example, Google design docs, ADRs, RFC-driven development (sources below).
- Not Big Design Up Front — docs-first "interrogates the top-level blueprint"; RDD is DDD's constrained subset (source: https://gds.blog.gov.uk/2022/05/09/using-documentation-driven-development-for-gov-uk-sign-in/; https://tom.preston-werner.com/2010/08/23/readme-driven-development.html).
- 2025+ AI-agent renaissance: context files (PLAN.md, ARCHITECTURE.md, AGENTS.md/CLAUDE.md) are the new "documentation first" artifact (source: https://news.ycombinator.com/item?id=44833651).
- Key critiques: doc rot, DDD-turned-waterfall, "nothing new" (BDD/ATDD already do this), and agent-context files that only work when loaded into context (sources below).
- Framework takeaway: ship the artifact set (README scaffolds, PRD/spec, ADR, design doc, RFC, user-story + acceptance criteria, Diátaxis structures), dogfood "docs lead, code follows", version docs with software, and reuse overwrite-safety + idempotency invariants for doc installs (sources: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions; https://www.industrialempathy.com/posts/design-docs-at-google/; https://diataxis.fr/; https://gist.github.com/zsup/9434452; repo AGENTS.md).

## Defining DDD

- **Core idea (short version):** Document what you're going to build **before** you build it, and let that documentation drive the design, the tests, and the code. UK Government Digital Service: "documentation-driven development, or docs-driven development, means documenting what you're trying to build before you build it… instead of documenting your code, you code your documentation. It's a low-cost way of prototyping your code" (source: https://gds.blog.gov.uk/2022/05/09/using-documentation-driven-development-for-gov-uk-sign-in/).
- **As a sibling of TDD:** Isaac Z. Schlueter (npm founder, former GitHub CTO): "like test driven development, and every bit as disciplined, but for docs instead of tests" — process: (1) write the README before the thing exists, (2) copy the example code into a test file, (3) write code to match, keeping docs, tests, code in sync, (4) when changing anything, update docs *before* implementation or test code (source: https://blog.izs.me/2017/06/documentation-driven-development/).
- **The "user's eye" definition:** "from the perspective of a user, if a feature is not documented, then it doesn't exist, and if a feature is documented incorrectly, then it's broken" — mandated order: write documentation → get feedback → TDD aligned to the docs → staging → deliver → publish docs → increment versions (source: https://gist.github.com/zsup/9434452).
- **As a category of methodologies:** Wikipedia: "Specification-driven development is a type of documentation-driven development, along with model-driven development, model transformation, and round-trip engineering" (source: https://en.wikipedia.org/wiki/Specification-driven_development).
- **Early (2011) formulation:** two rules — "1. write docs before the tests, than the code. this way you reflect more and have your docs always complete, up to date and ready to ship. 2. rewriting docs is part of every refactoring" (source: https://blogs.perl.org/users/lichtkind/2011/10/document-driven-development.html).
- **2025 AI-era re-branding:** Ryan Vice's "Doc Driven Development (DocDD)" reframes it for AI-assisted coding as a 5-step loop — Document → Generate → Test → Refactor → Update — where documentation becomes the "context" that makes LLM code generation reliable (source: https://docdd.ai/).
- **Caveat:** there is **no single owner or standard** for "document driven development." It is a family of docs-first practices (README-driven, docs-as-code, spec-driven, design-doc culture, RFC-driven) that share the same instinct. The term has no stable Wikipedia article — Collective Idea's 2014 post links the term to a redlink "(no wiki)" (source: https://collectiveidea.com/blog/archives/2014/04/21/on-documentation-driven-development/).

## Disambiguation

- **Document-Driven Development (this repo's DDD):** docs written before code drive design, tests, and implementation (source: https://gds.blog.gov.uk/2022/05/09/using-documentation-driven-development-for-gov-uk-sign-in/).
- **Domain-Driven Design (the other DDD):** Eric Evans' 2003 book models a business domain with a ubiquitous language and bounded contexts; the acronym has been "permanently ambiguous" since (source: https://en.wikipedia.org/wiki/Domain-driven_design; "DDD is 'Domain Driven Development' :P" at https://gist.github.com/zsup/9434452).
- **Fusion attempt:** Ryan Vice's DocDD deliberately merges document-driven and domain-driven practice for AI-assisted coding (source: https://docdd.ai/).
- **Data-driven development:** development steered by data/models rather than by documentation — a different driver than docs; not covered by R1's sources [NEEDS SOURCE].
- **Canonical terms adopted here:** "DDD" = Document-Driven Development; "Domain-Driven Design" is always written in full (per the research-library README glossary contract).

## Origins & Lineage

- **Early 1990s:** Alfred Aho ("the a in awk") taught this way ~20 years before the term existed; the 2011 Perl essay credits the Django community for the framing (source: https://blogs.perl.org/users/lichtkind/2011/10/document-driven-development.html).
- **1996 — WyCash+:** earliest documented use of realistic examples as a single source of truth for requirements *and* automated tests, on a project described by Ward Cunningham (source: https://en.wikipedia.org/wiki/Specification_by_example).
- **2003 — acronym collision:** Eric Evans publishes *Domain-Driven Design*; "DDD" permanently ambiguous (source: https://en.wikipedia.org/wiki/Domain-driven_design).
- **2004 — "Specification by Example" coined:** Martin Fowler used the phrase at an XP/Agile Universe workshop in 2002, published bliki post 2004; examples (usable as tests) are easier to write than formal pre/post conditions and are a "double-check" against the code (source: https://martinfowler.com/bliki/SpecificationByExample.html; history at https://en.wikipedia.org/wiki/Specification_by_example).
- **2006 — BDD:** Dan North introduces Behavior-Driven Development, formalizing Given/When/Then scenarios and "living documentation" via executable specifications (source: https://en.wikipedia.org/wiki/Behavior-driven_development).
- **2010 — canonical "write it first" essay:** Tom Preston-Werner (GitHub co-founder) publishes *Readme Driven Development* — "Write your Readme first. First. As in, before you write any code or tests" — and *explicitly distinguishes* RDD from DDD: RDD is "a subset or limited version of DDD" that "keeps you safe from DDD-turned-waterfall syndrome" (source: https://tom.preston-werner.com/2010/08/23/readme-driven-development.html).
- **2011 — threads converge:** lichtkind's *Document Driven Development* (Oct 2011) (source: https://blogs.perl.org/users/lichtkind/2011/10/document-driven-development.html); Michael Nygard's *Documenting Architecture Decisions* introduces ADRs as small, version-controlled records of "architecturally significant" decisions (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions); Gojko Adzic's *Specification by Example* book popularizes "living documentation" (source: https://en.wikipedia.org/wiki/Specification_by_example).
- **2013 — widely-circulated gist:** "Documentation-Driven Development (DDD)" by GitHub user zsup (280 stars, active comments through 2026) (source: https://gist.github.com/zsup/9434452).
- **2014 — docs-first APIs at Collective Idea:** "write your documentation first… Changes are easier and faster to make in documentation than they are in code" (source: https://collectiveidea.com/blog/archives/2014/04/21/on-documentation-driven-development/).
- **2016 — Twilio's "docs before a single line of code"** (source: https://levlaz.org/documentation-driven-development/).
- **2018 — RFC-driven development** as explicit engineering-management practice (source: https://engineering-management.space/post/rfc-driven-development/).
- **2019 — Living Documentation book:** Cyrille Martraire (author site: https://martraire.com/), building on spec-by-example "living documentation" (source: https://en.wikipedia.org/wiki/Specification_by_example).
- **2020 — Design Docs at Google:** Malte Ubl's essay codifies the design-doc lifecycle (create → review → implement → maintain) and anatomy (context, goals/non-goals, design, alternatives, cross-cutting concerns) (source: https://www.industrialempathy.com/posts/design-docs-at-google/).
- **2022 — government-scale case study:** GDS uses docs-driven development for GOV.UK Sign In's auth component; writing/updating + testing documentation is a feature success criterion (source: https://gds.blog.gov.uk/2022/05/09/using-documentation-driven-development-for-gov-uk-sign-in/).
- **2024–2026 — AI-agent renaissance:** DDD rediscovered as the recipe for AI-assisted development: context files (`PLAN.md`, `ARCHITECTURE.md`, `TODO.md`, `DECISIONS.md`, `COLLABORATION.md`, `AGENTS.md`/`CLAUDE.md`) become the "documentation first" artifact telling coding agents *why* and *what* before code (source: https://news.ycombinator.com/item?id=44833651; comment "This old discussion hits differently in the AI era!" at https://gist.github.com/zsup/9434452; https://docdd.ai/).

## Philosophy

- **Documentation is the design medium, not the output.** "As software engineers our job is not to produce code per se, but rather to solve problems. Unstructured text, like in the form of a design doc, may be the better tool for solving problems early in a project lifecycle" (source: https://www.industrialempathy.com/posts/design-docs-at-google/).
- **Order matters:** docs before tests, tests before code; "if you ever find yourself thinking 'It's done, I just need to update the docs', then you've violated this process… you might've done the wrong thing" (source: https://blog.izs.me/2017/06/documentation-driven-development/).
- **Undocumented = nonexistent; misdocumented = broken.** The user's perspective is the definition of done (source: https://gist.github.com/zsup/9434452).
- **Design the user's mental model, not the implementation.** "The design of how a thing is used limits the implementations available, and vice versa, so whichever is done first will tend to limit the scope of the other" (source: https://blog.izs.me/2017/06/documentation-driven-development/).
- **Writing is thinking at scale.** Human working memory is tiny; a written document lets you "fully off-load significant chunks of thought with hardly any data-loss, allowing us to think slower and more carefully while still covering a huge semantic surface" (source: https://blog.izs.me/2017/06/documentation-driven-development/).
- **Docs are reviewed like code.** "a pull request with no docs should feel as dirty as one with no tests" (source: https://collectiveidea.com/blog/archives/2014/04/21/on-documentation-driven-development/); docs should be reviewed by users *before* development starts (source: https://gist.github.com/zsup/9434452).
- **Docs and code are versioned together** (source: https://gist.github.com/zsup/9434452).
- **Not Big Design Up Front.** GDS: DDD "isn't a 'Big Design Up Front' approach… Instead, docs-driven development interrogates the top-level blueprint" (source: https://gds.blog.gov.uk/2022/05/09/using-documentation-driven-development-for-gov-uk-sign-in/).
- **Bounded, anti-waterfall discipline.** RDD "punishes you for lengthy or overprecise specification" and "rewards you for keeping libraries small and modularized" (source: https://tom.preston-werner.com/2010/08/23/readme-driven-development.html).
- **Single source of truth.** Spec-by-example: one shared source (examples) as both specification and test (source: https://en.wikipedia.org/wiki/Specification_by_example).
- **Against "valueless documentation."** Nygard's ADR essay: "Agile methods are not opposed to documentation, only to valueless documentation. Documents that assist the team itself can have value, but only if they are kept up to date. Large documents are never kept up to date" (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).

## DDD vs TDD/BDD/Domain-Driven Design

| Methodology | Relationship to DDD | Key difference | Sources |
|---|---|---|---|
| TDD | Complementary — DDD is "TDD… but for docs instead of tests"; README examples become the test file; TDD recommended *after* docs are written | TDD verifies via code-level tests; DDD specifies before implementation | https://blog.izs.me/2017/06/documentation-driven-development/; https://gist.github.com/zsup/9434452; https://collectiveidea.com/blog/archives/2014/04/21/on-documentation-driven-development/ |
| BDD | Strongest overlap — DDD's most mature form for behavior: conversations → stories → executable Given/When/Then specs doubling as "living documentation" | BDD is executable behavior specs; DDD is the broader docs-first pipeline | https://en.wikipedia.org/wiki/Behavior-driven_development |
| Domain-Driven Design | Acronym collision + modern fusion — models a business domain; DocDD deliberately merges both | Domain models with ubiquitous language vs docs-first engineering workflow | https://en.wikipedia.org/wiki/Domain-driven_design; https://docdd.ai/ |
| Specification by example | DDD's verification engine — spec *and* test; becomes "living documentation" | Examples as single source of truth | https://en.wikipedia.org/wiki/Specification_by_example; https://martinfowler.com/bliki/SpecificationByExample.html |
| README-driven development | DDD's constrained subset — "RDD could be considered a subset or limited version of DDD" | RDD limits docs-first discipline to the README | https://tom.preston-werner.com/2010/08/23/readme-driven-development.html; https://collectiveidea.com/blog/archives/2014/04/21/on-documentation-driven-development/ |
| RFC-driven development | DDD for cross-team planning; acknowledges downsides (time, sync drift, review bottlenecks) | Formal proposal documents with explicit review | https://engineering-management.space/post/rfc-driven-development/ |
| Spec-driven / contract-first | DDD for APIs — OpenAPI/RAML/Swagger generating docs and tests | Contract files generate both docs and tests | https://en.wikipedia.org/wiki/Specification-driven_development; comment at https://gist.github.com/zsup/9434452 |
| Literate programming | Philosophical ancestor | Code embedded in prose | comment at https://gist.github.com/zsup/9434452 |

## Benefits

- Catches wrong-building early and cheaply; design issues found when "changes are still cheap" (source: https://gds.blog.gov.uk/2022/05/09/using-documentation-driven-development-for-gov-uk-sign-in/; https://www.industrialempathy.com/posts/design-docs-at-google/).
- Builds the right thing. "A perfect implementation of the wrong specification is worthless" (source: https://tom.preston-werner.com/2010/08/23/readme-driven-development.html).
- Velocity via parallelization: client/server teams work simultaneously from shared docs (source: https://collectiveidea.com/blog/archives/2014/04/21/on-documentation-driven-development/).
- Consistency that survives team change; Google engineers' first question: "Where is the design doc?" (source: https://gds.blog.gov.uk/2022/05/09/using-documentation-driven-development-for-gov-uk-sign-in/; https://www.industrialempathy.com/posts/design-docs-at-google/).
- Transparency in review: reviewers see the "why" behind a diff (source: https://collectiveidea.com/blog/archives/2014/04/21/on-documentation-driven-development/).
- Better developer/user experience — Twilio model (source: https://levlaz.org/documentation-driven-development/).
- Documentation that can't rot: spec = automated test = "living documentation" (source: https://en.wikipedia.org/wiki/Specification_by_example).
- Organizational memory; design docs "scale knowledge of senior engineers into the organization" (source: https://www.industrialempathy.com/posts/design-docs-at-google/).
- Works at government scale (GDS) (source: https://gds.blog.gov.uk/2022/05/09/using-documentation-driven-development-for-gov-uk-sign-in/).
- Unlocks AI-assisted development: persistent documentation ("context is king") makes LLM coding agents reliable (source: https://docdd.ai/; https://news.ycombinator.com/item?id=44833651).

## Critiques & Failure Modes

- **DDD-turned-waterfall syndrome.** Docs-first slips into Big Design Up Front, "reams of technical specifications" with no code (source: https://tom.preston-werner.com/2010/08/23/readme-driven-development.html).
- **"Nothing new" critique.** BDD/ATDD practitioners argue stories + acceptance tests + TDD already are documentation-driven; "Don't rely on rewriting a bunch of static docs when requirements aren't quite right or change as the sole driver of developing software" (comment by dschinkel at https://gist.github.com/zsup/9434452).
- **Docs rot.** "we humans are bad at updating documents" → "design doc archaeology"; big docs are *never* kept up to date (source: https://www.industrialempathy.com/posts/design-docs-at-google/; https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).
- **Overhead and process friction.** "Writing design docs is overhead"; not worth it when the solution is obvious or when prototyping matters (source: https://www.industrialempathy.com/posts/design-docs-at-google/); RFCs "take time and may clash with… SCRUM and poker planning" (source: https://engineering-management.space/post/rfc-driven-development/).
- **Doc-sync drift.** After coding starts, implementations diverge; pragmatic answer: treat RFC as historical context, flip to read-only (source: https://engineering-management.space/post/rfc-driven-development/).
- **Not universally applicable.** "DDD makes a lot of sense when your product is primarily an API like Twilio, I suppose it could fall apart for other types of products" (source: https://levlaz.org/documentation-driven-development/); spec-by-example "does not apply to purely technical problems" (source: https://en.wikipedia.org/wiki/Specification_by_example).
- **Requires organizational culture and roles** — GDS had a dedicated technical writer and an open standard (OpenID Connect) (source: https://gds.blog.gov.uk/2022/05/09/using-documentation-driven-development-for-gov-uk-sign-in/).
- **Naming and scope confusion.** "DDD" collides with Domain-Driven Design; no Wikipedia article (source: https://en.wikipedia.org/wiki/Domain-driven_design; https://collectiveidea.com/blog/archives/2014/04/21/on-documentation-driven-development/; https://gist.github.com/zsup/9434452).
- **AI-era caveat: context files get ignored.** Practitioners report agents "don't actually read those or keep them in context unless you prompt it to… it has to be in CLAUDE.md or it'll quickly forget" (source: https://news.ycombinator.com/item?id=44833651).
- **When NOT to use it:** unambiguous solutions; docs-as-implementation-manuals; cultures that won't maintain docs; no writer/ownership; prototyping speed matters (source: https://www.industrialempathy.com/posts/design-docs-at-google/; https://engineering-management.space/post/rfc-driven-development/).

## Working Pieces Inventory

- **README** — entry-point doc written first; "single most important document in your codebase" (source: https://tom.preston-werner.com/2010/08/23/readme-driven-development.html; https://blog.izs.me/2017/06/documentation-driven-development/).
- **PRDs / product specs** — define a product change before engineering (source: https://blog.izs.me/2017/06/documentation-driven-development/).
- **Design docs** — context & scope, goals/non-goals, design with trade-offs, alternatives, cross-cutting concerns; Google sweet spot 10–20 pages, 1–3 page "mini design docs" for sub-tasks (source: https://www.industrialempathy.com/posts/design-docs-at-google/).
- **ADRs** — short, numbered, version-controlled files (`doc/arch/adr-NNN.md`) with fixed 4-part format: Title / Context / Decision / Status (+ Consequences); one decision per record; superseded ones kept (source: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).
- **RFCs / proposals** — collaborative pre-implementation documents (e.g., Rust RFC process; per-role first drafts) (source: https://engineering-management.space/post/rfc-driven-development/; https://github.com/rust-lang/rfcs).
- **User stories + acceptance criteria** — stories/cards as "initial documentation as a result of communication"; Given/When/Then scenarios become executable specs (source: https://en.wikipedia.org/wiki/Behavior-driven_development; https://gist.github.com/zsup/9434452).
- **Executable specs / living documentation** — Gherkin/Cucumber-style examples that run as automated tests; tools: Behat, Concordion, Cucumber, FitNesse, Robot Framework, SpecFlow (source: https://en.wikipedia.org/wiki/Specification_by_example; https://en.wikipedia.org/wiki/Behavior-driven_development).
- **Docs-as-code pipelines** — plain-text markup in git with issue trackers, code review, automated tests, CI that can block merges when a feature ships without docs; reference toolchain docToolchain (source: https://www.writethedocs.org/guide/docs-as-code/).
- **Documentation taxonomies** — Diátaxis: tutorials, how-to guides, technical reference, explanation (source: https://diataxis.fr/).
- **Pitches (Shape Up)** — Problem, Appetite, Solution, Rabbit Holes, No-gos; presented at a "betting table" (source: https://basecamp.com/shapeup).
- **PR/FAQ (Working Backwards)** — Amazon's press release + FAQ written *before* building (source: https://www.workingbackwards.com/).
- **Agent-context documents (2025+)** — `PLAN.md`, `ARCHITECTURE.md`, `TODO.md`, `DECISIONS.md`, `COLLABORATION.md`, per-agent `AGENTS.md`/`CLAUDE.md`/`.windsurfrules` loaded into agent context as "the single source of truth for project state" (source: https://news.ycombinator.com/item?id=44833651; https://gist.github.com/zsup/9434452).

Full lifecycle mapping in [02-ddd-flow](./02-ddd-flow.md).

## Sources

- https://blog.izs.me/2017/06/documentation-driven-development/ — Schlueter, Documentation Driven Development (2017)
- https://gds.blog.gov.uk/2022/05/09/using-documentation-driven-development-for-gov-uk-sign-in/ — GDS, GOV.UK Sign In case study (2022)
- https://gist.github.com/zsup/9434452 — zsup gist, Documentation-Driven Development (2013, comments to 2026)
- https://blogs.perl.org/users/lichtkind/2011/10/document-driven-development.html — lichtkind (2011)
- https://collectiveidea.com/blog/archives/2014/04/21/on-documentation-driven-development/ — Collective Idea (2014)
- https://levlaz.org/documentation-driven-development/ — Lev Lazinskiy on Twilio (2016)
- https://tom.preston-werner.com/2010/08/23/readme-driven-development.html — Preston-Werner, Readme Driven Development (2010)
- https://docdd.ai/ — Ryan Vice, DocDD (2025)
- https://www.writethedocs.org/guide/docs-as-code/ — Write the Docs, Docs as Code
- https://diataxis.fr/ — Diátaxis
- https://www.industrialempathy.com/posts/design-docs-at-google/ — Malte Ubl, Design Docs at Google (2020)
- https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions — Nygard, Documenting Architecture Decisions (2011)
- https://engineering-management.space/post/rfc-driven-development/ — RFC driven development (2018)
- https://martinfowler.com/bliki/SpecificationByExample.html — Fowler, Specification By Example (2004)
- https://en.wikipedia.org/wiki/Specification_by_example — Wikipedia
- https://en.wikipedia.org/wiki/Behavior-driven_development — Wikipedia
- https://en.wikipedia.org/wiki/Specification-driven_development — Wikipedia
- https://en.wikipedia.org/wiki/Domain-driven_design — Wikipedia
- https://basecamp.com/shapeup — Shape Up
- https://www.workingbackwards.com/ — Working Backwards (PR/FAQ)
- https://news.ycombinator.com/item?id=44833651 — HN thread on AGENTS.md/CLAUDE.md (Aug 2025)
- https://martraire.com/ — Cyrille Martraire, Living Documentation
- https://github.com/rust-lang/rfcs — Rust RFCs
- https://medium.com/blacklane-engineering/documentation-driven-development-8b2ff119104f — Blacklane (fetch returned 403, headline claim per search snippet) [UNVERIFIED]
