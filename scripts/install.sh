#!/bin/sh
# DDD: ddd-install - POSIX-sh installer; installs skills/templates/installer into a consumer repo (see docs/install.md).
set -u

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd)
[ -n "$SCRIPT_DIR" ] || SCRIPT_DIR=$(pwd)
TARGET_DIR="" DIST_DIR=""
MODE="install"; DRY_RUN=0; YES=0; FORCE=0; FRAMEWORK=""

# ── Agent registry ──────────────────────────────────────────────────────
# Format: "key:name:dir:description"
AGENT_LIST="
opencode:OpenCode:.opencode:The default DDD agent — plans, builds, and verifies work
claude:Claude Code:.claude:Anthropic's Claude Code CLI agent
codex:OpenAI Codex:.agents:OpenAI's Codex CLI agent
cursor:Cursor IDE:.cursor:Cursor's AI-powered IDE
generic:Generic (any agent):.agents:For unsupported or custom agents
"

warn() { printf '%s\n' "  WARN: $*"; }
die() { printf '%s\n' "ERROR: $*" >&2; exit 1; }

step() { printf '%s\n' "  $1 $2"; }
step_ok() { printf '%s\n' "  ✓ $1"; }
step_skip() { printf '%s\n' "  - $1 (skipped)"; }
step_err() { printf '%s\n' "  ✗ $1: $2"; }

platform_is_windowsish() {
    _os=$(uname -s 2>/dev/null || printf 'unknown')
    case "$_os" in MINGW*|MSYS*|CYGWIN*) return 0 ;; *) return 1 ;; esac
}

is_symlink_to() { # <file> <target>
    [ -L "$1" ] || return 1
    [ "$(readlink "$1" 2>/dev/null || printf '')" = "$2" ]
}

same_content() { # <f1> <f2>
    [ -f "$1" ] && [ -f "$2" ] && cmp -s "$1" "$2"
}

confirm() { # <prompt> ; 0=yes
    if [ "$YES" -eq 1 ]; then return 0; fi
    printf '%s [y/N] ' "$1"
    _a=$(read _x && printf '%s' "$_x")
    case "$_a" in y|Y|yes|YES) return 0 ;; *) return 1 ;; esac
}

link_or_copy() { # <src> <dst> <label>
    if ln -s "$1" "$2" 2>/dev/null; then printf '%s\n' "symlink: $3 -> $1"; return 0; fi
    if platform_is_windowsish; then warn "symlink failed for $3; falling back to copy (no live updates)"; fi
    if ! cp -rf -- "$1" "$2" 2>/dev/null; then
        printf '%s\n' "ERROR: copy failed for $3 (from $1 to $2)" >&2
        return 1
    fi
    printf '%s\n' "copy:    $3 (symlink failed)"
}

usage() {
    cat <<'EOF'
Usage: install.sh [options]

Options:
  --help                Show this help and exit.
  --dry-run             Print the full action manifest; execute nothing.
  --yes / --non-interactive  Non-interactive: auto-confirm all prompts.
  --force               Overwrite pre-existing files without prompting.
  --uninstall           Remove exactly the paths in .ddd/manifest.txt.
  --framework <name>    Agent framework: opencode, claude, codex, cursor, generic.
  --target <dir>        Consumer repo root (default: current directory).
  --dist <dir>          Distribution root (default: repo containing this script).

Behavior: detect agent dirs (.opencode/.claude/.agents/.cursor) and prompt which
to install to; --framework skips detection and installs directly. Skills symlink,
templates + installer copy. Never clobbers without confirmation. Writes
.ddd/manifest.txt for safe --uninstall. Windows: Git Bash/WSL only.
EOF
    exit 0
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --help) usage ;;
        --dry-run) DRY_RUN=1 ;;
        --yes|--non-interactive) YES=1 ;;
        --force) FORCE=1 ;;
        --uninstall) MODE="uninstall" ;;
        --framework) [ "$#" -ge 2 ] || die "--framework requires a name (see --help)"; FRAMEWORK="$2"; shift ;;
        --target) [ "$#" -ge 2 ] || die "--target requires a dir"; TARGET_DIR="$2"; shift ;;
        --dist) [ "$#" -ge 2 ] || die "--dist requires a dir"; DIST_DIR="$2"; shift ;;
        *) die "unknown option: $1 (see --help)" ;;
    esac
    shift
done

[ -n "$TARGET_DIR" ] || TARGET_DIR=$(pwd)
if [ ! -d "$TARGET_DIR" ]; then die "target dir does not exist: $TARGET_DIR"; fi
TARGET_DIR=$(CDPATH= cd -P -- "$TARGET_DIR" 2>/dev/null && pwd -P) || die "cannot canonicalize target: $TARGET_DIR"
CANON_TARGET="$TARGET_DIR"
if [ -z "$DIST_DIR" ]; then
    DIST_DIR="$SCRIPT_DIR"
    if [ "$(basename "$SCRIPT_DIR")" = "scripts" ] && [ -d "$(dirname "$SCRIPT_DIR")/skills" ]; then
        DIST_DIR=$(dirname "$SCRIPT_DIR")
    fi
fi
SKILLS_SRC="$DIST_DIR/skills"; TEMPLATES_SRC="$DIST_DIR/templates"; SCRIPTS_SRC="$DIST_DIR/scripts/install.sh"
[ -d "$SKILLS_SRC" ] && [ -d "$TEMPLATES_SRC" ] && [ -f "$SCRIPTS_SRC" ] \
    || die "distribution root '$DIST_DIR' lacks skills/, templates/, scripts/install.sh"

MANIFEST_DIR="$TARGET_DIR/.ddd"; MANIFEST_FILE="$MANIFEST_DIR/manifest.txt"
NOTE_START="<!-- DDD framework install note (managed by install.sh) -->"
NOTE_END="<!-- end DDD framework install note -->"

# ── Framework resolution ────────────────────────────────────────────────

framework_to_dir() { # <name> ; prints dir name or empty on invalid
    case "$1" in
        opencode) printf '.opencode' ;;
        claude)   printf '.claude' ;;
        codex)    printf '.agents' ;;
        cursor)   printf '.cursor' ;;
        generic)  printf '.agents' ;;
        *)        printf '' ;;
    esac
}

detect_agent_dir() {
    for _d in .opencode .claude .agents .cursor; do
        if [ -d "$TARGET_DIR/$_d" ]; then printf '%s' "$_d"; return 0; fi
    done
    return 1
}

select_framework() {
    if [ -n "$FRAMEWORK" ]; then
        _dir=$(framework_to_dir "$FRAMEWORK")
        [ -n "$_dir" ] || die "unknown framework: $FRAMEWORK (valid: opencode, claude, codex, cursor, generic)"
        AGENT_DIR="$_dir"
        return 0
    fi

    # Try auto-detection
    if _detected=$(detect_agent_dir); then
        if [ "$YES" -eq 1 ]; then
            AGENT_DIR="$_detected"
            return 0
        fi
        printf '\n%s\n' "  Detected agent dir: $_detected"
    fi

    if [ "$YES" -eq 1 ]; then
        AGENT_DIR=".opencode"
        return 0
    fi

    # Interactive numbered menu
    printf '\n%s\n' "  Select your agent framework:"
    printf '%s\n' ""
    _i=1
    echo "$AGENT_LIST" | while IFS=: read _key _name _dir _desc; do
        [ -z "$_key" ] && continue
        _det_mark=""
        [ -n "${_detected:-}" ] && [ "$_detected" = "$_dir" ] && _det_mark=" (detected)"
        printf '    %d) %-16s %s%s\n' "$_i" "$_name" "$_desc" "$_det_mark"
        _i=$((_i + 1))
    done
    printf '\n%s' "  Enter number [1-5]: "

    _choice=$(read _c && printf '%s' "$_c")
    _choice=${_choice:-1}

    # Parse choice
    AGENT_DIR=""
    _i=1
    echo "$AGENT_LIST" | while IFS=: read _key _name _dir _desc; do
        [ -z "$_key" ] && continue
        if [ "$_i" = "$_choice" ]; then
            AGENT_DIR="$_dir"
            FRAMEWORK="$_key"
            break
        fi
        _i=$((_i + 1))
    done

    # Fallback if choice didn't resolve
    [ -n "${AGENT_DIR:-}" ] || AGENT_DIR=".opencode"
}

# ── Helpers ─────────────────────────────────────────────────────────────

manifest_append() { [ "$DRY_RUN" -eq 1 ] || printf '%s\n' "$1" >> "$MANIFEST_FILE"; }

ensure_dir() { # <dir>
    if [ "$DRY_RUN" -eq 1 ]; then printf '%s\n' "would create dir: $1"; return 0; fi
    mkdir -p -- "$1" 2>/dev/null || die "cannot create dir $1"
    manifest_append "DIR:$1"
}

path_within_target() { # <path> ; prints canonical path, 0 if inside target
    _p="$1"
    case "$_p" in
        "" | "$CANON_TARGET" | "$CANON_TARGET"/*) ;;
        *) warn "path outside target, skipping: $_p"; return 1 ;;
    esac
    case "$_p" in
        *"/../"* | *"/./"* | */.. | */.)
            warn "path with dot segment rejected: $_p"; return 1 ;;
    esac
    _head="$_p"; _suffix=""
    while [ ! -e "$_head" ]; do
        _suffix="/$(basename -- "$_head")$_suffix"
        _head=$(dirname -- "$_head")
    done
    _hbase=$(basename -- "$_head")
    _hparent=$(dirname -- "$_head")
    _real_parent=$(CDPATH= cd -P -- "$_hparent" 2>/dev/null && pwd -P) || { warn "cannot canonicalize: $_p"; return 1; }
    _real="$_real_parent/$_hbase$_suffix"
    case "$_real" in
        "$CANON_TARGET" | "$CANON_TARGET"/*) ;;
        *) warn "path escapes target (symlink), skipping: $_p"; return 1 ;;
    esac
    printf '%s\n' "$_real"
    return 0
}

symlink_target_within_target() { # <symlink> ; 0 if resolved target stays inside target
    _l="$1"; _tgt=$(readlink "$_l" 2>/dev/null) || return 1
    case "$_tgt" in
        "$CANON_TARGET" | "$CANON_TARGET"/*) return 0 ;;
        /*) return 1 ;;
    esac
    _rel="$(dirname -- "$_l")/$_tgt"
    _rt=$(CDPATH= cd -P -- "$(dirname -- "$_rel")" 2>/dev/null && pwd -P) || return 1
    case "$_rt/$(basename -- "$_rel")" in
        "$CANON_TARGET" | "$CANON_TARGET"/*) return 0 ;;
        *) return 1 ;;
    esac
}

remove_readme_note() {
    _r="$1"; [ -f "$_r" ] || return 0
    _tmp="$TARGET_DIR/.ddd-readme.tmp.$$"
    sed "/$NOTE_START/,/$NOTE_END/d" "$_r" > "$_tmp"
    cp -- "$_tmp" "$_r"; rm -f -- "$_tmp"
}

append_readme_note() {
    _r="$1"; [ -f "$_r" ] || { printf '%s\n' "No README found; skipping note."; return 0; }
    remove_readme_note "$_r"
    { printf '%s\n' ""; printf '%s\n' "$NOTE_START"; printf '%s\n' "Document-Driven Development (DDD) framework installed."; printf '%s\n' "Run 'scripts/install.sh --uninstall' to remove."; printf '%s\n' "$NOTE_END"; } >> "$_r"
    printf '%s\n' "appended install note to $TARGET_DIR/README.md"
    manifest_append "NOTE:$TARGET_DIR/README.md"
}

# ── Install ─────────────────────────────────────────────────────────────

plan_and_install() {
    printf '\n%s\n' "=== Document-Driven Development (DDD) Framework ==="
    printf '\n%s\n' "  DDD helps AI agents plan, build, and verify work."
    printf '%s\n' "  https://github.com/lujo18/Document-Driven-Development"

    # Step 1: Select framework
    printf '\n%s\n' "  ── Step 1/4: Select Agent Framework ──"
    select_framework

    _fw_name=""
    echo "$AGENT_LIST" | while IFS=: read _key _name _dir _desc; do
        [ -z "$_key" ] && continue
        if [ "$_key" = "${FRAMEWORK:-opencode}" ]; then
            _fw_name="$_name"
            break
        fi
    done
    step_ok "Using: ${_fw_name:-$AGENT_DIR} → $AGENT_DIR/"

    # Step 2: Prepare directories
    printf '\n%s\n' "  ── Step 2/4: Prepare Directories ──"
    if [ "$DRY_RUN" -eq 1 ]; then
        step_ok "Would create $AGENT_DIR/skills/"
        step_ok "Would create templates/"
        step_ok "Would create scripts/"
    else
        mkdir -p -- "$MANIFEST_DIR" 2>/dev/null || die "cannot create $MANIFEST_DIR"
        printf '%s\n' "# DDD install manifest - managed by install.sh" > "$MANIFEST_FILE"
        manifest_append "DIR:$MANIFEST_DIR"
        ensure_dir "$TARGET_DIR/$AGENT_DIR"
        ensure_dir "$TARGET_DIR/$AGENT_DIR/skills"
        ensure_dir "$TARGET_DIR/templates"
        ensure_dir "$TARGET_DIR/scripts"
        step_ok "Created $AGENT_DIR/skills/"
        step_ok "Created templates/"
        step_ok "Created scripts/"
    fi

    # Step 3: Install skills
    printf '\n%s\n' "  ── Step 3/4: Install Skills ──"
    _skill_count=0
    for _skill in "$SKILLS_SRC"/*; do
        [ -d "$_skill" ] || continue
        _name=$(basename "$_skill"); _dest="$TARGET_DIR/$AGENT_DIR/skills/$_name"; _label="$AGENT_DIR/skills/$_name"
        _do_write=1
        if [ -L "$_dest" ]; then
            if is_symlink_to "$_dest" "$_skill"; then step_skip "$_label"; manifest_append "$_dest"; _do_write=0
            elif [ "$FORCE" -eq 0 ] && ! confirm "Overwrite existing $_label?"; then step_skip "$_label"; _do_write=0; fi
        elif [ -d "$_dest" ]; then
            if same_content "$_dest/SKILL.md" "$_skill/SKILL.md"; then step_skip "$_label"; manifest_append "$_dest"; _do_write=0
            elif [ "$FORCE" -eq 0 ] && ! confirm "Overwrite existing $_label?"; then step_skip "$_label"; _do_write=0; fi
        elif [ -e "$_dest" ]; then
            if [ "$FORCE" -eq 0 ] && ! confirm "Overwrite existing $_label?"; then step_skip "$_label"; _do_write=0; fi
        fi
        [ "$_do_write" -eq 0 ] && continue
        if [ "$DRY_RUN" -eq 1 ]; then step "→" "would install: $_label"; continue; fi
        rm -rf -- "$_dest" 2>/dev/null
        if link_or_copy "$_skill" "$_dest" "$_label"; then manifest_append "$_dest"; _skill_count=$((_skill_count + 1)); fi
    done
    step_ok "$_skill_count skill(s) installed"

    # Step 4: Install templates + installer
    printf '\n%s\n' "  ── Step 4/4: Install Templates & Scripts ──"
    _tpl_count=0
    for _t in "$TEMPLATES_SRC"/*.md; do
        [ -f "$_t" ] || continue
        _name=$(basename "$_t"); _dest="$TARGET_DIR/templates/$_name"; _label="templates/$_name"
        if [ -f "$_dest" ]; then
            if same_content "$_t" "$_dest"; then step_skip "$_label"; manifest_append "$_dest"; continue
            elif [ "$FORCE" -eq 0 ] && ! confirm "Overwrite existing $_label?"; then step_skip "$_label"; continue; fi
        fi
        if [ "$DRY_RUN" -eq 1 ]; then step "→" "would copy: $_label"; continue; fi
        cp -- "$_t" "$_dest" 2>/dev/null || die "cannot copy $_t"
        manifest_append "$_dest"
        _tpl_count=$((_tpl_count + 1))
    done
    step_ok "$_tpl_count template(s) installed"

    _inst_dest="$TARGET_DIR/scripts/install.sh"
    if [ -f "$_inst_dest" ] && same_content "$SCRIPTS_SRC" "$_inst_dest"; then
        step_skip "scripts/install.sh"
        manifest_append "$_inst_dest"
    elif [ -f "$_inst_dest" ] && [ "$FORCE" -eq 0 ] && ! confirm "Overwrite existing scripts/install.sh?"; then
        step_skip "scripts/install.sh"
    else
        if [ "$DRY_RUN" -eq 1 ]; then step "→" "would copy: scripts/install.sh"
        else cp -- "$SCRIPTS_SRC" "$_inst_dest" 2>/dev/null || die "cannot copy installer"; manifest_append "$_inst_dest"; step_ok "scripts/install.sh"; fi
    fi

    _readme="$TARGET_DIR/README.md"
    if [ "$DRY_RUN" -eq 1 ]; then
        step "→" "would append install note to README.md (if present)"
    elif [ -f "$_readme" ] && confirm "Append DDD install note to README.md?"; then
        append_readme_note "$_readme"
    fi

    if [ "$DRY_RUN" -eq 1 ]; then printf '\n%s\n' "=== dry run complete; nothing written ==="
    else printf '\n%s\n' "=== install complete — Manifest: $MANIFEST_FILE ==="; fi
}

# ── Uninstall ───────────────────────────────────────────────────────────

do_uninstall() {
    [ -f "$MANIFEST_FILE" ] || { printf '%s\n' "No manifest at $MANIFEST_FILE; nothing to uninstall."; exit 0; }
    _dirs=""
    while IFS= read -r _p; do
        [ -z "$_p" ] && continue
        case "$_p" in
            \#*) continue ;;
        esac
        case "$_p" in
            DIR:*)
                _d=${_p#DIR:}
                _d=$(path_within_target "$_d") || { printf '%s\n' "$_d"; continue; }
                _dirs="$_dirs
$_d"
                continue ;;
            NOTE:*)
                _n=${_p#NOTE:}
                _n=$(path_within_target "$_n") || { printf '%s\n' "$_n"; continue; }
                if [ "$DRY_RUN" -eq 1 ]; then
                    printf '%s\n' "would remove install note from: $_n"
                else
                    if [ -L "$_n" ] && ! symlink_target_within_target "$_n"; then
                        warn "note path is a symlink outside target, skipping: $_n"
                        continue
                    fi
                    remove_readme_note "$_n"
                    printf '%s\n' "removed install note from: $_n"
                fi
                continue ;;
        esac
        _c=$(path_within_target "$_p") || { printf '%s\n' "$_c"; continue; }
        if [ "$DRY_RUN" -eq 1 ]; then printf '%s\n' "would remove: $_c"; continue; fi
        if [ -L "$_c" ] || [ -f "$_c" ]; then rm -f -- "$_c" && printf '%s\n' "removed: $_c"
        elif [ -d "$_c" ]; then rm -rf -- "$_c" && printf '%s\n' "removed dir: $_c"; fi
    done < "$MANIFEST_FILE"
    if [ -n "$_dirs" ]; then
        printf '%s\n' "$_dirs" | LC_ALL=C sort -r | while IFS= read -r _d; do
            if [ "$DRY_RUN" -eq 1 ]; then printf '%s\n' "would rmdir (if empty): $_d"
            else rmdir -- "$_d" 2>/dev/null || true; fi
        done
    fi
    if [ "$DRY_RUN" -eq 1 ]; then printf '%s\n' "would remove manifest: $MANIFEST_FILE"
    else
        rm -f -- "$MANIFEST_FILE"
        rmdir -- "$MANIFEST_DIR" 2>/dev/null || true
        printf '%s\n' "uninstall complete."
    fi
    exit 0
}

case "$MODE" in
    uninstall) do_uninstall ;;
    install) plan_and_install ;;
esac
exit 0
