param(
  [ValidateSet("clone", "fetch", "status", "remote", "ls-remote")]
  [string]$Action = "status",

  [string]$RepoDir = $env:ATHENA_REPO_DIR,
  [string]$RepoUrl = "https://dev.azure.com/nousdemos/DataEdgePlus/_git/athena-dbx-platform"
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RepoDir)) {
  $RepoDir = Join-Path (Get-Location).Path "athena-dbx-platform"
}

function Get-AdoAuthHeader {
  $pat = $env:ADO_ATHENA_PAT
  if ([string]::IsNullOrWhiteSpace($pat)) {
    $securePat = Read-Host "Azure DevOps PAT for Athena" -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePat)
    try {
      $pat = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    } finally {
      if ($ptr -ne [IntPtr]::Zero) {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
      }
    }
  }

  if ([string]::IsNullOrWhiteSpace($pat)) {
    throw "No Azure DevOps PAT was provided."
  }

  $bytes = [Text.Encoding]::ASCII.GetBytes(":$pat")
  $basic = [Convert]::ToBase64String($bytes)
  return "Authorization: Basic $basic"
}

function Invoke-GitWithPat {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$GitArgs,
    [string]$WorkingDirectory
  )

  $header = Get-AdoAuthHeader
  if ($WorkingDirectory) {
    & git -C $WorkingDirectory -c "http.extraHeader=$header" @GitArgs
  } else {
    & git -c "http.extraHeader=$header" @GitArgs
  }
}

function Redact-SecretRemote {
  param([string]$Text)
  return ($Text -replace 'https://[^/@\s]+@dev\.azure\.com', 'https://<redacted>@dev.azure.com')
}

switch ($Action) {
  "clone" {
    if (Test-Path $RepoDir) {
      Write-Output "Repository already exists: $RepoDir"
      exit 0
    }

    $parent = Split-Path -Parent $RepoDir
    if (-not (Test-Path $parent)) {
      New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    Invoke-GitWithPat -GitArgs @("clone", $RepoUrl, $RepoDir)
  }
  "fetch" {
    if (-not (Test-Path $RepoDir)) {
      throw "Repository path does not exist: $RepoDir"
    }
    Invoke-GitWithPat -WorkingDirectory $RepoDir -GitArgs @("fetch", "--all", "--prune")
  }
  "status" {
    if (-not (Test-Path $RepoDir)) {
      Write-Output "Repository path does not exist: $RepoDir"
      exit 1
    }
    & git -C $RepoDir status --short --branch
  }
  "remote" {
    if (-not (Test-Path $RepoDir)) {
      throw "Repository path does not exist: $RepoDir"
    }
    $remoteText = & git -C $RepoDir remote -v
    $remoteText | ForEach-Object { Redact-SecretRemote $_ }
  }
  "ls-remote" {
    Invoke-GitWithPat -GitArgs @("ls-remote", "--heads", $RepoUrl)
  }
}
