#!/bin/bash
# ralph-loop.sh - Autonomous AFK loop for Beads
# 
# Prerequisites:
# - opencode installed
# - beads installed and initialized (bd init)
# - Tasks created via bd create

set -e

MAX_ITERATIONS=${1:-20}

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

# Create progress.txt if it doesn't exist
if [[ ! -f "progress.txt" ]]; then
    echo "# Progress Log" > progress.txt
fi

echo "Starting Ralph Loop (max $MAX_ITERATIONS iterations)"
echo "================================================"
echo "Press Ctrl+C to stop gracefully"
echo ""

PROMPT="@AGENTS.md @progress.txt

You are in Ralph Wiggum mode with Beads for task tracking.
This is an AWS Landing Zone Template project.

## Your Task This Iteration

1. RUN \`bd ready\` to see available tasks
2. CHECK progress.txt to see what's already done
3. CHOOSE the highest-priority ready task based on:
   - Priority (P0 first, then P1, etc.)
   - Architectural decisions first
   - Integration points second
4. CLAIM the task: \`bd update <task-id> --status=in_progress\`
5. IMPLEMENT only that single task
6. RUN feedback loops:
   - For Terraform: terraform init -backend=false && terraform validate && terraform fmt -check
   - For Docs: npm run build (in docs/ directory)
7. FIX any failures before proceeding
8. COMPLETE the task: \`bd close <task-id> --reason='What was done'\`
9. SYNC beads: \`bd sync\`
10. COMMIT with clear message
11. APPEND to progress.txt:
    [TIMESTAMP] Task: <task-id> - <title>
    - What was implemented
    - Key decisions
    - Files changed

12. If \`bd ready\` returns empty (no more tasks), output: <promise>COMPLETE</promise>
13. If blocked or need human input, output: <promise>BLOCKED: reason</promise>

IMPORTANT: Only work on ONE task per iteration."

for ((i=1; i<=$MAX_ITERATIONS; i++)); do
    echo ""
    echo "================================================"
    echo "Iteration $i of $MAX_ITERATIONS"
    echo "================================================"
    
    # Check if there are tasks remaining
    READY_COUNT=$(bd ready 2>/dev/null | grep -c "^lz-" || echo "0")
    if [[ "$READY_COUNT" == "0" ]]; then
        echo "No tasks ready. Checking if all done..."
    fi
    
    result=$(opencode -p "$PROMPT" 2>&1) || true
    
    echo "$result"
    
    if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
        echo ""
        echo "================================================"
        echo "ALL TASKS COMPLETE after $i iterations!"
        echo "Run: bd sync && git push"
        echo "================================================"
        exit 0
    fi
    
    if [[ "$result" == *"<promise>BLOCKED:"* ]]; then
        echo ""
        echo "================================================"
        echo "BLOCKED - Human intervention required"
        echo "Check progress.txt for details"
        echo "================================================"
        exit 1
    fi
    
    sleep 2
done

echo ""
echo "================================================"
echo "Max iterations ($MAX_ITERATIONS) reached"
echo "Run: bd ready   to see remaining tasks"
echo "================================================"
