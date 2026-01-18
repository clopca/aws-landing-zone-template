# Agent Instructions

This project uses **bd** (Beads) for issue tracking. Run `bd onboard` to get started.

## Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>         # Complete work
bd sync               # Sync with git
```

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd sync
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds

---

# Ralph Wiggum Mode

You are operating in **Ralph Wiggum mode** with **Beads** for task tracking.

Ralph Wiggum is an autonomous development loop where YOU choose which task to work on next. Beads provides git-backed issue tracking with recovery cards for cross-session continuity.

## Project Context

This is an **AWS Landing Zone Template** project with:

- **Terraform** infrastructure for multi-account AWS Organization
- **Docusaurus** documentation site
- **SST** for deploying documentation to AWS CloudFront
- **AFT** (Account Factory for Terraform) integration

### Key Directories

| Directory | Purpose |
|-----------|---------|
| `terraform/organization/` | Management account (AWS Organizations, SCPs) |
| `terraform/security/` | Security account (GuardDuty, Security Hub) |
| `terraform/log-archive/` | Log Archive account (CloudTrail, Config) |
| `terraform/network/` | Network Hub (Transit Gateway, VPCs) |
| `terraform/shared-services/` | Shared Services (CI/CD, ECR) |
| `terraform/aft/` | Account Factory for Terraform |
| `terraform/modules/` | Reusable Terraform modules |
| `docs/` | Docusaurus documentation |
| `infra/` | SST infrastructure for docs deployment |
| `scripts/` | Development and deployment scripts |

## Beads Workflow

Use `bd` commands to manage tasks:

| Command | Purpose |
|---------|---------|
| `bd ready` | List unblocked tasks ready for work |
| `bd show <id>` | View task details |
| `bd create --title="..." --type=task --priority=1` | Create new task |
| `bd update <id> --status=in_progress` | Mark task as in progress |
| `bd close <id> --reason="..."` | Complete a task |
| `bd dep add <child> <parent>` | Add dependency |
| `bd sync` | Sync with git |

### Priority Levels
- **P0 (0)**: Critical blockers
- **P1 (1)**: High priority
- **P2 (2)**: Medium priority (default)
- **P3 (3)**: Nice to have
- **P4 (4)**: Backlog

## Your Ralph Loop Responsibilities

### 1. Read Context
- Run `bd ready` to see available tasks
- Check recovery card if starting new session
- Check progress.txt for session history

### 2. Choose the Next Task
From `bd ready` output, pick based on:
1. Priority (P0 first, then P1, etc.)
2. Architectural decisions (they cascade)
3. Integration points (reveal issues early)
4. Dependencies (blocked tasks can't proceed)

### 3. Claim and Implement ONE Task
```bash
bd update <task-id> --status=in_progress
```
- Work on a single task per iteration
- Keep changes small and focused

### 4. Run Feedback Loops

**For Terraform:**
```bash
cd terraform/<account>
terraform init -backend=false
terraform validate
terraform fmt -check
```

**For Documentation:**
```bash
cd docs
npm run build
npm run lint  # if configured
```

**DO NOT commit if any feedback loop fails.**

### 5. Complete and Update
```bash
bd close <task-id> --reason="Implemented and tested"
bd sync
git commit -m "feat: description"
```
- Append to progress.txt with timestamp, task, decisions, files

### 6. Check for Completion
If `bd ready` returns empty (no more tasks):
- Update recovery card with final state
- Output: `<promise>COMPLETE</promise>`

## Recovery Card Pattern

When starting a session, check for a recovery card:
```bash
bd list --type=recovery
```

When ending a session, update the recovery card with:
- Current progress
- What was accomplished
- Next steps
- Any blockers

## Emergency Stop

If blocked or need human input:
```
<promise>BLOCKED: [reason]</promise>
```

## Terraform Best Practices

1. **One resource type per file** when modules grow large
2. **Use consistent naming**: `<account>-<resource>-<purpose>`
3. **Tag everything** with `Project`, `Environment`, `ManagedBy`
4. **Validate before commit**: `terraform validate && terraform fmt -check`
5. **Document modules** with README.md and examples

## Documentation Best Practices

1. **Update docs with code changes** - keep them in sync
2. **Use Mermaid diagrams** for architecture
3. **Include runbooks** for operational procedures
4. **Add code examples** with syntax highlighting
