[CmdletBinding()]
param(
    [string]$SourceRoot = (Join-Path $env:USERPROFILE '.agents\skills'),
    [string]$OutputPath = (Join-Path (Split-Path -Parent $PSScriptRoot) 'skill-lock.json')
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot

$groups = [ordered]@{
    'databricks-engineering' = @(
        'databricks-agent-bricks',
        'databricks-aibi-dashboards',
        'databricks-ai-functions',
        'databricks-apps-python',
        'databricks-bundles',
        'databricks-config',
        'databricks-dbsql',
        'databricks-docs',
        'databricks-execution-compute',
        'databricks-genie',
        'databricks-iceberg',
        'databricks-jobs',
        'databricks-lakebase-autoscale',
        'databricks-lakebase-provisioned',
        'databricks-metric-views',
        'databricks-mlflow-evaluation',
        'databricks-model-serving',
        'databricks-python-sdk',
        'databricks-spark-declarative-pipelines',
        'databricks-spark-structured-streaming',
        'databricks-synthetic-data-gen',
        'databricks-unity-catalog',
        'databricks-unstructured-pdf-generation',
        'databricks-vector-search',
        'databricks-zerobus-ingest'
    )
    'datavault4dbt' = @(
        'configuring-datavault4dbt',
        'rehashing-datavault4dbt-entities',
        'testing-a-datavault4dbt-project',
        'troubleshooting-datavault4dbt',
        'using-datavault4dbt'
    )
    'engineering-quality' = @(
        'code-reviewer',
        'secure-code-guardian',
        'security-reviewer',
        'spec-miner',
        'test-master'
    )
    'data-ai-apps' = @(
        'fastapi-expert',
        'prompt-engineer',
        'rag-architect',
        'react-expert',
        'spark-python-data-source'
    )
    'athena-internal' = @('ado-athena-databricks')
    'data-engineering-core' = @(
        'using-data-engineering-agent-skills',
        'using-data-agent-skills',
        'data-specification',
        'pipeline-planning-and-task-breakdown',
        'data-quality-and-contract-testing',
        'data-resiliency-testing-and-failure-injection',
        'data-observability-and-sla-management',
        'incident-triage-and-pipeline-recovery'
    )
}

function Get-TreeSha256 {
    param([Parameter(Mandatory)][string]$Path)

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

function Get-SourceMetadata {
    param(
        [Parameter(Mandatory)][string]$Plugin,
        [Parameter(Mandatory)][string]$Skill
    )

    if ($Plugin -eq 'data-engineering-core') {
        return [ordered]@{
            repository = 'https://github.com/vaquarkhan/data-engineering-agent-skills'
            reference = '421ef57e8d42c464b29339193c18dd5bd2946bc2'
            license = 'MIT'
        }
    }
    if ($Plugin -eq 'datavault4dbt') {
        return [ordered]@{
            repository = 'https://github.com/ScalefreeCOM/datavault4dbt-agent-skills'
            reference = 'e72ce0f2a2342ff985236f1ca05400bdbb6786ca'
            license = 'Apache-2.0'
        }
    }
    if ($Plugin -eq 'engineering-quality' -or ($Plugin -eq 'data-ai-apps' -and $Skill -ne 'spark-python-data-source')) {
        return [ordered]@{
            repository = 'https://github.com/Jeffallan/claude-skills'
            reference = 'installed-local-snapshot-2026-09-17'
            license = 'MIT'
        }
    }
    if ($Plugin -eq 'databricks-engineering' -or $Skill -eq 'spark-python-data-source') {
        return [ordered]@{
            repository = 'https://github.com/databricks-solutions/ai-dev-kit'
            reference = 'installed-local-snapshot-2026-09-17'
            license = 'LicenseRef-Databricks'
        }
    }
    return [ordered]@{
        repository = 'internal-local'
        reference = 'installed-local-snapshot-2026-09-17'
        license = 'LicenseRef-Proprietary'
    }
}

$entries = @()
foreach ($plugin in $groups.Keys) {
    foreach ($skill in $groups[$plugin]) {
        $packagedPath = Join-Path $repoRoot "plugins\$plugin\skills\$skill"
        if (-not (Test-Path -LiteralPath (Join-Path $packagedPath 'SKILL.md') -PathType Leaf)) {
            throw "Missing packaged skill: $packagedPath"
        }

        $sourcePath = Join-Path $SourceRoot $skill
        $sourceDigest = $null
        if (Test-Path -LiteralPath $sourcePath -PathType Container) {
            $sourceDigest = Get-TreeSha256 -Path $sourcePath
        }
        $packagedDigest = Get-TreeSha256 -Path $packagedPath
        if ($plugin -eq 'data-engineering-core') {
            $sourceDigest = $packagedDigest
        }
        $isPackagedAdaptation = $plugin -eq 'athena-internal'
        if ($sourceDigest -and $sourceDigest -ne $packagedDigest -and -not $isPackagedAdaptation) {
            throw "Packaged skill differs from source: $skill"
        }

        $source = Get-SourceMetadata -Plugin $plugin -Skill $skill
        $entries += [ordered]@{
            name = $skill
            plugin = $plugin
            packagedPath = "plugins/$plugin/skills/$skill"
            treeSha256 = $packagedDigest
            sourceTreeSha256 = $sourceDigest
            packagedAdaptation = $isPackagedAdaptation
            source = $source
        }
    }
}

$lock = [ordered]@{
    schemaVersion = 1
    packageVersion = '1.2.0'
    snapshotDate = '2026-09-17'
    hashFormat = 'sha256(sorted relative-path NUL file-sha256 records joined by LF)'
    skillCount = $entries.Count
    skills = $entries
}

$json = $lock | ConvertTo-Json -Depth 8
$encoding = New-Object Text.UTF8Encoding($false)
[IO.File]::WriteAllText($OutputPath, $json + [Environment]::NewLine, $encoding)
Write-Host "Wrote $($entries.Count) skill records to $OutputPath"
