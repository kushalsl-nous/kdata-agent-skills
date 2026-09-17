# KData Agent Skills

[![Bundle version](https://img.shields.io/badge/bundle-v1.2.0-2563eb)](CHANGELOG.md)
[![Plugins](https://img.shields.io/badge/plugins-6-7c3aed)](#plugin-catalog)
[![Skill directories](https://img.shields.io/badge/skill_directories-49-059669)](#complete-skill-inventory)
[![Clients](https://img.shields.io/badge/clients-Codex%20%7C%20Claude%20Code-111827)](#install-the-marketplace)

Curated, installable data-engineering workflows for Codex and Claude Code.

KData Agent Skills packages repeatable operating procedures for data engineering, Databricks, Data Vault 2.0, software quality, and data/AI application delivery. The repository is a team marketplace rather than a collection of generic prompts: each skill gives an agent scoped instructions, decision points, guardrails, and verification expectations for a specific engineering job.

The bundle contains **49 skill directories across six independently installable plugins**: 48 working skills and one upstream compatibility alias. Install only the plugin groups that match your work.

> **Private distribution:** this repository includes `athena-internal`, which references an internal Azure DevOps project. Keep the repository private or remove that plugin before public distribution.

## Why this repository exists

AI coding agents are most useful when they follow the same delivery discipline expected from an engineering team. This bundle helps agents:

- define contracts, ownership, service levels, replay behavior, and acceptance criteria before implementation;
- select a focused workflow instead of loading an entire data-engineering handbook;
- build and operate Databricks workloads with platform-specific guidance;
- model and test Data Vault 2.0 solutions with `datavault4dbt`;
- review code, security, testability, and undocumented systems systematically;
- design APIs, React applications, RAG systems, prompts, and custom Spark data sources;
- treat successful execution as one piece of evidence, not proof that a data product is production-ready.

## Quick start

### Start here

1. Get access to the private GitHub repository.
2. Add the marketplace to Codex, Claude Code, or both.
3. Install only the plugin groups you need.
4. Start with `using-data-engineering-agent-skills` when the correct workflow is unclear.
5. Give the agent the repository or files in scope, target platform and environment, expected output, and whether it may make changes.

### Recommended first prompts

Codex:

```text
$using-data-engineering-agent-skills classify this request and select the safest workflow.

$using-datavault4dbt design hubs, links, and satellites from these staging columns.

$databricks-spark-declarative-pipelines implement this ingestion contract as a serverless pipeline.
```

Claude Code:

```text
/data-engineering-core:using-data-engineering-agent-skills classify this request and select the safest workflow.

/datavault4dbt:using-datavault4dbt design hubs, links, and satellites from these staging columns.

/databricks-engineering:databricks-spark-declarative-pipelines implement this ingestion contract as a serverless pipeline.
```

## Feature highlights

- **Six plugin boundaries** so teams can install focused capability packs instead of all 49 skill directories.
- **Dual marketplace support** through `.agents/plugins/marketplace.json` for Codex and `.claude-plugin/marketplace.json` for Claude Code.
- **Portable plugin packaging** with a root `plugin.json` plus Codex and Claude compatibility manifests in every plugin.
- **Data-engineering lifecycle guidance** for specification, planning, quality, resiliency, observability, and incident recovery.
- **Twenty-five Databricks workflows** covering SQL, Spark pipelines, jobs, bundles, governance, applications, serving, vector search, AI/BI, and platform operations.
- **Five Data Vault workflows** for configuring, modelling, testing, troubleshooting, and rehashing `datavault4dbt` projects.
- **Engineering quality and application packs** for security, testing, reverse engineering, APIs, React, RAG, prompting, and Spark connectors.
- **Reusable core assets** including platform presets, reference guides, templates, starter packs, examples, and a machine-readable registry.
- **Traceable packaging** through `skill-lock.json`, per-skill source metadata, third-party notices, licenses, and SHA-256 tree hashes.

## Core principles

- Define the data product before writing pipeline code.
- Make contracts, grain, ownership, SLAs, lineage, retention, and recovery explicit.
- Prefer incremental, reviewable changes over broad rewrites.
- Validate data quality, referential integrity, reconciliation, and restart behavior before release.
- Treat production access, deployment, execution, permissions, and deletion as consequential operations.
- Require evidence for completion and distinguish local validation from live-environment proof.
- Preserve source attribution and the license terms of every bundled skill.

## Plugin catalog

| Plugin | Skill directories | Best for |
| --- | ---: | --- |
| `data-engineering-core` | 8 | Specification, planning, quality, resiliency, observability, and recovery; 7 workflows plus 1 compatibility alias |
| `databricks-engineering` | 25 | Databricks SQL, Spark, pipelines, jobs, bundles, governance, apps, AI/BI, serving, and platform operations |
| `datavault4dbt` | 5 | Data Vault 2.0 modelling and operations with Scalefree `datavault4dbt` |
| `engineering-quality` | 5 | Code review, application security, security audits, testing, and specification mining |
| `data-ai-apps` | 5 | FastAPI, React, RAG, prompt engineering, and custom Spark data sources |
| `athena-internal` | 1 | Authorized work on the internal Athena Databricks Azure DevOps repository |

## Choose your path

| What you need to do | Install | Start with |
| --- | --- | --- |
| Clarify or plan a data-engineering request | `data-engineering-core` | `using-data-engineering-agent-skills` or `data-specification` |
| Break a design into verifiable implementation tasks | `data-engineering-core` | `pipeline-planning-and-task-breakdown` |
| Add contracts, quality gates, or release evidence | `data-engineering-core` | `data-quality-and-contract-testing` |
| Test restart, replay, outage, or failure behavior | `data-engineering-core` | `data-resiliency-testing-and-failure-injection` |
| Define SLAs, telemetry, and operational signals | `data-engineering-core` | `data-observability-and-sla-management` |
| Recover a failed or unsafe pipeline | `data-engineering-core` | `incident-triage-and-pipeline-recovery` |
| Build or operate a Databricks workload | `databricks-engineering` | `databricks-config`, then the workload-specific skill |
| Create a Databricks pipeline or streaming job | `databricks-engineering` | `databricks-spark-declarative-pipelines` or `databricks-spark-structured-streaming` |
| Package and orchestrate a Databricks solution | `databricks-engineering` | `databricks-bundles` and `databricks-jobs` |
| Build a Data Vault 2.0 model in dbt | `datavault4dbt` | `configuring-datavault4dbt`, then `using-datavault4dbt` |
| Review correctness, security, or test coverage | `engineering-quality` | `code-reviewer`, `secure-code-guardian`, or `test-master` |
| Reverse-engineer an inherited codebase | `engineering-quality` | `spec-miner` |
| Design a RAG system or AI application | `data-ai-apps` | `rag-architect`, `fastapi-expert`, and `react-expert` |
| Build a custom Spark connector | `data-ai-apps` | `spark-python-data-source` |
| Work in the internal Athena repository | `athena-internal` plus relevant Databricks plugins | `ado-athena-databricks` |

## Data-engineering lifecycle

The core plugin can be composed into a lightweight delivery lifecycle:

```text
Define -> Plan -> Build -> Validate -> Stress -> Observe -> Recover
   |        |        |         |          |          |          |
   |        |        |         |          |          |          +-- incident-triage-and-pipeline-recovery
   |        |        |         |          |          +------------- data-observability-and-sla-management
   |        |        |         |          +------------------------ data-resiliency-testing-and-failure-injection
   |        |        |         +----------------------------------- data-quality-and-contract-testing
   |        |        +--------------------------------------------- domain plugin skill
   |        +------------------------------------------------------ pipeline-planning-and-task-breakdown
   +--------------------------------------------------------------- data-specification
```

Use the lifecycle as a routing guide, not as a requirement to load every skill. Select only the minimum workflow needed for the current task.

## How skills work

Each capability is stored in its own directory with a required `SKILL.md` entry point and optional references, scripts, assets, or agent metadata.

```text
skills/
└── skill-name/
    ├── SKILL.md
    ├── references/      # Optional supporting guidance
    ├── scripts/         # Optional deterministic helpers
    ├── assets/          # Optional reusable resources
    └── agents/          # Optional UI and dependency metadata
```

Installing a plugin makes its skills available; it does not execute them. Codex and Claude initially use skill names and descriptions for discovery, then load the full instructions only when a skill is selected.

### Invoke a skill explicitly

| Client | Invocation |
| --- | --- |
| Codex CLI or IDE extension | Run `/skills`, or type `$` and select a skill such as `$databricks-jobs` |
| ChatGPT | Type `@` and select an installed skill |
| Claude Code | Use `/plugin-name:skill-name`, such as `/datavault4dbt:using-datavault4dbt` |

Explicit invocation is useful when you already know the workflow you want.

### Let the agent choose automatically

You can also describe the desired outcome without naming a skill:

```text
Configure datavault4dbt in this existing dbt project and use SHA-256 hash keys.

Create a serverless Databricks pipeline that ingests JSON incrementally and maintains SCD Type 2 history.

Review this FastAPI authentication implementation for OWASP risks and add focused tests.

Diagnose why this Data Vault satellite captures unchanged records on every run.
```

Implicit selection works best when the prompt includes:

- the platform and technology;
- the repository, files, or data objects in scope;
- the target environment;
- the expected artifact or result;
- whether the task is read-only or may modify systems.

## Example multi-skill workflows

### Build and deploy a Databricks pipeline

```text
1. data-specification
   Define inputs, outputs, contracts, ownership, SLAs, replay, and acceptance criteria.
2. pipeline-planning-and-task-breakdown
   Create small, verifiable implementation tasks.
3. databricks-config
   Confirm the intended workspace and profile.
4. databricks-spark-declarative-pipelines
   Implement ingestion, transformations, CDC, or SCD behavior.
5. databricks-bundles + databricks-jobs
   Package, validate, deploy, and orchestrate the workload.
6. data-quality-and-contract-testing + code-reviewer + test-master
   Produce release evidence before preparing a pull request.
```

### Build a tested Data Vault model

```text
1. configuring-datavault4dbt
   Inspect the dbt project, adapter, package, hash settings, and naming conventions.
2. using-datavault4dbt
   Create staging, hub, link, satellite, and business-vault models.
3. testing-a-datavault4dbt-project
   Add key uniqueness, not-null, referential-integrity, and load-date tests.
4. troubleshooting-datavault4dbt
   Diagnose compile errors, ghost records, high-water marks, or satellite behavior.
5. rehashing-datavault4dbt-entities
   Use only when a controlled hash migration is required.
```

### Build and review a RAG application

```text
1. rag-architect
   Design ingestion, chunking, embeddings, retrieval, reranking, and evaluation.
2. fastapi-expert + react-expert
   Implement the service and user interface.
3. prompt-engineer
   Define prompts, structured outputs, and evaluation cases.
4. secure-code-guardian
   Harden authentication, authorization, input handling, and secrets usage.
5. test-master + code-reviewer
   Validate behavior and review the final changes.
```

For Claude Code, use the namespaced form `/plugin-name:skill-name` for each step.

## Core data-engineering assets

The `data-engineering-core` plugin includes more than its eight skill entry points. Supporting assets imported from the pinned upstream source provide reusable delivery scaffolding:

| Asset | Included | Purpose |
| --- | ---: | --- |
| Platform presets | 14 | AWS, Azure, GCP, Databricks, Snowflake, Alibaba Cloud, multi-cloud, enterprise ETL, and Apache stack adaptations |
| Reference guides | 56 | Checklists and design guidance for quality, reliability, governance, ingestion, security, architecture, and operations |
| Templates | 11 | Specifications, plans, tasks, contracts, backfills, schema changes, release evidence, and incident response |
| YAML starter packs | 13 | Opinionated bundles for common delivery and reliability scenarios |
| Example packs | 14 | Five runnable scaffolds and nine architecture blueprints |
| Registry files | 2 | Machine-readable asset discovery and documentation |

### Platform presets

<details>
<summary>Show the 14 packaged presets</summary>

- `alibaba-cloud-data-engineering`
- `apache-airflow-orchestration`
- `apache-flink-stream-processing`
- `apache-iceberg-lakehouse`
- `apache-kafka-streaming`
- `apache-spark-engineering`
- `aws-data-engineering`
- `azure-data-engineering`
- `databricks-lakehouse-engineering`
- `gcp-data-engineering`
- `informatica-data-integration`
- `multi-cloud-hybrid-data-engineering`
- `snowflake-modern-data-platform`
- `talend-data-integration`

</details>

### Templates

<details>
<summary>Show the 11 packaged templates</summary>

- `source-contract.yaml`
- `dataset-contract.yaml`
- `metric-contract.yaml`
- `data-compliance-controls.yaml`
- `backfill-plan.yaml`
- `schema-change-plan.yaml`
- `release-gate-evidence.yaml`
- `incident-runbook.md`
- `spec-template.md`
- `plan-template.md`
- `tasks-template.md`

</details>

### Example packs

Five examples contain runnable scaffolding:

- `aws-s3-glue-athena-iceberg`
- `aws-serverless-spark-msk-reliability`
- `databricks-delta-medallion`
- `dbt-warehouse-marts`
- `kafka-flink-streaming`

Nine examples are architecture blueprints with specification, plan, and task artifacts:

- `api-saas-to-warehouse-ingestion`
- `data-platform-cicd-progressive-release`
- `esg-regulatory-reporting-foundation`
- `feature-store-online-offline-parity`
- `gcp-pubsub-dataflow-bigquery`
- `multi-cloud-warehouse-cutover`
- `privacy-retention-deletion-workflow`
- `snowflake-dbt-reverse-etl`
- `validation-and-security-review-foundation`

## Project structure

```text
kdata-agent-skills/
├── .agents/plugins/marketplace.json      # Codex marketplace catalog
├── .claude-plugin/marketplace.json       # Claude Code marketplace catalog
├── plugins/
│   ├── data-engineering-core/
│   ├── databricks-engineering/
│   ├── datavault4dbt/
│   ├── engineering-quality/
│   ├── data-ai-apps/
│   └── athena-internal/
├── scripts/
│   ├── new-skill-lock.ps1                # Regenerate source and hash inventory
│   └── validate-repository.ps1           # Validate manifests, paths, skills, and hashes
├── skill-lock.json                       # Pinned source and packaged-content hashes
├── THIRD_PARTY_NOTICES.md                # Source attribution
├── LICENSE.md                            # Repository licensing notes
└── CHANGELOG.md                          # Bundle release history
```

Every plugin follows the same packaging shape:

```text
plugins/plugin-name/
├── plugin.json                           # Portable Agent Plugins manifest
├── .codex-plugin/plugin.json             # Codex compatibility manifest
├── .claude-plugin/plugin.json            # Claude Code manifest
├── skills/                               # One directory per skill
└── LICENSES/                             # Applicable third-party licenses
```

## Install the marketplace

The repository is private. Before installation, confirm that your GitHub account can access `kushalsl-nous/kdata-agent-skills` and that Git authentication works on the machine running the client.

### Codex

Add the GitHub marketplace once:

```powershell
codex plugin marketplace add kushalsl-nous/kdata-agent-skills --ref main
```

Then restart or refresh the ChatGPT desktop app, open the Plugins Directory, choose **KData Agent Skills**, and install only the plugin groups you need.

For local authoring from the repository root:

```powershell
codex plugin marketplace add .
```

Inspect configured marketplaces with:

```powershell
codex plugin marketplace list
```

### Claude Code

Add the marketplace and install selected plugins at user scope:

```powershell
claude plugin marketplace add kushalsl-nous/kdata-agent-skills
claude plugin install data-engineering-core@kdata-agent-skills --scope user
claude plugin install databricks-engineering@kdata-agent-skills --scope user
claude plugin install datavault4dbt@kdata-agent-skills --scope user
claude plugin install engineering-quality@kdata-agent-skills --scope user
claude plugin install data-ai-apps@kdata-agent-skills --scope user
```

Install the internal plugin only when you are authorized for the Athena repository:

```powershell
claude plugin install athena-internal@kdata-agent-skills --scope user
```

For local authoring from the repository root:

```powershell
claude plugin marketplace add .
```

Confirm the installation:

```powershell
claude plugin marketplace list
claude plugin list
claude plugin details data-engineering-core@kdata-agent-skills
```

User-scoped Claude installations and configured Codex marketplaces remain available across projects and future sessions for the same user. Start a new session after installation to confirm discovery outside the setup conversation.

## Complete skill inventory

### Data Engineering Core

Seven workflows plus one compatibility alias:

- `using-data-engineering-agent-skills` — canonical entry and workflow router
- `using-data-agent-skills` — upstream compatibility alias
- `data-specification`
- `pipeline-planning-and-task-breakdown`
- `data-quality-and-contract-testing`
- `data-resiliency-testing-and-failure-injection`
- `data-observability-and-sla-management`
- `incident-triage-and-pipeline-recovery`

### Databricks Engineering

Twenty-five skills:

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

### Data Vault for dbt

Five skills:

- `configuring-datavault4dbt`
- `using-datavault4dbt`
- `testing-a-datavault4dbt-project`
- `troubleshooting-datavault4dbt`
- `rehashing-datavault4dbt-entities`

### Engineering Quality

Five skills:

- `code-reviewer`
- `secure-code-guardian`
- `security-reviewer`
- `spec-miner`
- `test-master`

### Data and AI Applications

Five skills:

- `fastapi-expert`
- `prompt-engineer`
- `rag-architect`
- `react-expert`
- `spark-python-data-source`

### Athena Internal

One skill:

- `ado-athena-databricks`

## Live-operation boundaries

The plugins package instructions and supporting resources, not credentials or cloud connections. Before using a skill against a live environment:

- authenticate through the approved CLI, credential manager, or service identity;
- confirm the intended account, workspace, profile, catalog, schema, warehouse, and environment;
- begin with read-only discovery when production systems are in scope;
- review generated plans and configuration before execution;
- explicitly authorize deployments, job runs, permission changes, pushes, deletes, and other consequential operations;
- never paste PATs, service-principal secrets, cloud keys, database passwords, or Databricks tokens into prompts or repository files.

A generated artifact or passing local validator does not prove authenticated connectivity, successful deployment, production readiness, or business approval.

## Share with coworkers

1. Grant the coworker read access to `kushalsl-nous/kdata-agent-skills`.
2. Ask them to add the marketplace using the Codex or Claude Code commands above.
3. Let them install only the plugin groups relevant to their role.
4. Require separate authorization for `athena-internal` and every live platform.
5. Use user-scoped installation when the skills should be available across all of their sessions.

Do not copy credentials into this repository. Each user supplies authentication through their normal local tooling.

## Validate and release

Run the repository validator after any skill or manifest change:

```powershell
./scripts/validate-repository.ps1
```

If Claude Code is installed, also validate the marketplace:

```powershell
claude plugin validate .
```

Release workflow:

1. Update the skill in its plugin directory.
2. Update the affected portable, Codex, and Claude plugin versions.
3. Update `.claude-plugin/marketplace.json` when the marketplace release changes.
4. Regenerate the lock file with `./scripts/new-skill-lock.ps1`.
5. Run repository and client validators.
6. Review `THIRD_PARTY_NOTICES.md` and the applicable `LICENSES/` directory.
7. Commit, tag, and push the release.

Consumers can refresh configured marketplaces with:

```powershell
codex plugin marketplace upgrade kdata-agent-skills
claude plugin marketplace update kdata-agent-skills
```

## Provenance and licensing

KData Agent Skills is an aggregation and distribution repository. It does not claim authorship over bundled third-party skills.

The package currently includes material derived from:

- [vaquarkhan/data-engineering-agent-skills](https://github.com/vaquarkhan/data-engineering-agent-skills), pinned for the `data-engineering-core` bundle;
- Databricks skill sources;
- Scalefree `datavault4dbt` skills;
- selected MIT-licensed skills from `jeffallan/claude-skills`;
- the proprietary `ado-athena-databricks` workflow.

See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md), each plugin's `LICENSES/` directory, and [skill-lock.json](skill-lock.json) for exact source references, license information, packaged paths, and SHA-256 content hashes.

## Documentation

- [OpenAI: Package your plugin](https://developers.openai.com/plugins/build/plugins)
- [OpenAI: Build skills](https://learn.chatgpt.com/docs/build-skills)
- [Claude Code: Create and distribute a plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
- [Claude Code: Plugins reference](https://code.claude.com/docs/en/plugins-reference)
- [Bundle release history](CHANGELOG.md)
