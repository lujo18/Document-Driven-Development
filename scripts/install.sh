#!/bin/sh
# DDD: ddd-install - POSIX-sh installer; installs skills/templates/installer into a consumer repo (see docs/install.md).
set -u

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd)
[ -n "$SCRIPT_DIR" ] || SCRIPT_DIR=$(pwd)
TARGET_DIR="" DIST_DIR=""
MODE="install"; DRY_RUN=0; YES=0; FORCE=0; FRAMEWORK=""
DEFAULT_AGENT_DIRS=".opencode .claude .agents"

warn() { printf '%s\n' "WARN: $*"; }
die() { printf '%s\n' "ERROR: $*" >&2; exit 1; }

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
  --help              Show this help and exit.
  --dry-run           Print the full action manifest; execute nothing.
  --yes               Non-interactive: auto-confirm all prompts.
  --force             Overwrite pre-existing files without prompting.
  --uninstall         Remove exactly the paths in .ddd/manifest.txt.
  --framework <name>  Framework selector: opencode, claude, agents, cursor.
  --target <dir>      Consumer repo root (default: current directory).
  --dist <dir>        Distribution root (default: repo containing this script).

Behavior: detect agent dirs (.opencode/.claude/.agents/.cursor) and prompt which
to install to (detected = defaults); --yes uses detected dirs, fallback
.opencode/.claude/.agents; .cursor only when present or chosen. --framework
skips detection and installs directly into the chosen framework's dir. Skills
symlink, templates + installer copy. Never clobbers without confirmation. Writes
.ddd/manifest.txt for safe --uninstall. Windows: Git Bash/WSL only.
EOF
    exit 0
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --help) usage ;;
        --dry-run) DRY_RUN=1 ;;
        --yes) YES=1 ;;
        --force) FORCE=1 ;;
        --uninstall) MODE="uninstall" ;;
        --framework) [ "$#" -ge 2 ] || die "--framework requires a name (opencode, claude, agents, cursor)"; FRAMEWORK="$2"; shift ;;
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
    # Running as scripts/install.sh: the distribution root is the parent.
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

detect_agent_dirs() {
    _f=""
    for _d in .opencode .claude .agents .cursor; do
        if [ -d "$TARGET_DIR/$_d" ]; then _f="$_f $_d"; fi
    done
    printf '%s' "$_f"
}

valid_agent_dir() { # <name> ; 0 if valid
    case "$1" in
        "" | "." | "..") return 1 ;;
    esac
    case "$1" in
        .*) ;;
        *) return 1 ;;
    esac
    case "$1" in
        *[!a-z0-9_.-]*) return 1 ;;
    esac
    return 0
}

framework_to_dir() { # <name> ; prints dir name or empty on invalid
    case "$1" in
        opencode) printf '.opencode' ;;
        claude)   printf '.claude' ;;
        agents)   printf '.agents' ;;
        cursor)   printf '.cursor' ;;
        *)        printf '' ;;
    esac
}

select_agent_dirs() {
    if [ -n "$FRAMEWORK" ]; then
        _dir=$(framework_to_dir "$FRAMEWORK")
        [ -n "$_dir" ] || die "unknown framework: $FRAMEWORK (valid: opencode, claude, agents, cursor)"
        AGENT_DIRS="$_dir"
        return 0
    fi
    _det=$(detect_agent_dirs)
    _det=$(printf '%s' "$_det" | sed 's/^ *//;s/ *$//')
    if [ "$YES" -eq 1 ]; then
        if [ -n "$_det" ]; then AGENT_DIRS="$_det"; else AGENT_DIRS="$DEFAULT_AGENT_DIRS"; fi
        return 0
    fi
    printf '%s\n' "Detected agent dirs under '$TARGET_DIR': ${_det:-none}"
    printf '%s\n' "Install skills into which dirs? (space-separated; default: ${_det:-$DEFAULT_AGENT_DIRS})"
    printf '> '
    _ans=$(read _a && printf '%s' "$_a")
    if [ -n "$_ans" ]; then
        AGENT_DIRS=""
        for _tok in $_ans; do
            if valid_agent_dir "$_tok"; then AGENT_DIRS="$AGENT_DIRS $_tok"
            else warn "invalid agent dir token skipped: $_tok"; fi
        done
        AGENT_DIRS=$(printf '%s' "$AGENT_DIRS" | sed 's/^ *//')
        if [ -z "$AGENT_DIRS" ]; then
            if [ -n "$_det" ]; then AGENT_DIRS="$_det"; else AGENT_DIRS="$DEFAULT_AGENT_DIRS"; fi
            printf '%s\n' "no valid agent dirs given; using detected/default: $AGENT_DIRS"
        fi
    elif [ -n "$_det" ]; then AGENT_DIRS="$_det"
    else AGENT_DIRS="$DEFAULT_AGENT_DIRS"; fi
}

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
                    # TOCTOU: re-check the note leaf for symlink escape immediately before mutation
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
        # TOCTOU: re-validate immediately before the destructive action (path may have been swapped)
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
        # TOCTOU: re-validate the manifest dir before removal
        rm -f -- "$MANIFEST_FILE"
        rmdir -- "$MANIFEST_DIR" 2>/dev/null || true
        printf '%s\n' "uninstall complete."
    fi
    exit 0
}

plan_and_install() {
    printf '%s\n' "=== DDD framework install (target: $TARGET_DIR) ==="
    select_agent_dirs
    printf '%s\n' "Installing skills into: $AGENT_DIRS"
    if [ "$DRY_RUN" -eq 0 ]; then
        mkdir -p -- "$MANIFEST_DIR" 2>/dev/null || die "cannot create $MANIFEST_DIR"
        printf '%s\n' "# DDD install manifest - managed by install.sh" > "$MANIFEST_FILE"
    else
        printf '%s\n' "would create dir: $MANIFEST_DIR"
    fi
    manifest_append "DIR:$MANIFEST_DIR"
    for _ad in $AGENT_DIRS; do
        _parent="$TARGET_DIR/$_ad"
        _skill_parent="$TARGET_DIR/$_ad/skills"
        _ok=0
        if [ -d "$_parent" ]; then _ok=1
        elif [ "$YES" -eq 1 ] && { [ "$_ad" = ".opencode" ] || [ "$_ad" = ".claude" ] || [ "$_ad" = ".agents" ]; }; then _ok=1
        fi
        if [ "$_ok" -eq 0 ]; then printf '%s\n' "skip: agent dir $_parent does not exist"; continue; fi
        ensure_dir "$_parent"
        ensure_dir "$_skill_parent"
        for _skill in "$SKILLS_SRC"/*; do
            [ -d "$_skill" ] || continue
            _name=$(basename "$_skill"); _dest="$_skill_parent/$_name"; _label="$_ad/skills/$_name"
            _do_write=1
            if [ -L "$_dest" ]; then
                if is_symlink_to "$_dest" "$_skill"; then printf '%s\n' "no-op: $_label already linked"; manifest_append "$_dest"; _do_write=0
                elif [ "$FORCE" -eq 0 ] && ! confirm "Overwrite existing $_label?"; then printf '%s\n' "skip: $_label (existing kept)"; _do_write=0; fi
            elif [ -d "$_dest" ]; then
                if same_content "$_dest/SKILL.md" "$_skill/SKILL.md"; then printf '%s\n' "no-op: $_label already installed (copy)"; manifest_append "$_dest"; _do_write=0
                elif [ "$FORCE" -eq 0 ] && ! confirm "Overwrite existing $_label?"; then printf '%s\n' "skip: $_label (existing kept)"; _do_write=0; fi
            elif [ -e "$_dest" ]; then
                if [ "$FORCE" -eq 0 ] && ! confirm "Overwrite existing $_label?"; then printf '%s\n' "skip: $_label (existing kept)"; _do_write=0; fi
            fi
            [ "$_do_write" -eq 0 ] && continue
            if [ "$DRY_RUN" -eq 1 ]; then printf '%s\n' "would symlink: $_label -> $_skill"; continue; fi
            rm -rf -- "$_dest" 2>/dev/null
            if link_or_copy "$_skill" "$_dest" "$_label"; then manifest_append "$_dest"; fi
        done
    done
    _templates_dest="$TARGET_DIR/templates"
    ensure_dir "$_templates_dest"
    for _t in "$TEMPLATES_SRC"/*.md; do
        [ -f "$_t" ] || continue
        _name=$(basename "$_t"); _dest="$_templates_dest/$_name"; _label="templates/$_name"
        if [ -f "$_dest" ]; then
            if same_content "$_t" "$_dest"; then printf '%s\n' "no-op: $_label identical"; manifest_append "$_dest"; continue; fi
            if [ "$FORCE" -eq 0 ] && ! confirm "Overwrite existing $_label?"; then printf '%s\n' "skip: $_label (existing kept)"; continue; fi
        fi
        if [ "$DRY_RUN" -eq 1 ]; then printf '%s\n' "would copy: $_label -> $_dest"; continue; fi
        cp -- "$_t" "$_dest" 2>/dev/null || die "cannot copy $_t"
        printf '%s\n' "copy: $_label -> $_dest"; manifest_append "$_dest"
    done
    _scripts_dest="$TARGET_DIR/scripts"; _inst_dest="$_scripts_dest/install.sh"
    ensure_dir "$_scripts_dest"
    if [ -f "$_inst_dest" ] && same_content "$SCRIPTS_SRC" "$_inst_dest"; then
        printf '%s\n' "no-op: scripts/install.sh identical"
        manifest_append "$_inst_dest"
    elif [ -f "$_inst_dest" ] && [ "$FORCE" -eq 0 ] && ! confirm "Overwrite existing scripts/install.sh?"; then
        printf '%s\n' "skip: scripts/install.sh (existing kept)"
    else
        if [ "$DRY_RUN" -eq 1 ]; then printf '%s\n' "would copy: scripts/install.sh -> $_inst_dest"
        else cp -- "$SCRIPTS_SRC" "$_inst_dest" 2>/dev/null || die "cannot copy installer"; printf '%s\n' "copy: scripts/install.sh -> $_inst_dest"; manifest_append "$_inst_dest"; fi
    fi
    _readme="$TARGET_DIR/README.md"
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '%s\n' "would append install note to README.md (if present)"
    elif [ -f "$_readme" ] && confirm "Append DDD install note to $TARGET_DIR/README.md?"; then
        append_readme_note "$_readme"
    fi
    if [ "$DRY_RUN" -eq 1 ]; then printf '%s\n' "--- dry run complete; nothing written ---"
    else printf '%s\n' "=== install complete. Manifest: $MANIFEST_FILE ==="; fi
}

case "$MODE" in
    uninstall) do_uninstall ;;
    install) plan_and_install ;;
esac
exit 0
