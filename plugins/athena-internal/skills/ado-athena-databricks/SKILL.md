---
name: ado-athena-databricks
description: Work with the Azure DevOps Athena Databricks platform repository at https://dev.azure.com/nousdemos/DataEdgePlus/_git/athena-dbx-platform. Use when Codex needs to clone, fetch, inspect, modify, branch, or prepare pull requests for the Athena Databricks repo, or when coordinating Azure DevOps Git work with Databricks AI Dev Kit workflows, Databricks Asset Bundles, jobs, Unity Catalog, pipelines, or workspace deployment tasks.
---

# ADO Athena Databricks

## Overview

Use this skill for repository-aware work on the Athena Databricks platform project in Azure DevOps. Pair this skill with the installed Databricks AI Dev Kit skills and the Databricks MCP server when the task spans both source control and Databricks workspace resources.

## Constants

- Azure DevOps repo: `https://dev.azure.com/nousdemos/DataEdgePlus/_git/athena-dbx-platform`
- Repo name: `athena-dbx-platform`
- Default local path: `$env:ATHENA_REPO_DIR` when set; otherwise `athena-dbx-platform` under the current working directory
- Default Databricks CLI profile for Athena work: `databricks_qa`
- Helper script: `scripts/athena_repo.ps1`, resolved relative to this `SKILL.md`

## Credential Rules

Do not save Azure DevOps PATs, passwords, or tokens inside the skill, repository files, remotes, scripts, logs, or final answers. Use one of these approaches:

1. Prefer Git Credential Manager when the user has already authenticated with Azure DevOps.
2. For non-interactive Git reads, use a process-local `ADO_ATHENA_PAT` environment variable.
3. If a PAT is missing, ask the user to set `ADO_ATHENA_PAT` in the current shell or authenticate with Git Credential Manager.
4. Never print the PAT or construct a remote URL containing the PAT.

The helper script prompts securely for the PAT when `ADO_ATHENA_PAT` is not already set. If the user wants a non-interactive run, ask them to set `ADO_ATHENA_PAT` in their current shell without pasting the value in chat.

Do not make `ADO_ATHENA_PAT` a persistent user or machine environment variable unless the user explicitly asks for persistent storage.

## Quick Start

Check whether the repo exists locally:

```powershell
$repoDir = if ($env:ATHENA_REPO_DIR) { $env:ATHENA_REPO_DIR } else { Join-Path (Get-Location) 'athena-dbx-platform' }
Test-Path -LiteralPath $repoDir
```

Resolve the helper relative to the installed skill directory. In Claude Code, the plugin root is available as `CLAUDE_PLUGIN_ROOT`:

```powershell
$helper = Join-Path $env:CLAUDE_PLUGIN_ROOT 'skills\ado-athena-databricks\scripts\athena_repo.ps1'
```

In Codex, use the actual directory containing this `SKILL.md` and join it with `scripts\athena_repo.ps1`. Do not assume a user-specific installation path.

Clone using the helper script after `ADO_ATHENA_PAT` is set, optionally supplying `-RepoDir`:

```powershell
& $helper -Action clone -RepoDir $repoDir
```

Fetch safely:

```powershell
& $helper -Action fetch -RepoDir $repoDir
```

Inspect local status:

```powershell
& $helper -Action status -RepoDir $repoDir
```

## Workflow

1. Confirm the user wants to work on Athena and identify the Databricks profile, defaulting to `databricks_qa`.
2. Confirm the local repo path. Prefer an explicit user-provided path, then `$env:ATHENA_REPO_DIR`, then `athena-dbx-platform` under the current working directory.
3. Read existing repo guidance first: `AGENTS.md`, `.agents/skills`, `.codex/config.toml`, `README`, bundle files, and CI definitions if present.
4. Use Databricks AI Dev Kit skills for Databricks-specific work:
   - `databricks-bundles` for Asset Bundles.
   - `databricks-jobs` for job definitions and runs.
   - `databricks-dbsql` for SQL warehouses and queries.
   - `databricks-unity-catalog` for UC objects and grants.
   - `databricks-spark-declarative-pipelines` for pipelines.
5. Use Databricks MCP for live workspace reads and safe changes. Ask before creating, deleting, deploying, pushing, or starting cost-bearing compute.
6. Keep Git changes scoped. Prefer a branch named with the `codex/` prefix unless the user asks for a different branch name.
7. Before final delivery, run the smallest relevant validation commands from the repo and report the results.

## Common Prompts

- "Use ADO Athena Databricks to clone or update the Athena repo, then inspect Databricks bundle structure."
- "Use Athena repo context and Databricks MCP to review jobs deployed to databricks_qa."
- "Create a Databricks Asset Bundle change in Athena and prepare an ADO branch."
- "Review Athena Unity Catalog permissions code against the live databricks_qa workspace."

## Safety Checks

- Never commit PATs, `.env` files, Databricks tokens, Azure DevOps tokens, or local config containing secrets.
- Never rewrite Git remotes to include credentials.
- Use read-only Databricks operations first when discovering state.
- Ask before running `git push`, Databricks deploys, cluster starts, job runs, grants changes, deletes, or production data writes.
