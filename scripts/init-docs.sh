#!/usr/bin/env bash
# init-docs.sh — scaffold the standard documentation structure into a new repo
# Usage: run from the root of your target repository
#
# Environment variables:
#   DOCS_PLATFORM_REPO  — override the platform repo URL (default: GitHub)
#   DOCS_PLATFORM_REF   — override the branch/tag to use (default: main)

set -euo pipefail

PLATFORM_REPO="${DOCS_PLATFORM_REPO:-https://github.com/yourorg/docs-platform}"
REF="${DOCS_PLATFORM_REF:-main}"
TMP=$(mktemp -d)
trap "rm -rf '$TMP'" EXIT

# ── Colours ──────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}docs-platform init${NC}"
echo "Platform repo : $PLATFORM_REPO @ $REF"
echo "Target repo   : $(pwd)"
echo ""

# ── Check we are inside a git repo ───────────────────────────────────────────
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: not inside a git repository. Run this from your repo root."
  exit 1
fi

# ── Check docs/ does not already exist ───────────────────────────────────────
if [ -d "./docs" ]; then
  echo -e "${YELLOW}Warning: docs/ already exists.${NC}"
  echo "Use sync-docs.sh to update templates in an existing repo."
  echo "To force a fresh scaffold anyway, delete docs/ first."
  exit 1
fi

# ── Clone platform repo ───────────────────────────────────────────────────────
echo "Cloning docs-platform..."
git clone --quiet --depth 1 --branch "$REF" "$PLATFORM_REPO" "$TMP"

# ── Copy root files (skip if already present) ─────────────────────────────────
echo "Copying root files..."
ROOT_FILES=("AGENTS.md" "CONTRIBUTING.md" "CHANGELOG.md" ".markdownlint.json")
for f in "${ROOT_FILES[@]}"; do
  if [ ! -f "./$f" ]; then
    cp "$TMP/scaffold/$f" "./$f"
    echo -e "  ${GREEN}created${NC}  $f"
  else
    echo -e "  ${YELLOW}skipped${NC}  $f (already exists)"
  fi
done

# ── Copy docs/ tree ───────────────────────────────────────────────────────────
echo "Copying docs/ structure..."
rsync -a --ignore-existing "$TMP/scaffold/docs/" "./docs/"
echo -e "  ${GREEN}created${NC}  docs/"

# ── Store platform version reference ─────────────────────────────────────────
COMMIT=$(git -C "$TMP" rev-parse HEAD)
mkdir -p ./docs
cat > ./docs/.platform-version << EOF
# This file is managed by docs-platform. Do not edit manually.
repo=$PLATFORM_REPO
ref=$REF
commit=$COMMIT
synced=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
EOF
echo -e "  ${GREEN}created${NC}  docs/.platform-version"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}Scaffold complete.${NC}"
echo ""
echo "Next steps:"
echo "  1. Edit AGENTS.md — add your project-specific code conventions"
echo "  2. Edit docs/glossary.md — add your domain terms"
echo "  3. Commit everything: git add -A && git commit -m 'chore: init docs structure from docs-platform'"
echo "  4. To sync template updates later: bash scripts/sync-docs.sh"
