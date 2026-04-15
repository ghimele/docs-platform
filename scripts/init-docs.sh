#!/usr/bin/env bash
# init-docs.sh — scaffold the standard documentation structure into a new repo
# Usage: run from the root of your target folder
#
# Environment variables:
#   DOCS_PLATFORM_PATH  — override the local docs-platform source path
#   DOCS_PLATFORM_REPO  — override the platform repo URL (default: GitHub)
#   DOCS_PLATFORM_REF   — override the branch/tag to use (default: main)

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_PLATFORM_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
PLATFORM_REPO="${DOCS_PLATFORM_REPO:-https://github.com/yourorg/docs-platform}"
REF="${DOCS_PLATFORM_REF:-main}"
PLATFORM_SOURCE=""
TMP=""

cleanup() {
  if [ -n "$TMP" ] && [ -d "$TMP" ]; then
    rm -rf "$TMP"
  fi
}

trap cleanup EXIT

is_git_repo() {
  local path="$1"
  git -C "$path" rev-parse --git-dir > /dev/null 2>&1
}

# ── Colours ──────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}docs-platform init${NC}"
echo "Platform repo : $PLATFORM_REPO @ $REF"
echo "Target repo   : $(pwd)"
echo ""

# ── Check target folder ──────────────────────────────────────────────────────
if is_git_repo "$(pwd)"; then
  echo "Target folder type: git repository"
else
  echo -e "${YELLOW}Warning:${NC} target folder is not a git repository. Continuing anyway."
fi
echo ""

# ── Check docs/ does not already exist ───────────────────────────────────────
if [ -d "./docs" ]; then
  echo -e "${YELLOW}Warning: docs/ already exists.${NC}"
  echo "Use sync-docs.sh to update templates in an existing repo."
  echo "To force a fresh scaffold anyway, delete docs/ first."
  exit 1
fi

# ── Determine platform source ────────────────────────────────────────────────
if [ -n "${DOCS_PLATFORM_PATH:-}" ] && [ -d "${DOCS_PLATFORM_PATH}/scaffold" ]; then
  PLATFORM_SOURCE="$DOCS_PLATFORM_PATH"
  echo "Using docs-platform source from DOCS_PLATFORM_PATH: $PLATFORM_SOURCE"
elif [ -d "$LOCAL_PLATFORM_ROOT/scaffold" ]; then
  PLATFORM_SOURCE="$LOCAL_PLATFORM_ROOT"
  echo "Using local docs-platform checkout: $PLATFORM_SOURCE"
else
  if ! command -v git > /dev/null 2>&1; then
    echo "Error: git is required to clone docs-platform when no local source is available."
    exit 1
  fi

  TMP=$(mktemp -d)
  echo "Cloning docs-platform..."
  git clone --quiet --depth 1 --branch "$REF" "$PLATFORM_REPO" "$TMP"
  PLATFORM_SOURCE="$TMP"
fi
echo ""

# ── Copy root files (skip if already present) ─────────────────────────────────
echo "Copying root files..."
ROOT_FILES=("AGENTS.md" "CONTRIBUTING.md" "CHANGELOG.md" ".markdownlint.json")
for f in "${ROOT_FILES[@]}"; do
  if [ ! -f "./$f" ]; then
    cp "$PLATFORM_SOURCE/scaffold/$f" "./$f"
    echo -e "  ${GREEN}created${NC}  $f"
  else
    echo -e "  ${YELLOW}skipped${NC}  $f (already exists)"
  fi
done

# ── Copy docs/ tree ───────────────────────────────────────────────────────────
echo "Copying docs/ structure..."
if [ -d "$PLATFORM_SOURCE/scaffold/docs" ]; then
  rsync -a --ignore-existing "$PLATFORM_SOURCE/scaffold/docs/" "./docs/"
else
  mkdir -p ./docs
  for path in "$PLATFORM_SOURCE"/scaffold/*; do
    if [ ! -e "$path" ]; then
      continue
    fi

    name=$(basename "$path")
    case "$name" in
      AGENTS.md|CONTRIBUTING.md|CHANGELOG.md|.markdownlint.json|README.md)
        continue
        ;;
    esac

    if [ ! -e "./docs/$name" ]; then
      cp -R "$path" "./docs/$name"
    fi
  done

  if [ -f "$PLATFORM_SOURCE/scaffold/README.md" ] && [ ! -e "./docs/README.md" ]; then
    cp "$PLATFORM_SOURCE/scaffold/README.md" "./docs/README.md"
  fi
fi
echo -e "  ${GREEN}created${NC}  docs/"

# ── Copy agent prompt files ───────────────────────────────────────────────────
if [ -d "$PLATFORM_SOURCE/agent" ]; then
  echo "Copying agent prompts..."
  mkdir -p ./agent
  for path in "$PLATFORM_SOURCE"/agent/*.prompt.md; do
    if [ ! -e "$path" ]; then
      continue
    fi

    name=$(basename "$path")
    if [ ! -e "./agent/$name" ]; then
      cp "$path" "./agent/$name"
      echo -e "  ${GREEN}created${NC}  agent/$name"
    else
      echo -e "  ${YELLOW}skipped${NC}  agent/$name (already exists)"
    fi
  done
fi

# ── Store platform version reference ─────────────────────────────────────────
if command -v git > /dev/null 2>&1 && is_git_repo "$PLATFORM_SOURCE"; then
  PLATFORM_REPO_VALUE="$(git -C "$PLATFORM_SOURCE" config --get remote.origin.url || true)"
  PLATFORM_REF_VALUE="$(git -C "$PLATFORM_SOURCE" symbolic-ref --short HEAD 2>/dev/null || echo "$REF")"
  COMMIT="$(git -C "$PLATFORM_SOURCE" rev-parse HEAD)"
else
  PLATFORM_REPO_VALUE="${DOCS_PLATFORM_PATH:-$PLATFORM_REPO}"
  PLATFORM_REF_VALUE="$REF"
  COMMIT="unknown"
fi

if [ -z "$PLATFORM_REPO_VALUE" ]; then
  PLATFORM_REPO_VALUE="$PLATFORM_SOURCE"
fi

mkdir -p ./docs
cat > ./docs/.platform-version << EOF
# This file is managed by docs-platform. Do not edit manually.
repo=$PLATFORM_REPO_VALUE
ref=$PLATFORM_REF_VALUE
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
echo "  4. To sync template and prompt updates later: bash scripts/sync-docs.sh"
