#!/bin/bash
set -euo pipefail

# PreToolUse hook for the Bash tool. Blocks firmware/flash tools and direct
# serial-device writes outright. Under bypassPermissions / --dangerously-skip-permissions
# there is no prompt to fall back to, so this denies the command instead of
# asking; the user must run it manually in their own terminal.
#
# Edit this list to add or remove hardware-affecting patterns.
# Each entry is an extended regex (grep -E) matched against the full command text.
HARDWARE_PATTERNS=(
  '(^|[/ ])arduino-cli([[:space:]]+.*)?[[:space:]]upload([[:space:]]|$)'
  '(^|[/ ])(platformio|pio)([[:space:]]+.*)?[[:space:]](run[[:space:]].*-t[[:space:]]+upload|upload)([[:space:]]|$)'
  '(^|[/ ])avrdude([[:space:]]|$)'
  '(^|[/ ])esptool(\.py)?([[:space:]]|$)'
  '(^|[/ ])st-flash([[:space:]]|$)'
  '(^|[/ ])dfu-util([[:space:]]|$)'
  '(^|[/ ])openocd([[:space:]]|$)'
  '/dev/tty[A-Za-z0-9._-]*'
  '/dev/cu\.[A-Za-z0-9._-]*'
)

INPUT=$(cat)
TOOL_NAME=$(jq -r '.tool_name // empty' <<<"$INPUT")
COMMAND=$(jq -r '.tool_input.command // empty' <<<"$INPUT")

if [ "$TOOL_NAME" != "Bash" ] || [ -z "$COMMAND" ]; then
  exit 0
fi

for pattern in "${HARDWARE_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -Eq "$pattern"; then
    jq -n --arg reason "Hardware-affecting command blocked (matched: $pattern). This can flash firmware or write directly to a serial device. Run it manually in your own terminal instead." \
      '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $reason}}'
    exit 0
  fi
done

exit 0
