# 0004 Publish-Readiness Package

<!-- Materialized from templates/adr.md per the DDD build plan §10 (D-BLD-16). -->

> **Status:** accepted

- **Date:** 2026-08-15
- **Number:** 0004
- **Decision-makers:** architect + coder

## Context

The framework's v1 distributable is built and gated, but the repo is not publish-ready: it carries no license, no VCS hygiene files, no first-commit checklist, and the installer's path handling is not hardened against hostile or malformed manifest input. The repo is not a git repo and never initialized one; publishing requires a license, root-file hygiene, exec-bit readiness, and an installer that cannot be tricked into touching paths outside the consumer root.

## Decision

- **License:** ship `LICENSE` with standard MIT text; copyright line exactly `Copyright (c) 2026 Document Driven Development contributors`.
- **AGENTS.md root-minimal exception:** the root may additionally hold `LICENSE`, `.gitignore`, `.gitattributes`; any other root file requires an ADR.
- **One-time frozen research unfreeze:** `docs/research/06-templates-roadmap-design-feature.md` and `10-references.md` are edited once to replace the developer-specific absolute path `C:\Users\asplo\.agents\skills\` with the portable `~/.agents/skills/`; line counts preserved (292 / 130); no other research edits.
- **Containment guard:** every path the installer acts on (manifest entries, uninstall targets, agent dirs) is validated to stay within the canonical consumer target before any destructive action.
- **Agent-dir validation:** interactive agent-directory answers are validated against `[a-z0-9_.-]`; invalid tokens are warned and skipped; empty-after-filter falls back to detected/default dirs.
- **DDD: header:** `scripts/install.sh` gains the framework's `DDD:` module-header convention on line 2; the root shim is exempt.
- **DIR: empty-dir sweep semantics:** pre-existing empty directories listed in the manifest may be removed by `rmdir` during uninstall (deepest-first); the sweep is dry-run aware.
- **Exec-bit first-commit checklist:** maintainers run `git update-index --chmod=+x install.sh scripts/install.sh` after `git init`; `chmod +x` is attempted but not relied on for the commit.

## Options Considered

- **No license / no hygiene files** — rejected: blocks publishing; consumers cannot legally reuse or contribute.
- **Keep absolute developer path in research** — rejected: breaks clones on other machines; publishing requires portability.
- **Unvalidated uninstall (trust manifest verbatim)** — rejected: a tampered or stale manifest could remove files outside the consumer root; containment guard is mandatory.
- **Trust `readlink -f` for canonicalization** — rejected: not POSIX; the guard uses `cd -P` / `pwd -P` instead.

## Rationale

Publishing requires legal + hygiene files at the root, so the root-minimal rule needs a documented exception (this ADR). Research portability is a correctness issue for consumers cloning the repo. The containment guard and agent-dir validation make the installer safe against malicious or malformed input while preserving the existing K4 semantics (no-clobber, idempotency, symlink-first with copy fallback).

## Consequences

- **Positive:** repo is publish-ready (license, hygiene, exec-bit checklist); installer cannot escape the consumer root; research paths are portable; empty dirs created by install are cleanly removed on uninstall.
- **Negative:** one-time frozen-research edit requires explicit sign-off; the containment guard adds complexity to the installer; pre-existing empty dirs may be removed during uninstall (documented semantics).
- **Follow-ups:** run the first-commit checklist (git init + exec-bit update-index) at publish; a future validate.sh (X3) may automate manifest-path validation.

## Supersession

- **Supersedes:** none
- **Superseded by:** none
- **Links:** `docs/plans/ddd-build-festival-file.md` §3, §10 (D-BLD-16, N-BLD-12); `AGENTS.md` (root-minimal exception); `scripts/install.sh` (DDD: header, containment guard, DIR: sweep); `docs/install.md` (smoke test, first-commit checklist)
