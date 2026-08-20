# 0002 Skill Authoring Contract

<!-- Materialized from templates/adr.md per docs/plans/ddd-build-festival-file.md §10
     (D-BLD-2, D-BLD-3, D-BLD-6, D-BLD-7; OQ2/OQ3 resolutions). -->

> **Status:** accepted

- **Date:** 2026-08-15
- **Number:** 0002
- **Decision-makers:** architect + coder; **PENDING USER CONFIRMATION** (OQ2/OQ3)

## Context

The framework ships portable skills consumed by OpenCode, Claude Code, and generic `.agents` setups. OQ2 asked which agent ecosystems get first-class support and which directories the installer populates. OQ3 asked whether the working name "Document Driven Development (DDD)" is final. Skills must route on `description` alone and stay portable across agent products (AGENTS.md invariant 4).

## Decision

- First-class agent dirs: `.opencode/` + `.claude/` + `.agents/`; `.cursor/` is installed only when already present ("as applicable") (D-BLD-2).
- Keep the working name "Document Driven Development (DDD)" for v1; renaming is cosmetic and must not block the build (D-BLD-3).
- Skill folders ship `SKILL.md` only — no per-skill `references/` dirs; shared material lives in `templates/*`, which the installer copies into the consumer repo (D-BLD-6).
- Frontmatter is `name` + single-line `description` ≤1024 chars; `when_to_use` optional but combined description+when_to_use ≤1536 chars; no other frontmatter fields (D-BLD-7).

## Options Considered

- **All four dirs first-class** — rejected: `.cursor/` consumes surface for a non-documented v1 consumer; "as applicable" per AGENTS.md.
- **Per-ecosystem skill variants / per-agent trimmed descriptions** — rejected: violates "no per-agent proprietary formats" and portability (D-BLD-7 keeps one portable SKILL.md under the stricter 1024 cap).
- **Per-skill `references/` folders** — rejected (D-BLD-6): dedup rule (point, don't copy) and one source of truth in `templates/*`.

## Rationale

AGENTS.md requires skills be agent-portable and not depend on one product's proprietary format. The stricter 1024-char description cap satisfies OpenCode and the Agent Skills spec simultaneously; a single portable SKILL.md serves all consumers.

## Consequences

- **Positive:** one portable SKILL.md per skill; shared material has a single home in `templates/*`; installer detection matrix is simple (`.cursor/` optional).
- **Negative:** descriptions must be written under the stricter cap (1024, not 1536); template content is a copy in each consumer repo, so template changes need re-install (skills remain live via symlink).
- **Follow-ups:** user ratifies OQ2/OQ3 at batch-E kickoff; rename later = root README + `docs/install.md` wording only.

## Supersession

- **Supersedes:** none
- **Superseded by:** none
- **Links:** `docs/plans/ddd-build-festival-file.md` §4.1, §10 (OQ2/OQ3, D-BLD-2/3/6/7); `docs/research/07-agent-indexing.md` (description caps, SKILL.md frontmatter)

## Update (2026-08-15)

D-BLD-14 (OQ2 ratified with modification 2026-08-15): agent-directory selection is done interactively at install time — the installer detects `.opencode/`, `.claude/`, `.agents/`, `.cursor/` and prompts for which to install to (detected dirs shown as defaults); `--yes` uses detected dirs, falling back to `.opencode/` + `.claude/` + `.agents/`; `.cursor/` is only ever used when present or explicitly chosen. This supersedes D-BLD-2's fixed first-class matrix wording. D-BLD-2 stands only as the fallback set.
