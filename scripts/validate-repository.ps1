[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot

$expected = [ordered]@{
    'databricks-engineering' = @(
        'databricks-agent-bricks', 'databricks-aibi-dashboards', 'databricks-ai-functions',
        'databricks-apps-python', 'databricks-bundles', 'databricks-config', 'databricks-dbsql',
        'databricks-docs', 'databricks-execution-compute', 'databricks-genie', 'databricks-iceberg',
        'databricks-jobs', 'databricks-lakebase-autoscale', 'databricks-lakebase-provisioned',
        'databricks-metric-views', 'databricks-mlflow-evaluation', 'databricks-model-serving',
        'databricks-python-sdk', 'databricks-spark-declarative-pipelines',
        'databricks-spark-structured-streaming', 'databricks-synthetic-data-gen',
        'databricks-unity-catalog', 'databricks-unstructured-pdf-generation',
        'databricks-vector-search', 'databricks-zerobus-ingest'
    )
    'datavault4dbt' = @(
        'configuring-datavault4dbt', 'rehashing-datavault4dbt-entities',
        'testing-a-datavault4dbt-project', 'troubleshooting-datavault4dbt',
        'using-datavault4dbt'
    )
    'engineering-quality' = @(
        'code-reviewer', 'secure-code-guardian', 'security-reviewer', 'spec-miner', 'test-master'
    )
    'data-ai-apps' = @(
        'fastapi-expert', 'prompt-engineer', 'rag-architect', 'react-expert', 'spark-python-data-source'
    )
    'athena-internal' = @('ado-athena-databricks')
    'data-engineering-core' = @(
        'using-data-engineering-agent-skills', 'using-data-agent-skills', 'data-specification',
        'pipeline-planning-and-task-breakdown', 'data-quality-and-contract-testing',
        'data-resiliency-testing-and-failure-injection', 'data-observability-and-sla-management',
        'incident-triage-and-pipeline-recovery'
    )
}

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}

function Read-Json {
    param([string]$Path)
    Assert-True (Test-Path -LiteralPath $Path -PathType Leaf) "Missing JSON file: $Path"
    Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
}

function Get-TreeSha256 {
    param([string]$Path)
    $resolved = (Resolve-Path -LiteralPath $Path).Path.TrimEnd('\')
    $records = foreach ($file in Get-ChildItem -LiteralPath $resolved -Recurse -File | Sort-Object FullName) {
        $relative = $file.FullName.Substring($resolved.Length + 1).Replace('\', '/')
        $hash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        "$relative`0$hash"
    }
    $payload = [Text.Encoding]::UTF8.GetBytes(($records -join "`n"))
    $hasher = [Security.Cryptography.SHA256]::Create()
    try {
        ([BitConverter]::ToString($hasher.ComputeHash($payload))).Replace('-', '').ToLowerInvariant()
    }
    finally {
        $hasher.Dispose()
    }
}

$codexMarketplace = Read-Json (Join-Path $repoRoot '.agents\plugins\marketplace.json')
$claudeMarketplace = Read-Json (Join-Path $repoRoot '.claude-plugin\marketplace.json')
$lock = Read-Json (Join-Path $repoRoot 'skill-lock.json')

Assert-True ($codexMarketplace.name -eq 'kdata-agent-skills') 'Unexpected Codex marketplace name.'
Assert-True ($claudeMarketplace.name -eq 'kdata-agent-skills') 'Unexpected Claude marketplace name.'
Assert-True (@($codexMarketplace.plugins).Count -eq 6) 'Codex marketplace must contain six plugins.'
Assert-True (@($claudeMarketplace.plugins).Count -eq 6) 'Claude marketplace must contain six plugins.'
Assert-True ([int]$lock.skillCount -eq 49) 'skill-lock.json must contain 49 skill directories.'

$allSkills = @()
foreach ($plugin in $expected.Keys) {
    $pluginRoot = Join-Path $repoRoot "plugins\$plugin"
    $portable = Read-Json (Join-Path $pluginRoot 'plugin.json')
    $codex = Read-Json (Join-Path $pluginRoot '.codex-plugin\plugin.json')
    $claude = Read-Json (Join-Path $pluginRoot '.claude-plugin\plugin.json')

    Assert-True ($portable.'$schema' -eq 'https://agent-plugins.org/schemas/1.0.0/plugin.schema.json') "Portable schema missing for $plugin."
    Assert-True ($portable.name -eq $plugin) "Portable manifest name mismatch for $plugin."
    Assert-True ($codex.name -eq $plugin) "Codex manifest name mismatch for $plugin."
    Assert-True ($claude.name -eq $plugin) "Claude manifest name mismatch for $plugin."
    Assert-True ($portable.version -eq '1.0.0' -and $codex.version -eq '1.0.0' -and $claude.version -eq '1.0.0') "Version mismatch for $plugin."
    Assert-True ($codex.skills -eq './skills/' -and $claude.skills -eq './skills/') "Skills path mismatch for $plugin."

    $codexEntry = @($codexMarketplace.plugins | Where-Object name -eq $plugin)
    $claudeEntry = @($claudeMarketplace.plugins | Where-Object name -eq $plugin)
    Assert-True ($codexEntry.Count -eq 1) "Codex marketplace entry missing or duplicated for $plugin."
    Assert-True ($claudeEntry.Count -eq 1) "Claude marketplace entry missing or duplicated for $plugin."
    Assert-True ($codexEntry[0].source.path -eq "./plugins/$plugin") "Codex source path mismatch for $plugin."
    Assert-True ($claudeEntry[0].source -eq "./plugins/$plugin") "Claude source path mismatch for $plugin."
    Assert-True ($codexEntry[0].policy.installation -eq 'AVAILABLE') "Codex install policy mismatch for $plugin."
    Assert-True ($codexEntry[0].policy.authentication -eq 'ON_INSTALL') "Codex auth policy mismatch for $plugin."

    $skillRoot = Join-Path $pluginRoot 'skills'
    $actual = @(Get-ChildItem -LiteralPath $skillRoot -Directory | Select-Object -ExpandProperty Name | Sort-Object)
    $wanted = @($expected[$plugin] | Sort-Object)
    $difference = @(Compare-Object -ReferenceObject $wanted -DifferenceObject $actual)
    Assert-True ($difference.Count -eq 0) "Skill inventory mismatch for ${plugin}: $($difference | Out-String)"

    foreach ($skill in $wanted) {
        $skillPath = Join-Path $skillRoot $skill
        Assert-True (Test-Path -LiteralPath (Join-Path $skillPath 'SKILL.md') -PathType Leaf) "Missing SKILL.md for $skill."
        $lockEntry = @($lock.skills | Where-Object name -eq $skill)
        Assert-True ($lockEntry.Count -eq 1) "Lock entry missing or duplicated for $skill."
        Assert-True ($lockEntry[0].plugin -eq $plugin) "Lock plugin mismatch for $skill."
        $digest = Get-TreeSha256 -Path $skillPath
        Assert-True ($digest -eq $lockEntry[0].treeSha256) "Packaged hash mismatch for $skill."
        $allSkills += $skill
    }
}

Assert-True ($allSkills.Count -eq 49) 'Expected 49 packaged skill directories.'
Assert-True (@($allSkills | Group-Object | Where-Object Count -gt 1).Count -eq 0) 'A skill name appears in more than one plugin.'

$forbidden = @(Get-ChildItem -LiteralPath (Join-Path $repoRoot 'plugins') -Recurse -File | Where-Object {
    $_.Name -match '^(\.env(?:\..*)?|id_rsa|id_ed25519|credentials(?:\.json)?)$' -or
    $_.Extension -in @('.pem', '.pfx', '.key')
})
Assert-True ($forbidden.Count -eq 0) "Potential credential files found: $($forbidden.FullName -join ', ')"

Write-Host 'PASS: 6 plugins, 49 unique skill directories, dual manifests, marketplace paths, policies, and content hashes validated.'
