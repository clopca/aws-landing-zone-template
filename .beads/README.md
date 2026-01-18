# Beads Task Tracking

This directory contains the Beads git-backed issue tracking system for the AWS Landing Zone Template.

## Quick Start

```bash
# View ready tasks
bd ready

# Create a new task
bd create --title="Task description" --type=task --priority=1

# View task details
bd show <task-id>

# Claim a task
bd update <task-id> --status=in_progress

# Complete a task
bd close <task-id> --reason="What was done"

# Sync with git
bd sync
```

## Priority Levels

| Priority | Level | Description |
|----------|-------|-------------|
| P0 | 0 | Critical blockers |
| P1 | 1 | High priority |
| P2 | 2 | Medium priority (default) |
| P3 | 3 | Nice to have |
| P4 | 4 | Backlog |

## Files

- `config.yaml` - Beads configuration
- `issues.jsonl` - Issue database (git-tracked)
- `interactions.jsonl` - Interaction log

## Integration with Ralph Wiggum

This project uses Ralph Wiggum autonomous development loop. The AI agent will:

1. Check `bd ready` for available tasks
2. Pick highest-priority unblocked task
3. Implement and test
4. Close task with `bd close`
5. Update `progress.txt`

## Resources

- [Beads Documentation](https://github.com/steveyegge/beads)
- [Ralph Wiggum Methodology](https://ghuntley.com/ralph/)
