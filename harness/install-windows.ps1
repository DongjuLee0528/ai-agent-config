$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$skills = @(
    'api-contract-review', 'claudex-loop', 'codex-build', 'codex-review',
    'dual-agent-development', 'embedded-security-review', 'graphify',
    'hardware-control-review', 'hardware-debugging', 'ml-data-model-review',
    'security-review', 'software-debugging'
)

foreach ($root in @((Join-Path $HOME '.claude\skills'), (Join-Path $HOME '.agents\skills'))) {
    New-Item -ItemType Directory -Force -Path $root | Out-Null
    foreach ($skill in $skills) {
        $target = Join-Path $root $skill
        if (Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue) {
            Write-Warning "Existing skill entry, check manually: $target"
            continue
        }
        New-Item -ItemType Junction -Path $target -Target (Join-Path $repo "skills\$skill") | Out-Null
    }
}

$claudeRoot = Join-Path $HOME '.claude'
$hookRoot = Join-Path $claudeRoot 'hooks'
New-Item -ItemType Directory -Force -Path $hookRoot | Out-Null
$hook = Join-Path $hookRoot 'block-hardware-commands.ps1'
if (Get-Item -LiteralPath $hook -Force -ErrorAction SilentlyContinue) {
    Write-Warning "Existing hook, check manually: $hook"
} else {
    Copy-Item -LiteralPath (Join-Path $repo 'harness\claude\hooks\block-hardware-commands.ps1') -Destination $hook
}

$settingsPath = Join-Path $claudeRoot 'settings.json'
$settings = if (Test-Path -LiteralPath $settingsPath) {
    Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json
} else { [pscustomobject]@{} }
$template = Get-Content -LiteralPath (Join-Path $repo 'harness\claude\settings.json') -Raw | ConvertFrom-Json
if ($settings.PSObject.Properties['permissions'] -and $null -eq $settings.permissions) {
    $settings.permissions = [pscustomobject]@{}
} elseif (-not $settings.PSObject.Properties['permissions']) {
    $settings | Add-Member -NotePropertyName permissions -NotePropertyValue ([pscustomobject]@{})
}
$deny = @($settings.permissions.deny | Where-Object { $_ })
foreach ($rule in $template.permissions.deny) {
    if ($rule -notin $deny) { $deny += $rule }
    if ($rule.StartsWith('Bash(')) {
        $powerShellRule = 'PowerShell(' + $rule.Substring(5)
        if ($powerShellRule -notin $deny) { $deny += $powerShellRule }
    }
}
if ($settings.permissions.PSObject.Properties['deny']) {
    $settings.permissions.deny = $deny
} else {
    $settings.permissions | Add-Member -NotePropertyName deny -NotePropertyValue $deny
}

if ($settings.PSObject.Properties['hooks'] -and $null -eq $settings.hooks) {
    $settings.hooks = [pscustomobject]@{}
} elseif (-not $settings.PSObject.Properties['hooks']) {
    $settings | Add-Member -NotePropertyName hooks -NotePropertyValue ([pscustomobject]@{})
}
$preToolUse = @($settings.hooks.PreToolUse | Where-Object { $_ })
$hookCommand = 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' + $hook + '"'
$alreadyRegistered = @($preToolUse | Where-Object {
    @($_.hooks | Where-Object { $_.command -eq $hookCommand }).Count -gt 0
}).Count -gt 0
if (-not $alreadyRegistered) {
    $preToolUse += [pscustomobject]@{
        matcher = 'Bash|PowerShell'
        hooks = @([pscustomobject]@{ type = 'command'; command = $hookCommand })
    }
}
if ($settings.hooks.PSObject.Properties['PreToolUse']) {
    $settings.hooks.PreToolUse = $preToolUse
} else {
    $settings.hooks | Add-Member -NotePropertyName PreToolUse -NotePropertyValue $preToolUse
}
$json = $settings | ConvertTo-Json -Depth 30
[IO.File]::WriteAllText($settingsPath, $json, (New-Object System.Text.UTF8Encoding $false))

$claudeInstructions = Join-Path $claudeRoot 'CLAUDE.md'
if (-not (Get-Item -LiteralPath $claudeInstructions -Force -ErrorAction SilentlyContinue)) {
    Copy-Item -LiteralPath (Join-Path $repo 'harness\claude\CLAUDE.md') -Destination $claudeInstructions
}

$codexRoot = Join-Path $HOME '.codex'
New-Item -ItemType Directory -Force -Path (Join-Path $codexRoot 'rules') | Out-Null
$codexFiles = @{
    'harness\codex\rules\harness.rules' = 'rules\harness.rules'
    'harness\codex\review.config.toml' = 'review.config.toml'
}
foreach ($source in $codexFiles.Keys) {
    $target = Join-Path $codexRoot $codexFiles[$source]
    if (Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue) {
        Write-Warning "Existing Codex file, check manually: $target"
    } else {
        Copy-Item -LiteralPath (Join-Path $repo $source) -Destination $target
    }
}

Write-Host 'Skills and harness files installed. Review ~/.codex/config.toml as described in README.md.'
