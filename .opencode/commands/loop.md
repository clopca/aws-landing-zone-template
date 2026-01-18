# /loop - Ralph Wiggum Autonomous Loop

Run the Ralph Wiggum autonomous development loop with Beads task tracking.

## Usage

```
/loop [max-iterations]
```

## Description

This command runs an autonomous coding loop where the AI agent:

1. Reads available tasks from Beads (`bd ready`)
2. Chooses the highest-priority unblocked task
3. Claims the task (`bd update <id> --status=in_progress`)
4. Implements the task
5. Runs feedback loops (tests, lint, typecheck)
6. Completes the task (`bd close <id>`)
7. Commits changes and updates progress.txt
8. Repeats until all tasks complete or max iterations reached

## Arguments

- `max-iterations`: Maximum number of iterations (default: 20)

## Exit Signals

- `<promise>COMPLETE</promise>` - All tasks finished
- `<promise>BLOCKED: reason</promise>` - Needs human intervention

## Example

```bash
# Run with default 20 iterations
./scripts/ralph-loop.sh

# Run with 50 iterations
./scripts/ralph-loop.sh 50
```

## See Also

- `AGENTS.md` - Full Ralph Wiggum instructions
- `progress.txt` - Task completion log
- `bd ready` - View available tasks
