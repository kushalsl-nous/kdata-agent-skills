# Security Policy

## Supported versions

Security fixes are applied to the latest release and the current `main` branch.

| Version | Supported |
| --- | --- |
| Latest release | Yes |
| Current `main` | Yes |
| Older snapshots and forks | No |

Consumers should update their configured marketplace before reporting an issue that may already be fixed.

## Reporting a vulnerability

Do not open a public issue or pull request containing vulnerability details, exploit instructions, credentials, tokens, internal URLs, tenant information, or customer data.

Report the issue privately using one of these routes:

1. Use GitHub's **Report a vulnerability** or private security-advisory workflow for this repository when it is available.
2. Otherwise, contact the repository owner through an approved private company communication channel.

Include only the information needed to investigate:

- the affected plugin, skill, manifest, script, or file;
- the affected release, commit, or packaged hash;
- a concise impact assessment;
- reproducible steps using non-production data;
- relevant logs with secrets and internal identifiers removed;
- a suggested mitigation, if known.

## Security scope

Reports are in scope when they affect this repository's packaging or guidance, including:

- marketplace or plugin manifest integrity;
- unsafe path handling or unintended file access;
- bundled scripts that could execute unintended commands;
- credential, token, or secret exposure;
- tampering with source provenance, licenses, or `skill-lock.json` hashes;
- installation or update behavior that retrieves unexpected content;
- skill instructions that could encourage unauthorized, destructive, or unsafe production changes;
- disclosure of internal Athena repository information.

Vulnerabilities in Databricks, dbt, Claude Code, Codex, GitHub, Azure DevOps, or another upstream platform should also be reported to that product's security team. This repository can address its own manifests, scripts, packaging, and workflow guidance but cannot patch an upstream service.

## Safe testing rules

- Test with local fixtures, disposable environments, and non-sensitive data.
- Do not access systems, repositories, workspaces, tenants, or data without explicit authorization.
- Do not run destructive tests against production systems.
- Do not exfiltrate, retain, or publish credentials or customer information.
- Stop testing when continued work could affect availability, integrity, confidentiality, or cost.

## Response and disclosure

Maintainers will assess the report, confirm whether it affects this repository, and coordinate remediation when appropriate. Response time depends on severity, reproducibility, upstream dependencies, and maintainer availability; no fixed response SLA is guaranteed.

Allow maintainers a reasonable opportunity to investigate and release a fix before public disclosure. Public credit can be coordinated after remediation when requested and appropriate.

## Secrets accidentally committed

Treat an exposed secret as compromised even if it is removed from Git history:

1. Revoke or rotate it immediately through the owning service.
2. Review audit logs and affected permissions.
3. Remove it from the repository and history where required.
4. Add an appropriate detection or prevention control.
5. Report the incident privately using the process above.
