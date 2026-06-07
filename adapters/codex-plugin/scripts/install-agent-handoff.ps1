param(
    [string]$TargetPath = ".",
    [switch]$Force,
    [switch]$WithCodexCommand = $true,
    [switch]$WithClaudeCommand = $true,
    [switch]$WithCursorRule = $true
)

$ErrorActionPreference = "Stop"

function Copy-Template($Source, $Destination) {
    $destinationDir = Split-Path -Parent $Destination
    if ($destinationDir) {
        New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
    }

    if ((Test-Path -LiteralPath $Destination) -and -not $Force) {
        Write-Output "exists: $Destination"
        return
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Force
    Write-Output "installed: $Destination"
}

$pluginRoot = Split-Path -Parent $PSScriptRoot
$templateRoot = Join-Path $pluginRoot "templates"
$targetRoot = (Resolve-Path -LiteralPath $TargetPath).Path

Copy-Template (Join-Path $templateRoot "AGENTS.md") (Join-Path $targetRoot "AGENTS.md")
Copy-Template (Join-Path $templateRoot "CLAUDE.md") (Join-Path $targetRoot "CLAUDE.md")
Copy-Template (Join-Path $templateRoot ".agents/state.md") (Join-Path $targetRoot ".agents/state.md")
Copy-Template (Join-Path $pluginRoot "scripts/validate-agent-state.ps1") (Join-Path $targetRoot "scripts/validate-agent-state.ps1")

if ($WithCodexCommand) {
    Copy-Template (Join-Path $templateRoot ".codex/commands/handoff.md") (Join-Path $targetRoot ".codex/commands/handoff.md")
}

if ($WithClaudeCommand) {
    Copy-Template (Join-Path $templateRoot ".claude/commands/handoff.md") (Join-Path $targetRoot ".claude/commands/handoff.md")
}

if ($WithCursorRule) {
    Copy-Template (Join-Path $templateRoot ".cursor/rules/agent-handoff.mdc") (Join-Path $targetRoot ".cursor/rules/agent-handoff.mdc")
}

Push-Location $targetRoot
try {
    powershell -ExecutionPolicy Bypass -File "scripts/validate-agent-state.ps1"
}
finally {
    Pop-Location
}
