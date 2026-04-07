# doc-sync

Syncs the latest shared templates and conventions from docs-platform into
the current repository without touching any project-specific documentation.

## Description

Use this agent when you want to pull updated templates or style rules from
docs-platform into an existing repo. Safe to run at any time.

## Steps

1. **Check prerequisites**
   - Confirm the user is in the root of a git repository
   - Confirm `docs/` exists — if not, suggest `doc-scaffold` instead
   - Check `docs/.platform-version` and report the current version to the user

2. **Run sync**

  ```bash
  bash scripts/sync-docs.sh
  ```

  Report each file: updated / unchanged.

3. **Show diff summary**

  ```bash
  git diff docs/templates/ docs/STYLE.md .markdownlint.json
  ```

  Summarise what changed in plain language. For example:
  > "The ADR template gained a new 'Constraints & Invariants' section.
  > The spec template now separates functional and technical requirements."

4. **Check for breaking changes**
   Scan existing docs in `docs/adr/`, `docs/design/`, `docs/architecture/`
   and flag any that use a section structure that no longer matches the updated templates.
   Report as warnings, not errors — the user decides whether to update existing docs.

5. **Suggest commit**

  ```bash
  git add docs/templates/ docs/STYLE.md .markdownlint.json docs/.platform-version
  git commit -m "chore: sync doc templates from docs-platform"
  ```

## What this agent never does

- Modifies `docs/adr/`, `docs/rfc/`, `docs/design/`, `docs/architecture/`, `docs/specs/`
- Modifies `docs/glossary.md`
- Modifies `AGENTS.md` or `CONTRIBUTING.md`
- Creates, renames, or deletes any project-specific documentation

## Notes

- If `scripts/sync-docs.sh` is missing, fetch it first:

  ```bash
  curl -fsSL https://raw.githubusercontent.com/yourorg/docs-platform/main/scripts/sync-docs.sh \
    -o scripts/sync-docs.sh && chmod +x scripts/sync-docs.sh
  ```

- The sync is safe to run in CI — it only changes platform-owned files
