# DDD Framework — Install Guide

> **Status:** done

## What this installs

The Document-Driven Development (DDD) framework is a content delivery repo. `install.sh` installs into a **consumer repo** (any project your agents work on):

- **skills/** — 11 portable skills, symlinked into your chosen agent skill directories (live updates).
- **templates/** — 9 templates, **copied** to the consumer `templates/` (stable scaffolding).
- **scripts/install.sh** — copied to the consumer `scripts/install.sh` (self-installed repair/uninstall entrypoint).
- **README note** — a short, marked install note appended to the consumer README (after confirmation).

No build system, package manager, or runtime is installed (AGENTS.md invariants).

## Quickstart

From the distribution root, run the shim (or `sh scripts/install.sh`) against your consumer repo:

    sh install.sh --target /path/to/consumer-repo

Interactive flow: the installer detects agent directories under the target and asks which to install to (detected dirs are the defaults). Answer with space-separated names (e.g. `.opencode .claude`), or press Enter for the defaults.

Non-interactive flow:

    sh install.sh --target /path/to/consumer-repo --yes

`--yes` uses the detected agent dirs; if none are detected it falls back to `.opencode/` + `.claude/` + `.agents/`. `.cursor/` is only ever used when the consumer has it or you explicitly select it.

## Full flag reference

| Flag | Effect |
|---|---|
| `--help` | Show usage and exit. |
| `--dry-run` | Print the full action manifest; execute nothing. |
| `--yes` | Non-interactive: auto-confirm all prompts. |
| `--force` | Overwrite pre-existing files without prompting (explicit opt-in). |
| `--uninstall` | Remove exactly the paths listed in `.ddd/manifest.txt`. |
| `--target <dir>` | Consumer repo root (default: current directory). |
| `--dist <dir>` | Distribution root (default: repo containing the script). |

## Agent-directory selection

- The installer detects `.opencode/`, `.claude/`, `.agents/`, `.cursor/` under the target.
- **Interactive:** you are asked which to install to; detected dirs are shown as defaults.
- **`--yes`:** detected dirs are used; fallback `.opencode/` + `.claude/` + `.agents/`.
- `.cursor/` is used only when present or explicitly chosen.
- Skills are symlinked into `<agent-dir>/skills/<skill-name>`.

## Symlink / copy matrix

| Artifact | Action | Rationale |
|---|---|---|
| `skills/` (11 folders) | symlink into chosen agent skill dirs | live updates across installs |
| `templates/` (9 files) | copy to consumer `templates/` | templates are scaffolding, must be stable copies |
| `scripts/install.sh` | copy to consumer `scripts/install.sh` | self-installed uninstall/repair entrypoint |
| README note | appended, marked | removable by uninstall |

## Idempotency and no-clobber

- **Idempotent:** a second run produces zero changes. An existing symlink to the same distribution target is a no-op; identical file content is a no-op; differing content prompts (or `--force`).
- **No-clobber:** pre-existing consumer files are never modified or deleted without confirmation. `--yes` counts as confirmation; `--force` skips overwrite-only prompts.

## Manifest and uninstall

The installer writes `.ddd/manifest.txt` listing every path it created plus the README-note marker. To remove the framework:

    sh install.sh --uninstall --target /path/to/consumer-repo

`--uninstall` removes exactly the manifest-listed paths and never pre-existing files. If the manifest is missing, uninstall reports nothing to do.

## Windows

- **Windows is documented as unsupported in v1** (D-BLD-1). Run the installer under **Git Bash** or **WSL** on Windows — do not run it from PowerShell or cmd.
- On MSYS/MINGW/CYGWIN, if `ln -s` fails, the installer falls back to a copy **with a warning** (never silent). Copies mean skills lose live-update behavior; re-install to refresh.
- A non-POSIX shell invocation exits non-zero with a pointer to this document.
- A PowerShell `install.ps1` variant is deferred as future work.

## Troubleshooting

| Problem | Fix |
|---|---|
| `sh: install.sh: No such file or directory` | Run from the distribution root, or pass `--dist <dir>`. |
| "distribution root lacks skills/, templates/" | Point `--dist` at the repo that contains `skills/` + `templates/` + `scripts/install.sh`. |
| Symlink permission denied (Windows) | Run under Git Bash/WSL with sufficient privileges; installer falls back to copy-with-warning. |
| Uninstall removes nothing | The manifest is missing or the target root is wrong; pass the same `--target` used at install. |
| Prompts hang in CI | Use `--yes` (non-interactive). |

## Smoke test

Verify a fresh clone end-to-end on a scratch consumer (Git Bash or WSL):

    sh scripts/install.sh --target /tmp/ddd-smoke --dry-run
    sh scripts/install.sh --target /tmp/ddd-smoke --yes
    sh scripts/install.sh --target /tmp/ddd-smoke --yes
    sh scripts/install.sh --target /tmp/ddd-smoke --uninstall
    find /tmp/ddd-smoke -mindepth 1        # expect: empty (or only pre-existing files)

Expected: dry-run writes nothing; install creates every manifest path (skills symlinked, templates + installer copied, `.ddd/manifest.txt` written, README note appended); re-run is idempotent with a stable manifest; uninstall leaves zero DDD artifacts and sweeps empty dirs.

## First commit (maintainers)

After `git init`, make the shell entrypoints executable in the index:

    git update-index --chmod=+x install.sh scripts/install.sh

`chmod +x` is already attempted on checkout, but the index update guarantees the exec bit is committed on every platform.

## Links

- Root README: `README.md`
- Research library index: `docs/research/README.md`
- ADRs: `docs/adr/0001-installer-mechanics.md`, `docs/adr/0002-skill-authoring-contract.md`, `docs/adr/0003-code-comment-indexing.md`
- Template manifest: `templates/catalog.md`
