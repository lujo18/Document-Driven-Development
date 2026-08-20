#!/bin/sh
# DDD installer test harness — runs locally, no npx needed.
# Usage: scripts/test.sh [dist-dir]
#   dist-dir: path to the DDD distribution repo root (default: parent of scripts/)
set -e

DIST_DIR="${1:-$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)}"
SCRIPT="$DIST_DIR/scripts/install.sh"

# Find a working shell (Git Bash on Windows, sh elsewhere)
if [ ! -x "$SCRIPT" ] && [ ! -f "$SCRIPT" ]; then
    echo "FAIL: install.sh not found at $SCRIPT"
    exit 1
fi

TEST_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t ddd-test)
cleanup() { rm -rf "$TEST_DIR"; }
trap cleanup EXIT

echo "=== DDD Installer Test Harness ==="
echo "  Distribution: $DIST_DIR"
echo "  Test dir:     $TEST_DIR"
echo ""

# ── Test 1: Install with --framework opencode --yes ──
echo "── Test 1: Install (opencode, non-interactive) ──"
sh "$SCRIPT" --target "$TEST_DIR" --dist "$DIST_DIR" --framework opencode --yes
echo ""

# Verify expected files exist
PASS=0; FAIL=0
check() {
    if [ -e "$1" ]; then echo "  ✓ $2"; PASS=$((PASS+1))
    else echo "  ✗ $2 — MISSING: $1"; FAIL=$((FAIL+1)); fi
}

check "$TEST_DIR/.opencode/skills/ddd-plan/SKILL.md" "skill: ddd-plan"
check "$TEST_DIR/.opencode/skills/ddd-adr/SKILL.md" "skill: ddd-adr"
check "$TEST_DIR/.opencode/skills/ddd-comments/SKILL.md" "skill: ddd-comments"
check "$TEST_DIR/.opencode/skills/ddd-validate-docs/SKILL.md" "skill: ddd-validate-docs"
check "$TEST_DIR/templates/plan.md" "template: plan.md"
check "$TEST_DIR/templates/adr.md" "template: adr.md"
check "$TEST_DIR/templates/comments.md" "template: comments.md"
check "$TEST_DIR/templates/catalog.md" "template: catalog.md"
check "$TEST_DIR/scripts/install.sh" "script: install.sh"
check "$TEST_DIR/.ddd/manifest.txt" "manifest exists"
echo ""

# ── Test 2: Uninstall with --delete ──
echo "── Test 2: Uninstall (--delete) ──"
sh "$SCRIPT" --target "$TEST_DIR" --dist "$DIST_DIR" --delete
echo ""

check_noe() {
    if [ ! -e "$1" ]; then echo "  ✓ $2 removed"; PASS=$((PASS+1))
    else echo "  ✗ $2 still exists: $1"; FAIL=$((FAIL+1)); fi
}

check_noe "$TEST_DIR/.opencode/skills/ddd-plan/SKILL.md" "skill: ddd-plan"
check_noe "$TEST_DIR/.opencode/skills/ddd-adr/SKILL.md" "skill: ddd-adr"
check_noe "$TEST_DIR/templates/plan.md" "template: plan.md"
check_noe "$TEST_DIR/scripts/install.sh" "script: install.sh"
check_noe "$TEST_DIR/.ddd/manifest.txt" "manifest"
echo ""

# ── Test 3: Uninstall with no manifest (should be no-op) ──
echo "── Test 3: Uninstall with no manifest (idempotent) ──"
sh "$SCRIPT" --target "$TEST_DIR" --dist "$DIST_DIR" --delete
echo ""

# ── Test 4: Dry run (should create nothing) ──
echo "── Test 4: Dry run ──"
sh "$SCRIPT" --target "$TEST_DIR" --dist "$DIST_DIR" --framework claude --dry-run
check_noe "$TEST_DIR/.claude" "dry run: .claude dir"
check_noe "$TEST_DIR/.ddd" "dry run: .ddd dir"
echo ""

# ── Summary ──
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
