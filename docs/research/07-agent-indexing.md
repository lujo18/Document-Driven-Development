# 07-agent-indexing
> **Status:** done

## Purpose

**What:** How agents discover and load docs — llms.txt, AGENTS.md, SKILL.md frontmatter, index files, token-efficient writing — so a markdown library is cheap to search. **When to read:** Designing or maintaining the docs tree. **Not for:** ADR/issue templates ([04-templates-adr](./04-templates-adr.md), [05-templates-issues](./05-templates-issues.md)) or planning artifacts ([06-templates-roadmap-design-feature](./06-templates-roadmap-design-feature.md)).

## TL;DR

- Progressive disclosure is universal: every major coding agent loads a *small* fixed set of context up front and pulls detail on demand (source: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills).
- OpenCode reads `AGENTS.md` first; Claude Code reads `CLAUDE.md` (not `AGENTS.md` natively — use an `@AGENTS.md` import); Cursor uses `.cursor/rules/*.mdc`; generic agents fall back to glob/grep (sources below).
- llms.txt is the web/docs-site index contract (v2, Aug 2026): small, curated, links to markdown pages, "the detail lives behind the links" (source: https://llmstxt.org/).
- SKILL.md routing = frontmatter `name` + `description` (what + when + triggers); caps: 1,024 chars (OpenCode/spec) and 1,536 combined (Claude Code); body < 500 lines (sources below).
- README-as-index and MEMORY.md-style "index + topic files" keep the entry point small and discovery cheap (source: https://code.claude.com/docs/en/memory).
- Context is scarce: CLAUDE.md < 200 lines, rules < 500 lines, RAG chunks ~a few hundred tokens; TL;DR-first, one-topic-per-file, dedup by linking (sources below).
- Search verdict: plain markdown + curated index + grep; defer embeddings.

## llms.txt

- **Spec.** Proposal by Jeremy Howard (Sep 2024), **v2 Aug 2026**: an `llms.txt` at site root or any subpath; H1 title (only required part), optional blockquote summary, free markdown detail sections, then H2 "file lists" of `[name](url): notes` links to **markdown** versions of pages; conventional `Optional` section for skippable secondary links; where multiple files apply, "the most specific one" wins (source: https://llmstxt.org/).
- **v2 changes.** Added discoverability link relations (`rel="alternate" type="text/markdown"`, `rel="describedby"`) and blessed both `.md`-appended and extension-replaced markdown URLs (source: https://llmstxt.org/changes.html).
- **Adoption.** Thousands of sites publish it; Mintlify generates it per docs site; GitBook, Yoast SEO and AIOSEO (WordPress), Wix ship generators; OpenAI, Anthropic and Gemini publish llms.txt for their own dev docs (source: https://llmstxt.org/). Chrome Lighthouse added an *agentic browsing* audit that flags servers failing to serve `llms.txt` (404 = Not Applicable since optional) (source: https://developer.chrome.com/docs/lighthouse/agentic-browsing/llms-txt). Repo: 2.6k stars / 160 forks / 73 open issues (source: https://github.com/AnswerDotAI/llms-txt).
- **vs sitemap/robots.** Sitemaps enumerate everything; llms.txt is a *curated* overview for on-demand agent inference. Sitemap is a poor substitute: often lacks LLM-readable page versions, excludes helpful external URLs, exceeds context in aggregate (source: https://llmstxt.org/). robots.txt governs access; llms.txt supplies context (source: https://llmstxt.org/).
- **Docs-sites contract.** Anthropic's own docs prepend every page with a block: "Fetch the complete documentation index at https://…/llms.txt — use this file to discover all available pages before exploring further" (observed at: https://code.claude.com/docs/en/memory and https://agentskills.io/).
- **Convention, not a ratified standard.** Chrome calls it an "emerging convention"; v1→v2 breaks are documented (markdown URL forms, subpath semantics, removal of expansion tooling and the mechanical meaning of `Optional`) — adopters must expect drift (source: https://developer.chrome.com/docs/lighthouse/agentic-browsing/llms-txt; https://llmstxt.org/changes.html).

**Example (source: https://llmstxt.org/):**

    # Example Docs

    > Summary of what this documentation covers.

    ## Docs

    - [Quickstart](quickstart.md): First five minutes.
    - [Reference](reference.md): API and configuration details.

    ## Optional

    - [Changelog](changelog.md): Not needed for most tasks.

## AGENTS.md / per-agent dirs

- **OpenCode — AGENTS.md first.** Injects `AGENTS.md` (found walking up from the working directory) into context, plus optional `instructions` files/URLs declared in `opencode.json`. Load order: local `AGENTS.md`/`CLAUDE.md` (traversing up) → `~/.config/opencode/AGENTS.md` → `~/.claude/CLAUDE.md` fallback; first match wins per category (source: https://opencode.ai/docs/rules/). Skills discovered from `.opencode/skills/<name>/SKILL.md`, `.claude/skills/`, `.agents/skills/` (project and global) (source: https://opencode.ai/docs/skills/). OpenCode advertises *references* (external dirs/repos) to agents only when they have a `description` (source: https://opencode.ai/docs/references/).
- **Claude Code — CLAUDE.md, not AGENTS.md.** Loads `CLAUDE.md` / `.claude/CLAUDE.md` (walking up the tree, concatenated, plus `.claude/rules/*` at launch) into every session; does **not** natively read `AGENTS.md` — documented pattern is a `CLAUDE.md` containing `@AGENTS.md` import or a symlink (source: https://code.claude.com/docs/en/memory). Auto-memory: a `MEMORY.md` index capped at **first 200 lines or 25 KB**, with detail in topic files read on demand (source: https://code.claude.com/docs/en/memory). Skills in `.claude/skills/<name>/SKILL.md` listed via metadata; body loads only when used (source: https://code.claude.com/docs/en/skills).
- **Cursor — rules with frontmatter + AGENTS.md.** Applies rules in order Team → Project → User; project rules in `.cursor/rules/*.mdc` with frontmatter (`description`, `globs`, `alwaysApply`) controlling application; a plain `.md` in `.cursor/rules` is ignored — use `AGENTS.md` instead for plain markdown (source: https://cursor.com/docs/context/rules). Skills load from `.agents/skills/`, `.cursor/skills/`, plus Claude/Codex compatibility dirs; only `name` + `description` surfaced until relevance determined (source: https://cursor.com/docs/context/skills).
- **AGENTS.md — "a README for agents."** Open format (stewarded by the Agentic AI Foundation under the Linux Foundation, after originating across Codex/Amp/Jules/Cursor/Factory): deliberately plain Markdown with **no required fields**, so READMEs stay human-focused while AGENTS.md holds build steps, tests, conventions, gotchas. Used by 60k+ open-source projects; nested AGENTS.md files apply nearest-to-the-file (OpenAI's repo reportedly has 88) (source: https://agents.md/). It's a *convention*, not a formal spec — each tool decides reading semantics (source: https://opencode.ai/docs/rules/).
- **Recommended content** (per OpenCode `/init`): build/lint/test commands, command order and focused verification, non-obvious architecture/repo structure, project conventions and gotchas, references to existing instruction sources (source: https://opencode.ai/docs/rules/). Claude Code equivalent: bash commands agents can't guess, style rules differing from defaults, testing instructions, repo etiquette, architectural decisions, env quirks, gotchas; exclude anything derivable from code, standard conventions, detailed API docs, long tutorials, file-by-file descriptions (source: https://code.claude.com/docs/en/best-practices).
- **Generic search (no tool-specific file).** Agents fall back to `glob`/`grep`/`list` just-in-time; primitives "effectively bypass the issues of stale indexing" (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents). File naming, folder hierarchy, timestamps are themselves "signals that help both humans and agents understand how and when to utilize information" (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents).
- **Instruction-file conflicts.** Nearest-file wins in AGENTS.md (source: https://agents.md/), but Claude Code: "if two rules contradict each other, Claude may pick one arbitrarily" — period pruning and `claudeMdExcludes` for monorepos are the mitigations (source: https://code.claude.com/docs/en/memory). Always-apply context is advisory, not enforced; hooks/settings are the enforcement layer (source: https://code.claude.com/docs/en/memory).

**Concrete rules for a DDD framework distribution repo:**
- 1. Ship one root contract the agent must read first (root AGENTS.md stating "Agents must always start at docs/README.md (the index)"; ≤200 lines, CLI-command-first).
- 10. Claude Code interop: `CLAUDE.md` containing `@AGENTS.md` import, not a duplicated copy.

## SKILL.md Frontmatter

- **Frontmatter metadata is the routing layer.** For skills, `name` + `description` (the discovery pair) must let agents decide relevance: OpenCode recognizes only `name`, `description`, `license`, `compatibility`, `metadata` — unknown fields ignored; name must match `^[a-z0-9]+(-[a-z0-9]+)*$`, match the folder, description ≤ 1024 chars (source: https://opencode.ai/docs/skills/).
- Agent Skills spec: description states *what + when to use*, includes trigger keywords; `compatibility` ≤ 500 chars; `metadata` is a free string map (source: https://agentskills.io/specification).
- Claude Code extends with `when_to_use` (trigger phrases) but caps the combined listing at **1,536 chars** (source: https://code.claude.com/docs/en/skills).
- Cursor uses same name/description plus `paths` glob scoping and `disable-model-invocation` (source: https://cursor.com/docs/context/skills).
- **Trigger phrases are real routing data** — e.g. "Use when the user mentions PDFs, forms, or document extraction" (source: https://agentskills.io/specification); "Use when deploying code or when the user mentions deployment, releases, or environments" (source: https://cursor.com/docs/context/skills). Write descriptions as if they are the agent's only map.
- **Agent Skills tiering.** Level 1 = skill `name` + `description` preloaded; level 2 = full instructions read only when a task matches; level 3 = bundled files read only when needed (source: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills). Agent Skills spec: metadata ≈ 100 tokens per skill, instructions < 5,000 tokens, resources as needed (source: https://agentskills.io/specification).

**Sample SKILL.md frontmatter (contract + sample):**

    ---
    name: pdf-extraction
    description: Extract text from PDFs, forms, and document files. Use when the
      user mentions PDFs, forms, or document extraction, or shares a document
      to process. Triggers: pdf, extract, forms.
    compatibility: opencode, claude, cursor
    metadata:
      license: MIT
    ---
    # PDF Extraction
    ## When to use
    - Any request to read, parse, or extract content from a document file.
    ## Inputs
    - File path(s) and any extraction options.
    ## Steps
    - 1. Detect document type.
    - 2. Extract text preserving structure.
    - 3. Return a condensed result.
    ## Outputs
    - Extracted text, page/section map, or a structured record.
    ## Verification
    - Sample fixture round-trips; no data loss on the tested formats.

**Concrete rules for a DDD framework distribution repo:**
- 4. Skills: one folder per skill, spec-valid frontmatter (`name` lowercase-hyphenated == folder; `description` ≤ 1,024 chars as what+when with triggers; body < 500 lines; references one level deep).
- 5. Frontmatter everywhere (title, description, status, tags) so grep/glob and future RAG can route by metadata.

## README-as-Index

- **README-as-index contract.** Effective pattern seen at code.claude.com, agentskills.io, cursor.com: (1) a canonical, small index file; (2) an explicit instruction in every doc ("agents must always use this first"); (3) index entries carry one-line descriptions so the agent can select before fetching (source: https://code.claude.com/docs/llms.txt; https://agentskills.io/; https://cursor.com/docs/context/rules).
- **MEMORY.md / index + topic files.** Claude Code's auto-memory: concise `MEMORY.md` entrypoint loaded every session, detail pushed to `topic.md` files read on demand; if `MEMORY.md` exceeds its read limit, writes still succeed but the agent is told to rewrite the index (source: https://code.claude.com/docs/en/memory).
- **Index staleness.** Curated indexes drift from actual files; live tools (glob/grep) "bypass the issues of stale indexing" (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents). Mitigations: auto-generated llms.txt (Mintlify, GitBook, Wix, Yoast), `/init`-style regeneration; a human-maintained README index must be treated as code with a refresh loop (source: https://llmstxt.org/; https://opencode.ai/docs/rules/).

**Concrete rules for a DDD framework distribution repo:**
- 2. Make `docs/README.md` a real index contract, not a prose welcome — llms.txt-like: H1, one-blockquote summary, grouped link lists `[title](path): one-line description`, optional tail.
- 3. Also ship `docs/llms.txt` (and consider root `llms.txt`) generated/kept in sync with the index; validation script fails CI when links point to missing files.
- 11. Treat the index as living code: update README + llms.txt in the same change as any doc add/move/rename; test the index by asking an agent a question with *only* the index as starting context.
- 12. Don't over-index: curated index of ~dozens of links fine; hundreds of eager instructions defeat the purpose.

## File Organization & Numbering

- **Shallow, numbered, greppable trees.** File/folder names are semantic signals agents read cheaply (a `tests/` folder implies a different purpose than `src/core_logic/`); prefer "lightweight identifiers (file paths, stored queries, web links)" over eager pre-loading (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents).
- **Nested, path-scoped content.** Claude Code supports *nested* CLAUDE.md/rules/skills per subdirectory and per monorepo package — nearest-scoped content loads when the agent touches that subtree (source: https://code.claude.com/docs/en/memory; https://code.claude.com/docs/en/skills). Cursor scopes nested `.cursor/skills/` automatically to their directory (source: https://cursor.com/docs/context/skills).
- **Path-scoped rules instead of everything-in-one-file.** Cursor: rules under 500 lines, split into composable rules, "reference files instead of copying their contents" (source: https://cursor.com/docs/context/rules). Claude Code: `.claude/rules/*.md` with `paths:` frontmatter load only when matching files are in context; rules without paths load at launch (source: https://code.claude.com/docs/en/memory). OpenCode achieves laziness by *instructing* the agent to load `@path` references on need-to-know basis (source: https://opencode.ai/docs/rules/).
- **Numeric prefixes.** Not prescribed by any primary source — the principle "encode purpose in the name" is; order-signaling prefixes are a consistent extension used by docs-as-code orgs (source: https://diataxis.fr/).
- **Doc maps by audience/need, not by author convenience.** Diátaxis: tutorials, how-to guides, technical reference, explanation — organized around the structures of user *needs* (source: https://diataxis.fr/). For agent consumption: index = map, reference = terse facts, how-to = procedures (skills), explanation = background.
- **Cross-linking as navigation, not duplication; watch depth.** llms.txt links point to LLM-friendly markdown with "brief, informative descriptions" so the agent can choose before fetching; the file stays small enough to fit in context, "the detail lives behind the links" (source: https://llmstxt.org/). Skills standard keeps referenced files one level deep from `SKILL.md`, avoids "deeply nested reference chains" (source: https://agentskills.io/specification). Claude Code import depth for `@path` capped at 4 hops (source: https://code.claude.com/docs/en/memory).

**Concrete rules for a DDD framework distribution repo:**
- 6. Keep docs small and section-scoped: one topic per file; self-contained chunks; < ~500 lines per doc; big topics get a folder with its own small index.
- 9. Scope instructions by path, not by pile (nested AGENTS.md/rules per area).

## Token-Efficient Writing Style

- **Context is the scarcest resource; size is a correctness issue.** "the context window is the most important resource to manage"; bloated CLAUDE.md files cause Claude to ignore instructions; per-line test: "Would removing this cause Claude to make mistakes? If not, cut it" (source: https://code.claude.com/docs/en/best-practices). "find the smallest possible set of high-signal tokens that maximize the likelihood of some desired outcome" (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents). Long-context models suffer *context rot* — recall degrades as tokens pile up (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents).
- **Size limits that actually exist.** CLAUDE.md: "target under 200 lines per file" (source: https://code.claude.com/docs/en/memory). Auto-memory index: 200 lines / 25 KB hard cap (source: https://code.claude.com/docs/en/memory). Skills: description ≤ 1,024 chars (spec); combined description+when_to_use truncated at 1,536 (source: https://code.claude.com/docs/en/skills); "keep the body itself concise — once a skill loads, its content stays in context across turns" (source: https://code.claude.com/docs/en/skills); SKILL.md "under 500 lines" with references split out (source: https://agentskills.io/specification). Cursor rules: under 500 lines (source: https://cursor.com/docs/context/rules). RAG chunks: "usually no more than a few hundred tokens" (source: https://www.anthropic.com/engineering/contextual-retrieval).
- **TL;DR-first / tiered structure.** llms.txt template is itself tiering: blockquote summary → detail sections → link lists, with an `Optional` tier (source: https://llmstxt.org/). Skills spec recommended sections: step-by-step instructions, examples, common edge cases (source: https://agentskills.io/specification).
- **Section-per-file / one-topic-per-file granularity.** Claude Code `.claude/rules/`: "Each file should cover one topic, with a descriptive filename like `testing.md` or `api-design.md`" (source: https://code.claude.com/docs/en/memory). Skills: split an unwieldy SKILL.md into referenced files; "if certain contexts are mutually exclusive or rarely used together, keeping the paths separate will reduce the token usage" (source: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills). Markdown headings are the natural chunk boundary (source: https://www.pinecone.io/learn/chunking-strategies/).
- **Deduplication: point, don't copy.** Cursor: "Duplicating what's already in your codebase" is an explicit anti-pattern — "point to canonical examples instead of copying code" (source: https://cursor.com/docs/context/rules). Claude Code: import once via `@path`, don't restate; `/doctor` proposes trims of content Claude can derive from the codebase (source: https://code.claude.com/docs/en/memory; https://code.claude.com/docs/en/best-practices).
- **Summarize at the boundaries.** Subagents "explore extensively… but return only a condensed, distilled summary (often 1,000–2,000 tokens)"; structured notes (NOTES.md / MEMORY.md) persist state without holding it in context (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents; https://www.anthropic.com/engineering/multi-agent-research-system). **Token cost of subagents isn't free:** multi-agent/multi-file exploration burns ~4× (agents) to ~15× (multi-agent) tokens vs chat (source: https://www.anthropic.com/engineering/multi-agent-research-system).
- **Chunking-friendly markdown (RAG prep).** Keep sections self-contained so a chunk "makes sense without the surrounding context to a human… then it will make sense to the language model as well" (source: https://www.pinecone.io/learn/chunking-strategies/). Anthropic Contextual Retrieval: prepend a 50–100-token situating context to each chunk — cutting retrieval failure by 49% (67% with reranking); if a knowledge base is under ~200k tokens, skip RAG and dump it in the prompt (source: https://www.anthropic.com/engineering/contextual-retrieval).
- **Token cost of too many files.** Skills are cheap to *list* (metadata only, ~100 tokens each) but expensive to *activate* — every loaded body stays in context "across turns" (source: https://code.claude.com/docs/en/skills; https://agentskills.io/specification). "bloated tool sets that cover too much functionality or lead to ambiguous decision points" is a named failure mode (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents).

**Concrete rules for a DDD framework distribution repo:**
- 7. Tier every doc: TL;DR → detail (blockquote summary + 3–5 bullets first; explicit "Optional" section for background).
- 8. Deduplicate: link, don't copy — one canonical definition per concept.

## Search Strategy

- **(a) Keyword / grep / glob — the default.** Cheap, dependency-free, never stale — primitives "effectively bypass the issues of stale indexing"; the primary strategy for a plain-markdown repo (source: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents; https://opencode.ai/docs/rules/).
- **(b) Embeddings / RAG — only at scale.** Needed when the corpus exceeds ~200k tokens or fuzzy semantic recall is required; chunk by markdown headings (the natural boundary), contextualize each chunk with a 50–100-token prepend (cuts retrieval failure 49%; 67% with reranking); if < ~200k tokens, dump the corpus in the prompt instead (source: https://www.anthropic.com/engineering/contextual-retrieval; https://www.pinecone.io/learn/chunking-strategies/).
- **(c) Hybrid.** Curated index for discovery + grep for precision + fetch-behind-links for depth; llms.txt as the standard interchange for web-facing docs (source: https://llmstxt.org/).
- **RAG noise and retrieval failure.** "Context rot" and lost-in-the-middle degrade long-context recall; small chunks miss context, big chunks dilute signal (source: https://www.pinecone.io/learn/chunking-strategies/; https://www.anthropic.com/engineering/contextual-retrieval). A missing/404 `llms.txt` just makes agents crawl more — optional, so low coverage is the norm (source: https://developer.chrome.com/docs/lighthouse/agentic-browsing/llms-txt).
- **Verdict for this framework:** plain markdown + curated index + grep; defer embeddings (tracked as a deferred decision in [08-skills-to-build](./08-skills-to-build.md)).

## Sources

- https://llmstxt.org/ — llms.txt v2 spec
- https://llmstxt.org/changes.html — v2 changes
- https://github.com/AnswerDotAI/llms-txt — llms.txt repo
- https://developer.chrome.com/docs/lighthouse/agentic-browsing/llms-txt — Chrome Lighthouse llms.txt audit
- https://agents.md/ — AGENTS.md open format
- https://opencode.ai/docs/rules/ — OpenCode rules/AGENTS.md
- https://opencode.ai/docs/agents/ — OpenCode agents
- https://opencode.ai/docs/skills/ — OpenCode skills
- https://opencode.ai/docs/references/ — OpenCode references
- https://code.claude.com/docs/en/memory — Claude Code memory/CLAUDE.md
- https://code.claude.com/docs/en/skills — Claude Code skills
- https://code.claude.com/docs/en/best-practices — Claude Code best practices
- https://code.claude.com/docs/llms.txt — Claude Code live llms.txt index
- https://cursor.com/docs/context/rules — Cursor rules/AGENTS.md
- https://cursor.com/docs/context/skills — Cursor skills
- https://agentskills.io/ — Agent Skills standard
- https://agentskills.io/specification — Agent Skills specification
- https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents — Anthropic context engineering
- https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills — Anthropic Agent Skills
- https://www.anthropic.com/engineering/contextual-retrieval — Anthropic contextual retrieval
- https://www.anthropic.com/engineering/multi-agent-research-system — Anthropic multi-agent research
- https://www.anthropic.com/engineering — Anthropic engineering index
- https://www.pinecone.io/learn/chunking-strategies/ — Pinecone chunking strategies
- https://diataxis.fr/ — Diátaxis docs architecture
