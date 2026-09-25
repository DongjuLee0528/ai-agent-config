#!/bin/bash
set -euo pipefail

if [ "${DUAL_AGENT_ROLE:-}" = "reviewer" ]; then
  echo "Recursive reviewer invocation blocked."
  exit 2
fi

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <project-directory> <handoff-file>"
  exit 2
fi

PROJECT_DIR="$(cd "$1" && pwd)"
HANDOFF_FILE="$2"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/../prompts/reviewer.md"

if ! command -v codex >/dev/null 2>&1; then
  echo "Codex CLI is not installed or not available in PATH."
  exit 3
fi

if [ ! -f "$PROMPT_FILE" ]; then
  echo "Reviewer prompt not found: $PROMPT_FILE"
  exit 4
fi

if [ ! -f "$HANDOFF_FILE" ]; then
  echo "Handoff file not found: $HANDOFF_FILE"
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

Inspect the actual repository state, current diff, relevant files, tests, and affected behavior.

Do not modify any files.
"

export DUAL_AGENT_ROLE="reviewer"

if command -v timeout >/dev/null 2>&1; then
  timeout "$TIMEOUT_SECONDS" \
    codex exec --sandbox read-only "$REVIEW_PROMPT"
elif command -v gtimeout >/dev/null 2>&1; then
  gtimeout "$TIMEOUT_SECONDS" \
    codex exec --sandbox read-only "$REVIEW_PROMPT"
else
  codex exec --sandbox read-only "$REVIEW_PROMPT"
fi
