param(
    [string]$StatePath = ".agents/state.md",
    [int]$MaxLines = 90,
    [int]$MaxChars = 7000
)

$ErrorActionPreference = "Stop"

function Fail($Message) {
    Write-Error "Agent state validation failed: $Message"
    exit 1
}

if (-not (Test-Path -LiteralPath $StatePath)) {
    Fail "missing $StatePath"
}

$content = Get-Content -LiteralPath $StatePath -Raw
$lines = $content -split "`r?`n"

if ($lines.Count -gt $MaxLines) {
    Fail "$StatePath has $($lines.Count) lines; limit is $MaxLines. Replace old details instead of appending."
}

if ($content.Length -gt $MaxChars) {
    Fail "$StatePath has $($content.Length) characters; limit is $MaxChars. Compress the handoff context."
}

$required = @(
    "# Project Agent State",
    "Last updated:",
    "## Project",
    "## Current Status",
    "## Key Decisions",
    "## Next Tasks",
    "## Latest Handoff"
)

foreach ($needle in $required) {
    if ($content -notmatch [regex]::Escape($needle)) {
        Fail "missing required section or marker: $needle"
    }
}

if ($content -match "## Handoff Log") {
    Fail "use '## Latest Handoff' instead of a growing handoff log"
}

$handoffHeadings = [regex]::Matches($content, "(?m)^### .+$")
if ($handoffHeadings.Count -ne 1) {
    Fail "expected exactly one latest handoff entry, found $($handoffHeadings.Count)"
}

$latestIndex = $content.IndexOf("## Latest Handoff")
$headingIndex = $content.IndexOf($handoffHeadings[0].Value)
if ($headingIndex -lt $latestIndex) {
    Fail "the single handoff entry must be under '## Latest Handoff'"
}

Write-Output "Agent state validation passed: $StatePath"
