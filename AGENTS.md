# AGENTS.md — Document Driven Development (DDD) Framework

> Mission (user-defined, do not drift): *"A production agentic framework for developing projects quicker and more completely."*

This repo is the **distribution repo** for a Document-Driven Development framework. It ships installable **skills, docs, scripts, and templates** that plug into *any* user's project so their AI agents (OpenCode, Claude Code, etc.) can plan, build, and verify work faster and more completely. It is a framework/content delivery repo, **not** an application.

## Invariants (do not violate)

1. **No new harness, no runtime dependencies.** The framework plugs into the user's existing agent setup. Nothing may require the consumer project to adopt a build system, package manager, or runtime. Keep the repo's own tooling dependency-free (shell-first).
2. **Everything installs into the project.** A single install script copies/symlinks skills, docs, scripts, and templates into the user's repo (per-agent directories such as `.opencode/`, `.claude/`, `.agents/`, `.cursor/` as applicable). No global install by default.
3. **Plain Markdown is the source of truth.** Docs are `.md` files in `docs/`. There is deliberately no docs-site generator, no MDX, no rendered docs.
4. **Skills are agent-portable.** Each skill is a folder with a `SKILL.md` at its root (frontmatter `name` + `description`, markdown body — the format OpenCode / Claude Code read directly). Do not depend on one agent product's proprietary format without a documented decision in `docs/`.

## Document-driven rules (dogfood the framework here)

- **Docs lead, code follows.** No feature or artifact is built until its doc exists under `docs/`. Behavior changes update the related docs **in the same change**.
- Every skill, script, and template must be discoverable — referenced from a doc or manifest explaining what it is and when to use it.
- Update this `AGENTS.md` whenever a convention (layout, install flow, skill format) changes.

## Repository layout (foundation — build toward it)

```
skills/      # Distributable skills: one folder per skill, SKILL.md at its root
docs/        # Framework docs: philosophy, conventions, ADRs (architecture decisions)
scripts/     # Installer + validation utilities (dependency-free, idempotent)
templates/   # Scaffolding installed into user projects
```

- Keep root-level files minimal: README + the install entrypoint (`install.sh`).
- Publish-readiness exception (ADR 0004): the root may additionally hold `LICENSE`, `.gitignore`, `.gitattributes`; any other root file requires an ADR.
- Scripts: POSIX-sh oriented, no dependencies, idempotent, and each documented in `docs/`.

## Decisions to settle early (gotchas)

- **Platform portability:** the consumer set is "any repo" (macOS/Linux first). Development happens on Windows (win32) — if Windows consumers are in scope, plan a PowerShell install variant or document Windows as unsupported in the install README.
- **Symlink vs copy:** decide per artifact type — skills can be symlinks (live updates); templates and scripts must be **copies**.
- **Overwrite safety:** the installer must never clobber existing user files without explicit confirmation; installs must be repeatable (idempotent).

## Engagement rules

- Do **not** scaffold an application here (no `package.json` or framework boilerplate) unless a `docs/` ADR decides the installer tooling needs it.
- Don't invent commands — keep script names consistent (`install.sh`, future `validate.sh`) and document each new script in `docs/`.
