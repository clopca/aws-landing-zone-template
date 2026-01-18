#!/bin/bash
# ralph-once.sh - Single iteration of Ralph Wiggum (human-in-the-loop mode)
# 
# Use this for learning Ralph or when you want to supervise each iteration

set -e

if ! command -v opencode &> /dev/null; then
    echo "Error: opencode is not installed"
    exit 1
fi

if ! command -v bd &> /dev/null; then
    echo "Error: beads (bd) is not installed"
    echo "Run: ./scripts/setup.sh"
    exit 1
fi

if [[ ! -d ".beads" ]]; then
    echo "Error: Beads not initialized. Run: ./scripts/setup.sh"
    exit 1
fi

echo "Running single Ralph iteration..."
echo "=================================="
echo ""

# Show current state
echo "Current ready tasks:"
bd ready
echo ""

PROMPT="@AGENTS.md @progress.txt

You are in Ralph Wiggum mode with Beads for task tracking.
This is an AWS Landing Zone Template project.

## Your Task This Iteration

1. RUN \`bd ready\` to see available tasks
2. CHECK progress.txt to see what's already done
3. CHOOSE the highest-priority ready task
4. CLAIM the task: \`bd update <task-id> --status=in_progress\`
5. IMPLEMENT only that single task
6. RUN feedback loops (validate, test, lint as appropriate)
7. FIX any failures before proceeding
8. COMPLETE the task: \`bd close <task-id> --reason='What was done'\`
9. SYNC beads: \`bd sync\`
10. COMMIT with clear message
11. APPEND to progress.txt

If all tasks complete, output: <promise>COMPLETE</promise>
If blocked, output: <promise>BLOCKED: reason</promise>

IMPORTANT: Only work on ONE task."

opencode -p "$PROMPT"
