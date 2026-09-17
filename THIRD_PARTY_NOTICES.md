# Third-party notices

This repository redistributes skill snapshots from multiple sources. The aggregation and packaging do not replace the original licenses.

## Vaquarkhan Data Engineering Agent Skills

The `data-engineering-core` plugin packages the upstream repository's own recommended core manifest: seven workflows plus the `using-data-agent-skills` compatibility alias. It also includes the shared references, templates, presets, starter packs, registry, examples, and skills index used by those workflows.

- Source: <https://github.com/vaquarkhan/data-engineering-agent-skills>
- Imported revision: `421ef57e8d42c464b29339193c18dd5bd2946bc2`
- License: MIT

The upstream MIT license and original core manifest are included in the plugin. The compatibility alias is packaged for upstream compatibility but is not counted as a separate workflow.

## Databricks-origin skills

The 25 skills in `plugins/databricks-engineering` and `spark-python-data-source` in `plugins/data-ai-apps` originate from the Databricks AI Dev Kit lineage:

- Historical source: <https://github.com/databricks-solutions/ai-dev-kit>
- Current upstream: <https://github.com/databricks/databricks-agent-skills>
- License identifier: `LicenseRef-Databricks`

The Databricks license and notices are included with every plugin that contains a Databricks-origin skill. Redistribution and use remain subject to those terms, including their Databricks Services limitation.

## Scalefree datavault4dbt skills

The five skills in `plugins/datavault4dbt` originate from:

- Source: <https://github.com/ScalefreeCOM/datavault4dbt-agent-skills>
- Imported source revision: `e72ce0f2a2342ff985236f1ca05400bdbb6786ca`
- License: Apache License 2.0

## Jeff Allan skills

Nine skills across `plugins/engineering-quality` and `plugins/data-ai-apps` originate from:

- Source: <https://github.com/Jeffallan/claude-skills>
- Packaged from the locally installed snapshot on 2026-09-17
- License: MIT

The original skill frontmatter retains upstream attribution where provided.

## Athena internal skill

`plugins/athena-internal/skills/ado-athena-databricks` is an internal workflow. Its packaged copy was adapted to remove machine-specific paths. No public redistribution license is granted. Share it only with authorized coworkers who already have access to the referenced Azure DevOps repository.

## Snapshot integrity

`skill-lock.json` records a SHA-256 tree digest for every packaged skill. A digest covers all files in that skill using sorted relative paths and individual file hashes.
