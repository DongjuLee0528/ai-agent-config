#!/bin/bash
set -euo pipefail

# Prevent recursive reviewer invocation.
if [ "${DUAL_AGENT_ROLE:-}" = "reviewer" ]; then
  echo "Recursive reviewer invocation blocked." >&2
  exit 2
fi

# Require project directory.
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <project-directory> <handoff-file>" >&2
  exit 2
fi

PROJECT_DIR="$(cd "$1" && pwd)"
HANDOFF_FILE="$2"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/../prompts/reviewer.md"

# Verify Claude Code CLI.
if ! command -v claude >/dev/null 2>&1; then
  echo "Claude Code CLI is not installed or not available in PATH." >&2
  exit 3
fi

# Verify reviewer prompt.
if [ ! -f "$PROMPT_FILE" ]; then
  echo "Reviewer prompt not found: $PROMPT_FILE" >&2
  exit 4
fi

if [ ! -f "$HANDOFF_FILE" ]; then
  echo "Handoff file not found: $HANDOFF_FILE" >&2
  exit 5
fi
HANDOFF_FILE="$(cd "$(dirname "$HANDOFF_FILE")" && pwd)/$(basename "$HANDOFF_FILE")"

TIMEOUT_SECONDS="${DUAL_AGENT_TIMEOUT_SECONDS:-1200}"

cd "$PROJECT_DIR"

REVIEW_PROMPT="$(cat "$PROMPT_FILE")

Project directory:
$PROJECT_DIR

Implementer handoff:
$(cat "$HANDOFF_FILE")

Review the current implementation in this repository.

Independently inspect the actual repository state, Git diff, modified files,
relevant call paths, tests, configuration, external contracts, and affected
behavior.

Do not trust the implementer's summary as evidence.

Complete the full reasonable review scope even if you discover problems early.
Collect all material findings before producing the final verdict.

Do not modify any project files.
Do not fix discovered issues.
Do not invoke another coding agent.
Do not invoke the dual-agent workflow recursively.
"

export DUAL_AGENT_ROLE="reviewer"

run_claude() {
  claude \
    --print \
    --permission-mode plan \
    "$REVIEW_PROMPT"
}

if command -v timeout >/dev/null 2>&1; then
  timeout "$TIMEOUT_SECONDS" \
    claude \
      --print \
      --permission-mode plan \
      "$REVIEW_PROMPT"
elif command -v gtimeout >/dev/null 2>&1; then
  gtimeout "$TIMEOUT_SECONDS" \
    claude \
      --print \
      --permission-mode plan \
      "$REVIEW_PROMPT"
else
  echo "Warning: timeout command is unavailable; running Claude without an external timeout." >&2
  run_claude
fi
