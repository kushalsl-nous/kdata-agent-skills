# KData Agent Skills

`kdata-agent-skills` is a dual-marketplace repository for Codex and Claude Code. It packages 49 skill directories into six independently installable plugins. This includes 48 workflows and one upstream compatibility alias.

| Plugin | Skills | Purpose |
| --- | ---: | --- |
| `data-engineering-core` | 8 | Recommended Vaquarkhan core: specification, planning, quality, resiliency, observability, and recovery; includes 7 workflows plus 1 compatibility alias |
| `databricks-engineering` | 25 | Databricks SQL, pipelines, jobs, governance, apps, AI/BI, serving, and platform workflows |
| `datavault4dbt` | 5 | Data Vault 2.0 modelling with Scalefree `datavault4dbt` |
| `engineering-quality` | 5 | Code review, security, testing, and specification mining |
| `data-ai-apps` | 5 | FastAPI, React, RAG, prompt engineering, and Spark data sources |
| `athena-internal` | 1 | Internal Azure DevOps workflow for the Athena Databricks repository |

The same `skills/` folders are consumed by both clients. Each plugin also contains:

- a portable Agent Plugins `plugin.json`;
- a Codex compatibility manifest at `.codex-plugin/plugin.json`;
- a Claude manifest at `.claude-plugin/plugin.json`;
- applicable third-party license files.

## Install for Codex

After this repository is pushed to GitHub, add its marketplace once at user level:

```powershell
codex plugin marketplace add YOUR_GITHUB_ORG/kdata-agent-skills --ref main
```

For local testing from the repository root:

```powershell
codex plugin marketplace add .
```

Restart or refresh the Codex/ChatGPT desktop app, open the Plugins Directory, select the **KData Agent Skills** marketplace, and install only the plugin groups you need. A marketplace added to Codex is tracked across sessions; it does not need to be copied into every project.

## Install for Claude Code

Add the marketplace, then install selected plugins at user scope so they are available in every Claude Code project:

```powershell
claude plugin marketplace add YOUR_GITHUB_ORG/kdata-agent-skills
claude plugin install data-engineering-core@kdata-agent-skills --scope user
claude plugin install databricks-engineering@kdata-agent-skills --scope user
claude plugin install datavault4dbt@kdata-agent-skills --scope user
claude plugin install engineering-quality@kdata-agent-skills --scope user
claude plugin install data-ai-apps@kdata-agent-skills --scope user
claude plugin install athena-internal@kdata-agent-skills --scope user
```

For local testing, use the repository path instead of `YOUR_GITHUB_ORG/kdata-agent-skills`:

```powershell
claude plugin marketplace add .
```

Claude namespaces installed skills as `/plugin-name:skill-name`. Model-triggered selection also uses each skill's description.

## How to use the skills

Installing a plugin makes its skills available to the agent; it does not run anything automatically. A skill is used only when you invoke it or when the agent determines that your request matches the skill's description.

### Invoke a skill explicitly

Explicit invocation is recommended when you know which workflow you want.

| Client | How to invoke |
| --- | --- |
| Codex CLI or IDE extension | Run `/skills`, or type `$` and select a skill such as `$databricks-jobs` |
| ChatGPT Chat or Work | Type `@` and select the installed skill |
| Claude Code | Use `/plugin-name:skill-name`, for example `/datavault4dbt:using-datavault4dbt` |

Example Codex prompts:

```text
$using-data-engineering-agent-skills classify this pipeline request and identify the safest next workflow.

$databricks-jobs create a development job for the ingestion bundle and validate the configuration.

$using-datavault4dbt model customer and policy hubs, their link, and descriptive satellites from these staging columns.

$code-reviewer review the current diff for correctness, security, and performance problems.

$rag-architect design a production RAG pipeline for these policy documents and include an evaluation plan.
```

Equivalent Claude Code prompts:

```text
/data-engineering-core:using-data-engineering-agent-skills classify this pipeline request and identify the safest next workflow.

/databricks-engineering:databricks-jobs create a development job for the ingestion bundle and validate the configuration.

/datavault4dbt:using-datavault4dbt model customer and policy hubs, their link, and descriptive satellites from these staging columns.

/engineering-quality:code-reviewer review the current diff for correctness, security, and performance problems.

/data-ai-apps:rag-architect design a production RAG pipeline for these policy documents and include an evaluation plan.
```

### Let the agent select a skill automatically

You can also describe the outcome without naming a skill. Codex or Claude can load the matching workflow from its description.

```text
Configure datavault4dbt in this existing dbt project and use SHA-256 hash keys.

Create a serverless Databricks pipeline that ingests JSON incrementally with Auto Loader and applies SCD Type 2.

Review this FastAPI authentication implementation for OWASP vulnerabilities and add focused tests.

Diagnose why this Data Vault satellite captures unchanged records on every run.
```

For predictable results, include the platform, repository or files in scope, target environment, expected output, and whether the task is read-only or may make changes.

### Choose the right plugin

| Need | Install | Useful skills |
| --- | --- | --- |
| Define, plan, validate, or recover a data product safely | `data-engineering-core` | `using-data-engineering-agent-skills`, `data-specification`, `pipeline-planning-and-task-breakdown`, `data-quality-and-contract-testing` |
| Build or operate Databricks workloads | `databricks-engineering` | `databricks-config`, `databricks-bundles`, `databricks-jobs`, `databricks-spark-declarative-pipelines`, `databricks-dbsql` |
| Build a Data Vault 2.0 solution in dbt | `datavault4dbt` | `configuring-datavault4dbt`, `using-datavault4dbt`, `testing-a-datavault4dbt-project` |
| Review security, quality, and tests | `engineering-quality` | `code-reviewer`, `secure-code-guardian`, `security-reviewer`, `test-master` |
| Build APIs, React applications, RAG, or Spark connectors | `data-ai-apps` | `fastapi-expert`, `react-expert`, `rag-architect`, `spark-python-data-source` |
| Work with the internal Athena repository | `athena-internal` plus `databricks-engineering` | `ado-athena-databricks` and the relevant Databricks skill |

Install only the plugin groups you regularly need. The agent initially sees skill names and descriptions and loads the full instructions only when a skill is selected.

### Example multi-skill workflows

#### Build and deploy a Databricks pipeline

```text
1. Use $data-specification to define contracts, ownership, SLAs, replay, and acceptance criteria.
2. Use $pipeline-planning-and-task-breakdown to create a verifiable implementation plan.
3. Use $databricks-config to confirm the intended workspace profile.
4. Use $databricks-spark-declarative-pipelines to implement the ingestion and SCD logic.
5. Use $databricks-bundles to package it for dev and production.
6. Use $databricks-jobs to validate the orchestration and run the development job.
7. Use $data-quality-and-contract-testing, $code-reviewer, and $test-master before preparing the pull request.
```

#### Build a tested Data Vault model

```text
1. Use $configuring-datavault4dbt to inspect and configure the dbt project.
2. Use $using-datavault4dbt to create staging, hub, link, and satellite models.
3. Use $testing-a-datavault4dbt-project to add hash-key, referential-integrity, and uniqueness tests.
4. If runs behave unexpectedly, use $troubleshooting-datavault4dbt.
```

#### Build and review a RAG application

```text
1. Use $rag-architect to design ingestion, chunking, retrieval, reranking, and evaluation.
2. Use $fastapi-expert for the service API and $react-expert for the user interface.
3. Use $secure-code-guardian to harden authentication and input handling.
4. Use $test-master and $code-reviewer before release.
```

In Claude Code, replace each `$skill-name` above with `/plugin-name:skill-name`.

### Prerequisites for live operations

The plugins package instructions and helper resources, not credentials or cloud connections. Before asking a skill to interact with a live system:

- authenticate the required CLI or service using your own account;
- select the correct Databricks profile, catalog, schema, warehouse, and environment;
- open the intended repository so the agent can inspect its local guidance;
- start with read-only discovery when working with production systems;
- explicitly approve deployments, job runs, permission changes, pushes, deletes, or other consequential operations.

The `athena-internal` plugin additionally requires authorized access to the internal Azure DevOps repository. Never paste PATs, service-principal secrets, or Databricks tokens into prompts.

### Confirm what is installed

For Codex:

```powershell
codex plugin marketplace list
```

Then run `/skills` in Codex CLI or the IDE extension to browse the available skills. If newly installed skills do not appear, restart or refresh Codex.

For Claude Code:

```powershell
claude plugin list
claude plugin details data-engineering-core@kdata-agent-skills
claude plugin details databricks-engineering@kdata-agent-skills
claude plugin details datavault4dbt@kdata-agent-skills
```

Starting a new session is a useful final check because it confirms that the user-scoped installation is available outside the installation conversation.

## Available skill inventory

<details>
<summary><code>data-engineering-core</code> — 7 workflows plus 1 compatibility alias</summary>

- `using-data-engineering-agent-skills` — canonical entry workflow
- `using-data-agent-skills` — upstream compatibility alias
- `data-specification`
- `pipeline-planning-and-task-breakdown`
- `data-quality-and-contract-testing`
- `data-resiliency-testing-and-failure-injection`
- `data-observability-and-sla-management`
- `incident-triage-and-pipeline-recovery`

The plugin also carries the upstream references, templates, presets, starter packs, registry, examples, skills index, MIT license, and original core-bundle manifest required by these workflows.

</details>

<details>
<summary><code>databricks-engineering</code> — 25 skills</summary>

- `databricks-agent-bricks`
- `databricks-aibi-dashboards`
- `databricks-ai-functions`
- `databricks-apps-python`
- `databricks-bundles`
- `databricks-config`
- `databricks-dbsql`
- `databricks-docs`
- `databricks-execution-compute`
- `databricks-genie`
- `databricks-iceberg`
- `databricks-jobs`
- `databricks-lakebase-autoscale`
- `databricks-lakebase-provisioned`
- `databricks-metric-views`
- `databricks-mlflow-evaluation`
- `databricks-model-serving`
- `databricks-python-sdk`
- `databricks-spark-declarative-pipelines`
- `databricks-spark-structured-streaming`
- `databricks-synthetic-data-gen`
- `databricks-unity-catalog`
- `databricks-unstructured-pdf-generation`
- `databricks-vector-search`
- `databricks-zerobus-ingest`

</details>

<details>
<summary><code>datavault4dbt</code> — 5 skills</summary>

- `configuring-datavault4dbt`
- `rehashing-datavault4dbt-entities`
- `testing-a-datavault4dbt-project`
- `troubleshooting-datavault4dbt`
- `using-datavault4dbt`

</details>

<details>
<summary><code>engineering-quality</code> — 5 skills</summary>

- `code-reviewer`
- `secure-code-guardian`
- `security-reviewer`
- `spec-miner`
- `test-master`

</details>

<details>
<summary><code>data-ai-apps</code> — 5 skills</summary>

- `fastapi-expert`
- `prompt-engineer`
- `rag-architect`
- `react-expert`
- `spark-python-data-source`

</details>

<details>
<summary><code>athena-internal</code> — 1 skill</summary>

- `ado-athena-databricks`

</details>

## Share with coworkers

1. Create a Git repository named `kdata-agent-skills` and push this folder.
2. Replace `YOUR_GITHUB_ORG` in the commands above with the GitHub organization or user that owns the repository.
3. Share the repository URL and let each coworker install only the relevant plugin groups.
4. Restrict access to the repository if `athena-internal` is included. That plugin references an internal Azure DevOps project and requires the user's own authenticated access.

Do not put credentials, PATs, Databricks tokens, or `.env` files in this repository. Skills describe workflows; each user supplies authentication through their normal local tooling.

## Update and release

- Update a skill in its plugin folder.
- Regenerate `skill-lock.json` with `./scripts/new-skill-lock.ps1`.
- Bump the affected plugin version in all three plugin manifests and in `.claude-plugin/marketplace.json`.
- Run `./scripts/validate-repository.ps1`.
- Commit, tag, and push the release.

Consumers can refresh with:

```powershell
codex plugin marketplace upgrade kdata-agent-skills
claude plugin marketplace update kdata-agent-skills
```

## Validate

```powershell
./scripts/validate-repository.ps1
```

If Claude Code is installed, also run:

```powershell
claude plugin validate . --strict
```

Codex plugin manifests are additionally checked with OpenAI's `validate_plugin.py` during release preparation.

## Provenance and licensing

This is an aggregation repository, not a claim of authorship over bundled third-party skills. The `data-engineering-core` plugin is pinned to `vaquarkhan/data-engineering-agent-skills` commit `421ef57e8d42c464b29339193c18dd5bd2946bc2`. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md), the per-plugin `LICENSES/` directories, and `skill-lock.json` for source attribution and immutable packaged-content hashes.

## Product documentation

- [Official OpenAI documentation: Build skills](https://learn.chatgpt.com/docs/build-skills)
- [Official OpenAI documentation: Package plugins and marketplaces](https://developers.openai.com/plugins/build/plugins)
- [Claude Code plugin reference](https://code.claude.com/docs/en/plugins-reference)
- [Claude Code marketplace documentation](https://code.claude.com/docs/en/plugin-marketplaces)
