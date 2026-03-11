# GitHub Copilot Instructions for Beads

## Issue Tracking

This repository uses `bd` (Beads) for all task tracking.

- Use `bd ready --json` to find unblocked work
- Use `bd update <id> --status in_progress --json` to claim work
- Use `bd close <id> --reason "Done" --json` to complete work
- Commit `.beads/issues.jsonl` together with the code changes

Do not create markdown TODO lists or track work outside Beads.

## Workflow

1. Check ready work with `bd ready --json`
2. Claim the selected issue
3. Implement and validate changes
4. Run `bd sync` before finishing the session
5. Commit and push the code together with `.beads/issues.jsonl`

## Terraform

- Run `terraform init -backend=false`, `terraform validate`, and `terraform fmt -check`
- Keep provider versions aligned with the repo standard
- Update docs and examples when contracts change
