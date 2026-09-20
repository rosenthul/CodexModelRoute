$ErrorActionPreference = 'Stop'

try {
    $eventData = [Console]::In.ReadToEnd() | ConvertFrom-Json
    $model = [string]$eventData.model
    if ($model -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$') {
        $model = 'unavailable'
    }
} catch {
    $model = 'unavailable'
}

$result = @{
    hookSpecificOutput = @{
        hookEventName = 'UserPromptSubmit'
        additionalContext = "codex-model-routing runtime: active_model=$model; active_effort=unavailable. The model comes from the UserPromptSubmit hook; this hook does not expose reasoning effort."
    }
}

[Console]::WriteLine(($result | ConvertTo-Json -Compress -Depth 4))
