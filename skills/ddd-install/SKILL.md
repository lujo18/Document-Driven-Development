---
name: ddd-install
description: Install the document-driven development framework into a consumer repository. Use when the user says install, setup, or bootstrap the framework, wants to run or repair an install, or asks about installer flags, uninstall, or which agent directories to use; runs scripts/install.sh against a consumer root, selects agent directories interactively (detected dirs as defaults), symlinks skills, copies templates and scripts, never clobbers without confirmation, and uninstalls exactly what the manifest lists. Triggers: install the framework, set up ddd, bootstrap this repo, install skills/docs/scripts, uninstall, dry run.
---
# Install

## When to use

- Consumer repo setup or re-run (idempotent repair).
- The user asks to install, setup, or bootstrap the framework.
- The user asks about flags, uninstall, or which agent dirs to use.
- Not for authoring docs or skills — this skill only installs the framework.

## Inputs

1. Consumer repo root (default: current directory; or `--target <dir>`).
2. Distribution root containing `scripts/install.sh`, `skills/`, `templates/` (default: repo containing the script; or `--dist <dir>`).
3. Mode: `--dry-run` (manifest only), `--yes` (non-interactive), `--force` (overwrite without prompt), `--uninstall`.
4. The authoritative installer: `scripts/install.sh`; install README: `docs/install.md`.

## Steps

1. Verify `scripts/install.sh` exists and is executable; run it from the consumer root (or `--target`).
2. Choose flags per intent: dry-run first to preview; `--yes` for non-interactive; `--force` only with explicit overwrite intent.
3. Confirm agent-directory selection: detect `.opencode/`, `.claude/`, `.agents/`, `.cursor/` under the target; present detected dirs as defaults and ask which to install to. Under `--yes`, use detected dirs, falling back to `.opencode/` + `.claude/` + `.agents/`; `.cursor/` only when present or explicitly chosen.
4. Confirm the manifest: every symlink (skills) and copy (templates + `scripts/install.sh`) listed before writing; never clobber pre-existing files without confirmation.
5. Run the install; verify `.ddd/manifest.txt` lists every created path and the README-note marker.
6. For uninstall: run `--uninstall`, which removes exactly what the manifest lists and never pre-existing files.

Runnable check after each step: the action taken matches the flag intent; a re-run of the same install produces zero changes (idempotent).

## Rules

- Never clobber or delete pre-existing files without explicit confirmation; `--yes` confirms; `--force` skips overwrite prompts only.
- Skills symlink (live updates); templates and `scripts/install.sh` copy (stable scaffolding).
- Windows: non-POSIX shells exit non-zero with a pointer to `docs/install.md`; on MSYS/MINGW/CYGWIN, symlink failure falls back to copy WITH a warning, never silent (D-BLD-8).
- Re-run is a no-op (idempotent); uninstall removes only manifest-listed paths.

## Verification

- Running twice yields identical state (idempotent); manifest lists every installed path and all exist; pre-seeded conflicting file untouched unless confirmed; skills discoverable in target agent dirs; `--uninstall` leaves pre-existing files untouched.
