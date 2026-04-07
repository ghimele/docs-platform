# AGENTS.md — docs-platform

This is the docs-platform repository itself — the source of shared documentation
structure, templates, and scripts for all projects.

---

## Purpose

This repo provides:

- `scaffold/` — files copied into target repos on init or sync
- `scripts/` — `init-docs.sh` and `sync-docs.sh`
- `agent/` — Copilot agent prompts for doc scaffolding and syncing

---

## Rules for Agents Working in THIS Repo

### scaffold/ is the source of truth

All changes to documentation structure or templates must be made inside `scaffold/`.
Do not create documentation files at the repo root — this repo's own docs live in `scaffold/docs/`.

### Breaking changes need a CHANGELOG entry

If you modify a template in a way that would require updates to existing docs in
consuming repos (e.g. renaming a required section), add a note to `CHANGELOG.md`
under `[Unreleased]` describing the change and what consuming repos need to do.

### Never modify script logic without testing

`scripts/init-docs.sh` and `scripts/sync-docs.sh` run in consuming repos.
Changes must be tested against both a fresh repo (init) and an existing repo (sync)
before merging.

### agent/ prompts must stay in sync with scripts/

If `sync-docs.sh` adds a new synced file, update `agent/doc-sync.prompt.md`
to reflect the new file in the "What this agent never does" and summary sections.

---

## Files Agents Must Not Modify

- `AGENTS.md` (this file)
- `scripts/` — requires human testing before changes
