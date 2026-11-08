---
name: strix
description: Run local Strix security testing alongside security-review when the user asks for a security check, vulnerability assessment, or penetration test of their application. Applies to user-controlled local software; external or production targets require explicit scope authorization.
---

# Strix Local Security Testing

## Activation and scope

A request to check application security authorizes code/configuration review and a bounded Strix scan of an identifiable user-controlled local test application. Use security-review alongside this skill for evidence and reporting. Do not ask for execution permission again when this scope is already established. For explicit code-only review, do not launch Strix.

Determine the local URL, test accounts, disposable data, and outbound integrations from available project context. Inspect startup scripts before starting the app. Ask only for missing information that blocks execution or when production databases, external services, valuable data, or target ownership are unclear. Localhost alone does not prove isolation. Keep testing within the identified application; exclude third-party hosts, production resources, hardware, destructive tests, denial of service, and high-volume attacks unless separately authorized. Stop if testing escapes scope or causes unexpected external effects. Scope instructions are not a network boundary; isolate or mock live integrations before scanning.

## Local execution

Use the open-source local CLI, not Strix Cloud. Check `strix --version`, `strix --help`, and `docker info`; verify required LLM configuration without printing secret values. Follow the current official guide at https://github.com/usestrix/strix and the installed CLI's help. If prerequisites are missing, report the specific blocker and continue code review; do not silently upload source to cloud. Installation is separate from adding this skill.

Local execution can send source and findings to the configured LLM provider. Respect existing provider/privacy requirements; clarify an unknown provider or spending limit before a paid run. Reuse an established budget and always pass a supported explicit budget cap. Do not invent a user-approved spending amount.

Strix mounts local path targets writable. Use an isolated disposable copy containing the current relevant code, excluding credentials and unrelated private files; never point it at the user's working tree. Run the test app against disposable data. Resolve container-to-host connectivity and verify the sandbox can reach the intended local app rather than assuming container localhost is the host.

Use headless mode (`-n`), explicit targets (`--target`), a bounded initial scan mode, and scope instructions (`--instruction-file` where supported). Check exact options against installed help. Include allowed targets, test accounts, excluded integrations, and stop conditions in the instructions; do not place real credentials in shell arguments or tracked files. Store temporary instructions and scan artifacts outside tracked source. Do not enable source fixes as part of a review.

Monitor the run to completion or its stated limit. Do not launch repeated scans automatically after a limit, failure, or scope change; diagnose the cause and remain within existing authorization and budget. A requested fix verification permits a focused retest within the same isolated local scope.

## Findings

Read the report, individual findings, and run metadata from the actual output directory. Cross-check significant findings against source and reproducible evidence. Distinguish findings from execution failures, budget limits, and incomplete coverage. A zero exit code does not establish that the app is secure. Report severity, evidence, affected code or route, impact, coverage limits, and remediation direction in Korean. Keep secrets out of reports and Git. Source fixes require a user request covering implementation.

This is a locally authored workflow, not vendored Strix source or an MCP server. Official CLI reference: https://github.com/usestrix/strix/blob/main/skills/penetration-testing-with-strix/SKILL.md.
