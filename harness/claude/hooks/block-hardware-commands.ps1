$ErrorActionPreference = 'Stop'

try {
    $event = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
    exit 2
}

if ($event.tool_name -notin @('Bash', 'PowerShell')) { exit 0 }
$command = [string]$event.tool_input.command
if (-not $command) { exit 0 }

$patterns = @(
    '(?i)(^|[\\/\s])arduino-cli(?:\.exe)?\b.*\bupload\b',
    '(?i)(^|[\\/\s])(?:platformio|pio)(?:\.exe)?\b.*\bupload\b',
    '(?i)(^|[\\/\s])(?:avrdude|esptool(?:\.py)?|st-flash|dfu-util|openocd)(?:\.exe)?\b',
    '(?i)(?:/dev/(?:tty|cu\.)|\\\\\.\\COM\d+\b)'
)

foreach ($pattern in $patterns) {
    if ($command -match $pattern) {
        @{
            hookSpecificOutput = @{
                hookEventName = 'PreToolUse'
                permissionDecision = 'deny'
                permissionDecisionReason = 'Hardware-affecting command blocked. Run it manually in your own terminal.'
            }
        } | ConvertTo-Json -Depth 3 -Compress
        exit 0
    }
}
