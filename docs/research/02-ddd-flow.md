# 02-ddd-flow
> **Status:** done

## Purpose

**What:** The end-to-end doc-driven pipeline — stages from context/onboarding through doc-first planning, approval, doc-anchored implementation, verification, review, and maintenance — with gates, artifacts, and owners. **When to read:** Planning how documentation drives work. **Not for:** DDD definition ([01-what-is-ddd](./01-what-is-ddd.md)) or best practices ([03-best-practices](./03-best-practices.md)).

## TL;DR

- Docs-as-code is the umbrella practice: docs live next to code, use the same tools (Git, issue trackers, code review, automated tests), and change in the same pull request (source: https://www.writethedocs.org/guide/docs-as-code/).
- Seven stages: 0 Context & Onboarding → 1 Doc-First Plan → 2 Gate & Approval → 3 Implementation (doc-anchored) → 4 Verification → 5 Review & Sign-off → 6 Maintenance & Living Docs.
- Each stage produces a doc artifact and passes a gate before the next stage starts; gates are the contract between docs and code (source: https://www.writethedocs.org/guide/docs-as-code/; https://adr.github.io/).
- Decision capture (ADRs) is orthogonal to the design doc and lives with the code (source: https://adr.github.io/).
- Verification treats docs like code: prose linting, link checks, and build checks run in CI and can block merges (source: https://www.writethedocs.org/guide/docs-as-code/; https://vale.sh/).
- Publication is CI/CD-owned: merged = published into a searchable portal (source: https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey).
- The long tail is living docs: AGENTS.md is living documentation; update docs only when it hurts; run drift audits (source: https://agents.md/; https://agilemodeling.com/essays/agileDocumentation.htm; https://ekline.io/blog/docs-as-code-engineering-teams).

## Pipeline Overview

    +--------------+   +--------------+   +--------------+   +--------------+   +--------------+   +--------------+   +--------------+
    | 0 Context &  | → | 1 Doc-First  | → | 2 Gate &     | → | 3 Implement  | → | 4 Verify     | → | 5 Review &   | → | 6 Maintain & |
    | Onboarding   |   | Plan         |   | Approval     |   | (doc-anchored)|   | (CI gates)   |   | Sign-off     |   | Living Docs  |
    +--------------+   +--------------+   +--------------+   +--------------+   +--------------+   +--------------+   +--------------+
     README index      plan doc exists    ADRs accepted     docs + code in     CI doc checks     reviewer          drift audits,
     AGENTS.md         goals/non-goals    backlog planned   same PR, reviewed  (Vale, links)     checklist passes  stale docs pruned,
     llms.txt          success defined    (Gate 2)          (Gate 3)           (Gate 3)          (Gate 4)          index refreshed
     (Gate 0)          (Gate 1)

Same-PR docs change with code (source: https://www.writethedocs.org/guide/docs-as-code/); decision capture via ADRs at the approval gate (source: https://adr.github.io/).

## Stage 0 Context & Onboarding

- **README index** — the entry point and index of the docs home (source: https://www.writethedocs.org/guide/docs-as-code/); agent-facing files make the repo self-describing.
- **AGENTS.md** — "a README for agents": build/test commands, style, conventions; nested per subproject; 60k+ projects adopt it (source: https://agents.md/).
- **CLAUDE.md / per-agent files** — start-of-conversation memory, keep concise, import other files (source: https://www.anthropic.com/engineering/claude-code-best-practices).
- **llms.txt + Markdown mirrors** — site-level index of LLM-readable pages: "the file itself stays small enough to fit in context. The detail lives behind the links" (source: https://llmstxt.org/); Cloudflare ships `llms.txt`, `llms-full.txt`, Markdown mirrors via `index.md` or `Accept: text/markdown` (source: https://developers.cloudflare.com/docs-for-agents/).
- **Gate 0 (Indexed):** agent can answer "where do I look?" — README links every file; onboarding artifacts exist before planning starts.

## Stage 1 Doc-First Plan

- **Idea → Intent (pre-flight, cheapest stage to change direction):** Write a short intent/one-pager before any code; design docs exist "to define a software design before coding" and to surface design problems "when making changes is still cheap" (source: https://www.industrialempathy.com/posts/design-docs-at-google/). Actors: author/PM/eng lead; small set of early reviewers. Artifact out: 1–3 page intent doc or "mini design doc" for incremental work (source: https://www.industrialempathy.com/posts/design-docs-at-google/). Agile equivalent: "model storming" and "look-ahead modeling" — sketch just enough to unblock, discard most sketches ("the vast majority of models created by agile developers" are temporary) (source: https://agilemodeling.com/essays/agileDocumentation.htm).
- **Design/RFC (the document is the deliverable):** Lifecycle: creation and rapid iteration → review (possibly multiple rounds) → implementation and iteration → maintenance and learning (source: https://www.industrialempathy.com/posts/design-docs-at-google/). Canonical anatomy: context & scope, goals and non-goals, the actual design with trade-offs, alternatives considered, cross-cutting concerns (security/privacy/observability), ~10–20 pages for large projects (source: https://www.industrialempathy.com/posts/design-docs-at-google/). Actors: author + co-authors, close collaborators, then wider audience; heavy-weight variant is a scheduled design review meeting with senior engineers (source: https://www.industrialempathy.com/posts/design-docs-at-google/).
- **Gate 1 (Planned):** plan doc exists with goals/non-goals and success defined; consensus/review before implementation starts; primary value is catching issues "relatively early... when it is still relatively cheap to make changes" (source: https://www.industrialempathy.com/posts/design-docs-at-google/).

## Stage 2 Gate & Approval

- **Decision capture (ADRs, orthogonal to the design doc):** An Architectural Decision Record "captures a single AD and its rationale... along with its trade-offs and consequences"; the collection is the project's decision log (source: https://adr.github.io/). ADRs are lightweight, template-driven, support "agile practices as well as iterative and incremental engineering processes" (source: https://adr.github.io/).
- **Task breakdown / backlog (docs enter the tracker):** Docs-as-code means using the same tools as code, explicitly including **issue trackers** and **version control**, so documentation work is planned, assigned, and tracked like engineering work (source: https://www.writethedocs.org/guide/docs-as-code/). Squarespace stores "RFCs, and specs in .md files... alongside our source code" (source: https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey).
- **Gate 2 (Approved):** an accepted ADR means the decision is made and the rationale is queryable later; without them teams "end up in loose ends" (source: https://www.industrialempathy.com/posts/design-docs-at-google/); issue/PR templates enforce structure and definition-of-done before work starts.

## Stage 3 Implementation (doc-anchored)

- Docs travel with the code change: code and docs change in the **same pull request**, reviewed together, merged together — "we've put our diagrams next to our code... and have a tighter feedback loop because of pull requests" (source: https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey).
- "You can block merging of new features if they don't include documentation, which incentivizes developers to write about features while they are fresh" (source: https://www.writethedocs.org/guide/docs-as-code/).
- Actors: engineer (SME, first draft) + technical writer (structure/clean-up) — best of three models is the two working together (source: https://agilemodeling.com/essays/agileDocumentation.htm).
- Every change maps to a plan section — doc-anchored implementation.
- **Gate 3:** PR review approval; docs reviewed with the same rigor as code.

## Stage 4 Verification

- Docs quality gates in CI: docs-as-code explicitly includes **automated tests** for docs; mature teams add prose linting, link checks, build checks that "run in CI before anything merges" (source: https://www.writethedocs.org/guide/docs-as-code/; tooling at https://vale.sh/).
- Real-world gates: Vale is "a required check in GitLab's documentation testing pipeline"; NVIDIA "checks all NeMo Agent Toolkit documentation... before it merges" (source: https://vale.sh/).
- Preview environments part of verification: local TechDocs CLI preview, remote preview branches suffixed `-techdocs-preview` (source: https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey).
- **Gate 3 (Verified):** CI failure = no merge; treated as a code build failure.

## Stage 5 Review & Sign-off

- Review happens through the same pull-request mechanism as code; docs are part of the diff and reviewed with the same rigor (source: https://www.writethedocs.org/guide/docs-as-code/).
- **Release / publish (CI/CD owns publication):** "Every time doc changes are merged... our team's CI/CD pipeline updates Backstage automatically," guaranteeing "every documentation update... lands in a standard, easily searchable place" (source: https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey).
- Changelogs/release notes are a first-class content type published on release (source: https://developers.cloudflare.com/style-guide/documentation-content-strategy/content-types/).
- **Gate 4 (Signed-off):** reviewer checklist passes; merged = published; no manual publish step.

## Stage 6 Maintenance & Living Docs

- "Treat AGENTS.md as living documentation" (source: https://agents.md/); AGENTS.md "checked into git so your team can contribute. The file compounds in value over time" (source: https://www.anthropic.com/engineering/claude-code-best-practices).
- Agile rule: "Update documentation only when it hurts" and "document stable things, not speculative things" (source: https://agilemodeling.com/essays/agileDocumentation.htm).
- Scheduled drift audits: 5-step workflow detect → classify → draft → review → measure, with a "docs drift rate" (count pages where docs disagree with product behavior) tracked per release (source: https://ekline.io/blog/docs-as-code-engineering-teams).
- **Gate (Maintenance):** periodic docs health review; stale/obsolete pages flagged, fixed, or deleted (noindex for deprecated content, e.g. Cloudflare) (source: https://developers.cloudflare.com/style-guide/how-we-docs/ai-consumability/).

## Artifact Map

**Working pieces (document types and their lifecycle in the flow):**
- **Intent / one-pager / mini design doc** — idea-stage, cheap, often discarded; "1-3 page mini design doc" ideal for incremental improvements and subtasks (source: https://www.industrialempathy.com/posts/design-docs-at-google/).
- **Design doc / RFC** — lifecycle: create → iterate → review → implement → maintain/learn; must be updated "if the designed system hasn't shipped yet"; post-ship changes often become linked amendments (source: https://www.industrialempathy.com/posts/design-docs-at-google/).
- **ADR (Architecture Decision Record)** — one decision per record, immutable once accepted; the collection is the decision log; new ADRs can supersede old ones; templates + tooling exist (source: https://adr.github.io/).
- **Spec / executable specification** — prefers runnable artifacts (customer tests, developer tests) over "plain old documentation"; tests "not only specify your system they also help to validate it" (source: https://agilemodeling.com/essays/agileDocumentation.htm).
- **Issue & PR templates** — the intake layer of docs-as-code; issues and PRs are the review vehicles (source: https://www.writethedocs.org/guide/docs-as-code/).
- **Runbooks / how-tos / FAQs** — operational documentation stored in-repo: "Service alert runbooks, cron job overviews, how-to articles, FAQs, API documentation generated from OpenAPI specs" (source: https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey).
- **Changelog / release notes** — formal content type in mature doc taxonomies, updated at release (source: https://developers.cloudflare.com/style-guide/documentation-content-strategy/content-types/).
- **Content-taxonomy docs (Diátaxis)** — tutorials, how-to guides, technical reference, explanation; each serves a different user need (source: https://diataxis.fr/). Cloudflare operationalizes a similar taxonomy (concept, how-to, tutorial, troubleshooting, reference, etc.) (source: https://developers.cloudflare.com/style-guide/documentation-content-strategy/content-types/).
- **Agent-facing files** — AGENTS.md ("a README for agents": build/test commands, style, conventions; nested per subproject; 60k+ projects adopt it) (source: https://agents.md/); CLAUDE.md (start-of-conversation memory, keep concise, import other files) (source: https://www.anthropic.com/engineering/claude-code-best-practices).
- **llms.txt + Markdown mirrors** — site-level index of LLM-readable pages: "the file itself stays small enough to fit in context. The detail lives behind the links" (source: https://llmstxt.org/); Cloudflare ships `llms.txt`, `llms-full.txt`, Markdown mirrors via `index.md` or `Accept: text/markdown` (source: https://developers.cloudflare.com/docs-for-agents/).
- **Style guide / glossary** — shared editorial contract for all doc types (source: https://developers.cloudflare.com/style-guide/; https://developers.google.com/tech-writing).
- **Doc templates** — standardized skeletons that beat the blank page; The Good Docs Project publishes a full suite of open-source templates (source: https://thegooddocsproject.dev/).
- **Document lifecycle (agile view)** — a temporary model becomes permanent ("a keeper") only when: clear value, a real audience, stakeholders willing to invest; otherwise it gathers dust, gets revived, or is discarded (source: https://agilemodeling.com/essays/agileDocumentation.htm).

| Stage | Artifact produced | Primary owner / reviewer |
|---|---|---|
| 0 Context & Onboarding | README index, AGENTS.md / CLAUDE.md, llms.txt | Maintainer / technical writer; consumed by agents & team (source: https://agents.md/; https://llmstxt.org/) |
| 1 Doc-First Plan | Intent doc / mini design doc / design doc / RFC | Author (PM/eng lead) + co-authors; reviewed by close collaborators then wider audience (source: https://www.industrialempathy.com/posts/design-docs-at-google/) |
| 2 Gate & Approval | ADRs, issue/PR templates, backlog | Engineer / architect author; reviewer + team approve (source: https://adr.github.io/) |
| 3 Implementation (doc-anchored) | Code + docs in the same PR | Engineer (SME, first draft) + technical writer; PR reviewer (source: https://agilemodeling.com/essays/agileDocumentation.htm) |
| 4 Verification | CI doc-quality results (Vale, link checks, previews) | CI automation; merge blocked on failure (source: https://vale.sh/) |
| 5 Review & Sign-off | Published docs, changelog / release notes | CI/CD publishes; reviewer sign-off (source: https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey) |
| 6 Maintenance & Living Docs | Living docs, drift-audit report | Technical writer / doc owner; periodic health review (source: https://ekline.io/blog/docs-as-code-engineering-teams) |

## Sources

- https://www.writethedocs.org/guide/docs-as-code/ — Docs as Code
- https://diataxis.fr/ — Diátaxis
- https://adr.github.io/ — Architectural Decision Records
- https://agilemodeling.com/essays/agileDocumentation.htm — Scott Ambler, Lean/Agile Documentation
- https://www.industrialempathy.com/posts/design-docs-at-google/ — Design Docs at Google
- https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey — Squarespace docs-as-code journey
- https://ekline.io/blog/docs-as-code-engineering-teams — Docs-as-code workflow, 5-step pipeline, 6 metrics (2026)
- https://developers.cloudflare.com/style-guide/ — Cloudflare Style Guide
- https://developers.cloudflare.com/style-guide/how-we-docs/ai-consumability/ — Cloudflare AI consumability
- https://developers.cloudflare.com/style-guide/documentation-content-strategy/content-types/ — Cloudflare content types
- https://developers.cloudflare.com/docs-for-agents/ — Cloudflare docs for agents
- https://agents.md/ — AGENTS.md open standard
- https://llmstxt.org/ — llms.txt proposal v2
- https://www.anthropic.com/engineering/claude-code-best-practices — Claude Code best practices
- https://developers.google.com/tech-writing — Google technical writing courses
- https://thegooddocsproject.dev/ — The Good Docs Project
- https://vale.sh/ — Vale prose linter
