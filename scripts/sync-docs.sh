#!/usr/bin/env bash
# sync-docs.sh — update shared templates and conventions from docs-platform
# Safe to run on any existing repo: never touches your actual docs content.
#
# Files updated:   docs/templates/*, docs/STYLE.md, .markdownlint.json
# Files never touched: docs/adr/*, docs/rfc/*, docs/design/*, docs/architecture/*,
#                      docs/specs/*, docs/glossary.md, AGENTS.md, CONTRIBUTING.md
#
# Environment variables:
#   DOCS_PLATFORM_REPO  — override the platform repo URL (default: GitHub)
#   DOCS_PLATFORM_REF   — override the branch/tag to use (default: main)

set -euo pipefail

PLATFORM_REPO="${DOCS_PLATFORM_REPO:-https://github.com/yourorg/docs-platform}"
REF="${DOCS_PLATFORM_REF:-main}"
TMP=$(mktemp -d)
trap "rm -rf '$TMP'" EXIT

# ── Colours ───────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}docs-platform sync${NC}"
echo "Platform repo : $PLATFORM_REPO @ $REF"
echo "Target repo   : $(pwd)"
echo ""

# ── Check we are inside a git repo ───────────────────────────────────────────
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: not inside a git repository. Run this from your repo root."
  exit 1
fi

# ── Check docs/ exists (must have been init'd first) ─────────────────────────
if [ ! -d "./docs" ]; then
  echo "Error: docs/ not found. Run init-docs.sh first."
  exit 1
fi

# ── Show current platform version if available ───────────────────────────────
if [ -f "./docs/.platform-version" ]; then
  echo "Current platform version:"
  grep -E "^(ref|commit|synced)=" ./docs/.platform-version | sed 's/^/  /'
  echo ""
fi

# ── Clone platform repo ───────────────────────────────────────────────────────
echo "Fetching docs-platform..."
git clone --quiet --depth 1 --branch "$REF" "$PLATFORM_REPO" "$TMP"

# ── Files that are always synced (platform-owned) ────────────────────────────
echo "Updating shared convention files..."

SYNC_FILES=(
  "docs/STYLE.md"
  "docs/templates/README.md"
  "docs/templates/adr.md"
  "docs/templates/rfc.md"
  "docs/templates/architecture.md"
  "docs/templates/design.md"
  "docs/templates/spec.md"
  ".markdownlint.json"
)

CHANGED=0
for f in "${SYNC_FILES[@]}"; do
  src="$TMP/scaffold/$f"
  dst="./$f"
  if [ -f "$src" ]; then
    # Track if file actually changed
    if [ -f "$dst" ] && diff -q "$src" "$dst" > /dev/null 2>&1; then
      echo -e "  ${YELLOW}unchanged${NC} $f"
    else
      mkdir -p "$(dirname "$dst")"
      cp "$src" "$dst"
      echo -e "  ${GREEN}updated${NC}  $f"
      CHANGED=$((CHANGED + 1))
    fi
  else
    echo -e "  skipped  $f (not found in platform)"
  fi
done

# ── Update platform version reference ────────────────────────────────────────
COMMIT=$(git -C "$TMP" rev-parse HEAD)
cat > ./docs/.platform-version << EOF
# This file is managed by docs-platform. Do not edit manually.
repo=$PLATFORM_REPO
ref=$REF
commit=$COMMIT
synced=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
EOF

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
if [ "$CHANGED" -gt 0 ]; then
  echo -e "${GREEN}Sync complete — $CHANGED file(s) updated.${NC}"
  echo ""
  echo "Review changes: git diff"
  echo "Commit:         git add docs/templates/ docs/STYLE.md .markdownlint.json docs/.platform-version"
  echo "                git commit -m 'chore: sync doc templates from docs-platform@${REF}'"
else
  echo -e "${GREEN}Sync complete — already up to date.${NC}"
fi
echo ""
echo "Your docs (adr/, rfc/, design/, architecture/, specs/, glossary.md) were not touched."
