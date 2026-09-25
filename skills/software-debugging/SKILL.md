---
name: software-debugging
description: Use to diagnose software runtime, build, test, behavior, integration, IDE, dependency, environment, or configuration problems before implementation. Analysis-only by default; use dual-agent-development for requested fixes, hardware-debugging for connected-device failures, or security-review for security analysis.
---

# Software Debugging

## Purpose

Diagnose general software problems before implementation. This workflow is analysis-only by default. It does not modify source code, configuration, schemas, datasets, API contracts, documentation, or project files unless the user explicitly authorizes a separate implementation task.

When a correction is required: report the finding and evidence, explain the realistic impact, recommend a correction direction, stop, wait for explicit user authorization, then route authorized implementation to `dual-agent-development`.

## Activation

Use this workflow for runtime exceptions, build failures, test failures, incorrect application behavior, integration failures, IDE-only errors, dependency or environment mismatches, and backend, frontend, mobile, database, networking, state-management, concurrency, or configuration problems.

Do not use this workflow in place of:

- `hardware-debugging` for observed hardware-connected failures,
- `hardware-control-review` for hardware-control code review,
- `security-review` for security analysis,
- `embedded-security-review` for embedded or cyber-physical security analysis.

## Review Boundary

Allowed when safe and relevant: inspect source code, configuration, datasets, metadata, logs, schemas, specifications, Git history, and existing test results; perform read-only analysis; run hardware-independent, non-destructive verification; create temporary analysis artifacts outside the repository when genuinely needed.

Do not automatically:

- modify project code, configuration, datasets, schemas, API contracts, model files, or documentation,
- execute destructive or state-changing tests,
- call live production APIs with mutations,
- perform hardware operations,
- weaken tests, validation, security controls, or acceptance criteria,
- treat diagnosis as authorization to implement a correction.

## Evidence States

Use these states consistently and do not report guesses as confirmed facts:

- **CONFIRMED**: directly supported by actual project evidence or reproduced behavior.
- **LIKELY**: strong evidence supports the issue, but one meaningful part remains unverified.
- **POSSIBLE**: plausible, but important evidence is missing.
- **RULED OUT**: evidence contradicts the hypothesis.
- **UNVERIFIED**: not enough evidence to assess.

Use **CRITICAL**, **HIGH**, **MEDIUM**, and **LOW** severity only when it improves prioritization. Keep severity separate from confidence.

## Diagnostic Workflow

### Problem Definition

Record expected behavior and observed behavior separately. Identify reproduction conditions, the last known-good state, relevant recent changes, and which statements are confirmed observations versus user assumptions.

### Evidence Collection

Inspect exact error messages, stack traces, logs, source code, configuration, dependency versions, runtime versions, Git diff, and existing tests. Reproduce the issue when safe and reasonably possible. Do not claim reproduction unless it was actually reproduced. Determine whether the issue belongs to code, tooling, IDE indexing, environment configuration, runtime configuration, or external integration.

### Call Path and Data Flow

Trace the relevant execution path. Identify where the first incorrect state appears. Separate root cause from downstream symptoms. Check boundary conversions, nullability, state transitions, concurrency, caching, retries, timeouts, serialization, and configuration when relevant.

### Hypothesis Testing

Use an evidence-driven loop:

Observation -> Hypothesis -> Safe test -> Evidence -> Updated confidence

Maintain multiple plausible hypotheses until evidence eliminates them. Prefer tests that distinguish competing hypotheses. Do not modify production code merely to test an unsupported guess. Avoid large or noisy diagnostic changes.

## Report

Include:

- expected and observed behavior,
- reproduction status,
- evidence inspected,
- root-cause assessment,
- confidence,
- ruled-out hypotheses,
- unresolved uncertainties,
- correction direction,
- recommended next verification step.
