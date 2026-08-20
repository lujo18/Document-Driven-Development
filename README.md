# Document Driven Development (DDD) Framework

> Mission (user-defined, do not drift): *"A production agentic framework for developing projects quicker and more completely."*

This is the **distribution repo** for a Document-Driven Development framework. It ships installable **skills, docs, scripts, and templates** that plug into any project so AI agents (OpenCode, Claude Code, etc.) can plan, build, and verify work faster and more completely. It is a framework/content delivery repo — not an application.

## What DDD is

Document-Driven Development means documenting what you're going to build **before** you build it, and letting that documentation drive design, tests, and code. The research library under `docs/research/` defines the methodology, the doc-driven pipeline, best practices, template skeletons, and agent-indexing conventions.

## Repository layout

    skills/      # 11 portable skills (one folder per skill, SKILL.md at its root)
    templates/   # 9 doc templates (copies on install; catalog.md is the manifest)
    scripts/     # install.sh — the dependency-free POSIX installer
    docs/        # install guide, ADRs, and the research library
    install.sh   # root shim → scripts/install.sh

## Quickstart

Install the framework into a consumer repo (run from this distribution root):

    sh install.sh --target /path/to/consumer-repo

For the non-interactive default (detected agent dirs, fallback `.opencode/` + `.claude/` + `.agents/`):

    sh install.sh --target /path/to/consumer-repo --yes

Windows: run under Git Bash or WSL; PowerShell/cmd is not supported in v1. See `docs/install.md`.

New to the framework? Run the copy-paste smoke test in `docs/install.md` to verify your clone.

## Documentation

- **Install guide** — `docs/install.md` (flags, agent-dir selection, symlink/copy matrix, uninstall, Windows note)
- **Research library index** — `docs/research/README.md` (read this first: what DDD is, the pipeline, best practices, templates, indexing)
- **Architecture decisions** — `docs/adr/0001-installer-mechanics.md`, `docs/adr/0002-skill-authoring-contract.md`, `docs/adr/0003-code-comment-indexing.md`
- **Template manifest** — `templates/catalog.md` (all 9 templates: target path, required params, used-by skill)

## License / usage

The framework installs into the project (per-agent directories); no global install by default. No build system or runtime is required — shell-first, dependency-free.
