# 03-best-practices
> **Status:** done

## Purpose

**What:** Actionable best practices for doc-driven teams — doc hygiene, agent-friendly writing, process practices — plus the pitfalls that break them and the metrics that prove health. **When to read:** Writing or auditing documentation. **Not for:** DDD definition ([01-what-is-ddd](./01-what-is-ddd.md)) or pipeline mechanics ([02-ddd-flow](./02-ddd-flow.md)).

## TL;DR

- Treat docs as code: same tools, same PR, same CI — merged docs are published docs (source: https://www.writethedocs.org/guide/docs-as-code/).
- Structure by user need (Diátaxis), keep docs "Just Barely Good Enough", and prefer executable specs over static prose (source: https://diataxis.fr/; https://agilemodeling.com/essays/agileDocumentation.htm).
- Pair engineers and writers; use templates and a style guide (source: https://agilemodeling.com/essays/agileDocumentation.htm; https://thegooddocsproject.dev/; https://developers.google.com/tech-writing).
- Gate docs in CI with Vale-style prose linting and link checks (source: https://vale.sh/).
- Write agent-facing docs (AGENTS.md/CLAUDE.md) and keep them brutally concise (source: https://agents.md/; https://www.anthropic.com/engineering/claude-code-best-practices).
- Make docs AI-consumable: Markdown + llms.txt can cut input tokens ~7x (source: https://developers.cloudflare.com/style-guide/how-we-docs/ai-consumability/).
- Top failure modes: doc rot, waterfall delivery, the comprehensive-docs fallacy, bloated agent files, and stale docs feeding AI answers (sources below).
- Health is measurable: drift rate, repeated tickets, TTFC, stale pages, AI answer accuracy (source: https://ekline.io/blog/docs-as-code-engineering-teams).

## Doc Hygiene

- **4. Use plain Markdown + diagrams-as-code** (e.g., Mermaid) so diagrams are versioned and reviewable in diffs (source: https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey).
- **5. Structure docs by user need (Diátaxis)**: tutorials, how-tos, reference, explanation (source: https://diataxis.fr/).
- **6. Adopt a documented content taxonomy** (concept/how-to/tutorial/reference/troubleshooting/changelog/FAQ) (source: https://developers.cloudflare.com/style-guide/documentation-content-strategy/content-types/).
- **9. Practice "Just Barely Good Enough" (JBGE) documentation**: as simple as possible while fulfilling its purpose; "documentation should be concise: overviews/roadmaps are generally preferred over detailed documentation" (source: https://agilemodeling.com/essays/agileDocumentation.htm).
- **11. Prefer executable specifications over static prose** for behavioral requirements (source: https://agilemodeling.com/essays/agileDocumentation.htm).
- **14. Use templates** to remove writer's block and enforce structure (source: https://thegooddocsproject.dev/).
- **15. Standardize a style guide** and offer training — Google trains every engineer in technical writing (source: https://developers.google.com/tech-writing; https://developers.cloudflare.com/style-guide/).

## Agent-Friendly Writing

- **21. Write agent-facing docs**: AGENTS.md for instructions (build, test, style, security), nested per package for monorepos; agents read the nearest file (source: https://agents.md/).
- **22. Keep CLAUDE.md/AGENTS.md brutally concise**: include only what changes behavior — "If Claude keeps doing something you don't want despite having a rule against it, the file is probably too long" (source: https://www.anthropic.com/engineering/claude-code-best-practices).
- **23. Give agents a way to verify work** (tests, build, screenshots) so "done" is determined by a check, not assertion (source: https://www.anthropic.com/engineering/claude-code-best-practices).
- **24. Make docs AI-consumable**: publish Markdown versions + `llms.txt`/`llms-full.txt` indexes; Markdown can cut input tokens ~7x vs HTML (15,229 → 2,110 tokens for one Cloudflare page) (source: https://developers.cloudflare.com/style-guide/how-we-docs/ai-consumability/).
- **25. Design for progressive disclosure**: agents start from a small index (llms.txt) and fetch detail behind links only when needed; metadata like file names, folders, timestamps are context signals (source: https://llmstxt.org/; https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents).

See [07-agent-indexing](./07-agent-indexing.md) for the indexing conventions behind these rules.

## Process Practices

- **1. Treat docs as code**: same tools — issue trackers, Git, plain-text markup, code review, automated tests (source: https://www.writethedocs.org/guide/docs-as-code/).
- **2. One PR for code + docs**: review both together; optionally block merge of features that lack docs (source: https://www.writethedocs.org/guide/docs-as-code/).
- **3. Store docs next to code in the repo**, not a separate wiki (source: https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey).
- **7. Write design docs before ambiguous work**: goals/non-goals, alternatives considered, cross-cutting concerns; 10–20 pages, or 1–3 for mini-docs; "choose wisely" — not every change needs one (source: https://www.industrialempathy.com/posts/design-docs-at-google/).
- **8. Record decisions as ADRs** — one decision per record with rationale and consequences (source: https://adr.github.io/).
- **10. Document stable things, not speculative things**; write docs only when information has stabilized, "a few iterations behind" the code if necessary; update only when it hurts (source: https://agilemodeling.com/essays/agileDocumentation.htm).
- **12. Treat documentation cost as a business decision**: stakeholders must understand the TCO of a document and explicitly choose to invest (source: https://agilemodeling.com/essays/agileDocumentation.htm).
- **13. Pair engineers and writers**: developer does the knowledge dump, writer refactors; best when they write together (source: https://agilemodeling.com/essays/agileDocumentation.htm).
- **16. Put doc quality gates in CI**: prose linting (Vale), broken-link checks, style/terminology rules; blocking where high-risk (source: https://vale.sh/; GitLab runs "82 rules across all 2,827 pages... in under twenty seconds").
- **17. Provide preview environments for doc changes** (local CLI + staging branch) (source: https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey).
- **18. Auto-publish docs through CI/CD** into a central developer portal (e.g., Backstage) so merged = findable (source: https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey).
- **19. Run a detect→classify→draft→review→measure workflow** rather than ad-hoc doc writing; the failures that matter are detection and review, not drafting (source: https://ekline.io/blog/docs-as-code-engineering-teams).
- **20. Measure docs health with a small stable metric set** (see Metrics & Signals) (source: https://ekline.io/blog/docs-as-code-engineering-teams).

## Pitfalls & Anti-Patterns

| Pitfall | What breaks | Source |
|---|---|---|
| Docs in a separate tool/format from code | Disjointed workflows, no shared review; "outdated documentation... undermines trust in them" | https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey |
| Waterfall doc delivery | Docs updated in bulk, rarely — at odds with incremental delivery | https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey |
| Comprehensive-docs fallacy | "comprehensive documentation... increases your chance of failure"; more docs ≠ more success | https://agilemodeling.com/essays/agileDocumentation.htm |
| Trust gap | "developers rarely trust the documentation, particularly detailed documentation because it's usually out of sync with the code" | https://agilemodeling.com/essays/agileDocumentation.htm |
| Documenting speculation too early | Rework cost grows as requirements churn | https://agilemodeling.com/essays/agileDocumentation.htm |
| Design docs that never get updated | Shipped systems diverge; "the US constitution with a bunch of amendments" unless amendment links kept | https://www.industrialempathy.com/posts/design-docs-at-google/ |
| Design docs as implementation manuals | Describing *how* without trade-offs; write the program instead | https://www.industrialempathy.com/posts/design-docs-at-google/ |
| Review theater | Heavyweight formal design reviews slow teams | https://www.industrialempathy.com/posts/design-docs-at-google/ |
| Docs-for-control culture | Negative ROI; docs to be "seen to be in control" | https://agilemodeling.com/essays/agileDocumentation.htm |
| Docs as the primary communication channel | "The fundamental issue is communication, not documentation"; docs are a poor live-conversation tool | https://agilemodeling.com/essays/agileDocumentation.htm |
| Bloated agent instruction files | Over-long CLAUDE.md/AGENTS.md makes agents ignore instructions | https://www.anthropic.com/engineering/claude-code-best-practices |
| Context rot for agents | As tokens grow, models recall worse; treat context as a finite resource | https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents |
| Stale docs feeding AI answers | "a wrong doc page can now fail in 4 places at once" — readers, support, enterprise evals, AI assistants | https://ekline.io/blog/docs-as-code-engineering-teams |
| No review gate | "low-quality docs merge; docs quality becomes cleanup work" | https://ekline.io/blog/docs-as-code-engineering-teams |
| No measurement | "if nobody can see which pages are wrong... no workflow owns the correction" | https://ekline.io/blog/docs-as-code-engineering-teams |
| Copying verbose schemas/API defs into docs | "quickly get out of date"; summarize the design-relevant parts instead | https://www.industrialempathy.com/posts/design-docs-at-google/ |

## Metrics & Signals

| Metric | What it measures | Healthy direction | Source |
|---|---|---|---|
| Docs drift rate | Pages where docs disagree with product behavior; track weekly or per release | Down | https://ekline.io/blog/docs-as-code-engineering-teams |
| Repeated ticket count | Questions support answers more than 3× | Down | https://ekline.io/blog/docs-as-code-engineering-teams |
| Time-to-first-call (TTFC) | Time from opening docs to first successful API call | Down | https://ekline.io/blog/docs-as-code-engineering-teams |
| Docs PR cycle time | Time from detected gap to merged update | Down | https://ekline.io/blog/docs-as-code-engineering-teams |
| Engineering hours reclaimed | Hours engineers stop spending on first-draft docs | Up | https://ekline.io/blog/docs-as-code-engineering-teams |
| AI answer accuracy | Priority questions where ChatGPT/Claude/etc. describe the product correctly | Up | https://ekline.io/blog/docs-as-code-engineering-teams |
| Stale pages per release | Docs lagging behind releases — earliest signal of a broken workflow | Down | https://ekline.io/blog/docs-as-code-engineering-teams |
| CI quality signals | Lint errors/warnings per PR (Vale), broken links, style violations; blocking where high-risk | Down | https://vale.sh/ |
| Automation/coverage signals | Docs kept "version controlled, reviewed, tested, and deployed automatically" | Maintained | https://docs.gitscrum.com/en/best-practices/documentation-as-code |
| Adoption/behaviors | Mindshare and contribution rates — easy, ongoing contributions | Ongoing | https://www.writethedocs.org/guide/writing/mindshare/ |
| AI-side freshness | `llms.txt`/`llms-full.txt` reflect current pages; deprecated pages noindexed | Current | https://developers.cloudflare.com/style-guide/how-we-docs/ai-consumability/ |
| Pilot baseline recipe | Pick 10 high-risk pages, 10 repeated support questions, 5 recent releases, 5 buyer questions; measure over a 30-day baseline | Baseline established | https://ekline.io/blog/docs-as-code-engineering-teams |

## Sources

- https://www.writethedocs.org/guide/docs-as-code/ — Docs as Code
- https://www.writethedocs.org/guide/writing/mindshare/ — Write the Docs mindshare
- https://diataxis.fr/ — Diátaxis
- https://adr.github.io/ — Architectural Decision Records
- https://agilemodeling.com/essays/agileDocumentation.htm — Scott Ambler, Lean/Agile Documentation
- https://www.industrialempathy.com/posts/design-docs-at-google/ — Design Docs at Google
- https://engineering.squarespace.com/blog/2025/making-documentation-simpler-and-practical-our-docs-as-code-journey — Squarespace docs-as-code journey
- https://ekline.io/blog/docs-as-code-engineering-teams — Docs-as-code workflow, 5-step pipeline, 6 metrics (2026)
- https://developers.cloudflare.com/style-guide/ — Cloudflare Style Guide
- https://developers.cloudflare.com/style-guide/how-we-docs/ai-consumability/ — Cloudflare AI consumability
- https://developers.cloudflare.com/style-guide/documentation-content-strategy/content-types/ — Cloudflare content types
- https://agents.md/ — AGENTS.md open standard
- https://llmstxt.org/ — llms.txt proposal v2
- https://www.anthropic.com/engineering/claude-code-best-practices — Claude Code best practices
- https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents — Anthropic context engineering
- https://developers.google.com/tech-writing — Google technical writing courses
- https://thegooddocsproject.dev/ — The Good Docs Project
- https://vale.sh/ — Vale prose linter
- https://docs.gitscrum.com/en/best-practices/documentation-as-code — Docs-as-code definition
