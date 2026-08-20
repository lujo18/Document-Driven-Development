# 0001 Installer Mechanics

<!-- Materialized from templates/adr.md per docs/plans/ddd-build-festival-file.md §10
     (D-BLD-1, D-BLD-8, D-BLD-9; OQ1 resolution). -->

> **Status:** accepted

- **Date:** 2026-08-15
- **Number:** 0001
- **Decision-makers:** architect + coder; **PENDING USER CONFIRMATION** (OQ1)

## Context

The framework must install into arbitrary consumer repos without a harness or runtime (AGENTS.md invariants 1–2). The dev host is Windows (win32) while the consumer set is "any repo" (macOS/Linux first, AGENTS.md portability gotcha). Install behavior must be safe (no clobber) and repeatable (idempotent). OQ1 asked: POSIX `install.sh` only, or also a PowerShell variant? Symlink vs copy per artifact type?

## Decision

- Ship POSIX-sh `install.sh` as the primary installer (shell-first, no deps); skills are symlinked, templates and scripts are **copies** (AGENTS.md symlink/copy decision).
- Windows is documented as unsupported in `docs/install.md`; a PowerShell `install.ps1` variant is deferred as future work (D-BLD-1).
- On symlink failure (MSYS/MINGW/CYGWIN), fall back to a copy **WITH a warning** — never silent (D-BLD-8).
- The installer writes `.ddd/manifest.txt` listing every path it created, so `--uninstall` removes exactly those paths and never pre-existing files (D-BLD-9).
- No runtime dependencies; every path quoted (repo path contains spaces).

## Options Considered

- **POSIX-sh `install.sh` only** — chosen: matches AGENTS.md shell-first, macOS/Linux first.
- **PowerShell `install.ps1`** — rejected for v1: dev-on-Windows ≠ consumer-on-Windows; deferred as future work, documented in `docs/install.md`.
- **Copy everything (no symlinks)** — rejected: skills must get live updates across installs; symlink/copy matrix is per artifact type per AGENTS.md.

## Rationale

AGENTS.md is explicit: shell-first tooling, macOS/Linux first, symlinks for skills (live updates), copies for templates/scripts, no clobber without confirmation, idempotent. D-BLD-8 makes platform degradation honest; D-BLD-9 makes uninstall safe.

## Consequences

- **Positive:** dependency-free install; safe and repeatable; Windows documented, not silently broken.
- **Negative:** Windows consumers need Git Bash/WSL or a POSIX host; no live updates for skills when copy fallback triggers.
- **Follow-ups:** user ratifies OQ1 at batch-E kickoff; `install.ps1` tracked as future work; `docs/install.md` documents flags and Windows-unsupported note.

## Supersession

- **Supersedes:** none
- **Superseded by:** none
- **Links:** `docs/plans/ddd-build-festival-file.md` §4.3, §10 (OQ1, D-BLD-1/8/9); `docs/research/08-skills-to-build.md` (ddd-install)
