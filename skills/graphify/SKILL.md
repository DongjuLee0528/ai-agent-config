---
name: graphify
description: Use existing project-local Graphify data for complex codebase structure, dependency, call-path, and change-impact analysis; do not install, initialize, update, or index without explicit approval.
---

# Graphify

## Purpose

Use Graphify for analysis-only work on complex codebases where Graphify is already installed and the target project has already been initialized. This skill guides when to use existing Graphify data and how to operate it safely; it does not install Graphify or manage project indexes from this shared configuration repository.

Graphify is appropriate for understanding code structure and module relationships, tracing calls among functions, classes, modules, and services, analyzing links among APIs and data models, reviewing service and package dependencies, estimating change impact, and understanding multi-language or multi-application projects where text search alone is not enough.

## Use Graphify When

Consider Graphify only after confirming the target project path and scope, and only when existing project-local Graphify data is available:

- The repository is a monorepo with multiple applications or languages.
- Frontend, backend, AI services, databases, or shared packages interact.
- Module call relationships need to be traced.
- API, DTO, data model, and service connections need to be followed.
- A shared module change may affect multiple packages or applications.
- `rg`, IDE search, and basic code navigation are not enough to understand the structure.
- Graphify is installed for the target environment.
- The target project has already been initialized for Graphify.

## Do Not Use Graphify When

Use `rg`, IDE search, and normal code-reading tools instead when:

- The project is small.
- The task is a single-file change.
- The modification scope is already clear.
- Plain string search is sufficient.
- `rg`, IDE search, or basic code navigation is sufficient.
- The task is a simple syntax fix.
- The task is ordinary runtime diagnosis; use `software-debugging`.
- The target project does not have Graphify installed.
- The target project has not been initialized for Graphify.
- Graphify data is stale and the user has not approved refreshing it.

## Preflight

Before using Graphify, verify and record:

- The exact absolute path of the target project.
- The operating system; assume macOS unless the user explicitly says Windows.
- Whether the target is a Git repository.
- Current branch.
- `git status`.
- Whether staged, modified, or untracked files exist.
- Whether Graphify is installed.
- Graphify version, using the installed package manager or an installed CLI help command only when the current installation documents a version flag.
- Whether project-local Graphify initialization is complete.
- Whether an existing graph or index exists.
- Whether the graph or index is current for the requested analysis.
- Files that may be created or modified by any proposed Graphify command.
- Whether the target set may include secrets or sensitive data.

For installation checks, use non-mutating shell inspection such as `command -v graphify` and package-manager inspection for the method used to install Graphify (`uv tool`, `pipx`, or `pip`). Do not infer missing commands, paths, or config names.

## Approval Boundary

Allowed without separate approval:

- Read-only queries against existing Graphify data.
- Structure analysis using an existing graph.
- Relationship and change-impact analysis using an existing graph.
- Read-only cross-checking of Graphify results against actual source code.
- Read-only hook status checks with `graphify hook status`.

If the installed Graphify version would write query logs, caches, metadata, or other files during a query, treat that query as state-changing unless the write can be disabled by an officially documented option or environment variable for the current version.

Requires explicit user approval before running:

- Graphify installation.
- Graphify update.
- Project initialization.
- First index or graph creation.
- Existing index refresh.
- Reindexing.
- Full reanalysis.
- Graph data regeneration.
- Cache creation, modification, or deletion.
- Project settings file creation or modification.
- Hook installation, modification, or deletion.
- Large generated-file writes.
- Overwriting existing files.
- Any operation that affects Git tracking state.

Before requesting approval, report:

- The exact command to run.
- Target project path.
- Files likely to be created, modified, or deleted.
- Expected scope.
- Expected duration.
- Current Git state.
- Recovery or rollback method.

## Data Management

Keep `~/ai-agent-config` limited to shared Graphify operating guidance. Store actual graphs, indexes, caches, and project-specific settings inside each target project, not in this shared configuration repository.

Do not automatically initialize, reindex, fully reanalyze, update Graphify, or delete caches. Modify a project's `.gitignore` only after generated paths are confirmed by official Graphify documentation or actual execution results. Do not add Graphify-related ignore rules by guessing.

## Officially Verified Procedures

Use only commands verified from current official Graphify documentation or the current installed version. Official documentation identifies the PyPI package as `graphifyy` and the CLI command as `graphify`, with installation examples `uv tool install graphifyy`, `pipx install graphifyy`, and `pip install graphifyy`; assistant registration is documented as `graphify install`; project-scoped registration is documented as `graphify install --project` and platform variants such as `graphify install --project --platform codex`.

Official docs show graph creation with `/graphify .` or `/graphify ./raw`, output under `graphify-out/` with `graph.html`, `GRAPH_REPORT.md`, and `graph.json`, querying with `graphify query`, `graphify path`, and `graphify explain`, updates with `/graphify ./raw --update`, reclustering with `--cluster-only`, and Git hook management with `graphify hook install`, `graphify hook uninstall`, and `graphify hook status`.

For macOS, verify prerequisites and installation state without changing the project. Official docs list Python 3.10+, `uv` as recommended, `pipx` as an alternative, and a Homebrew quick install for Python and `uv`. Do not run install, initialization, update, hook installation or removal, build, watch, export, cache, or reindex commands in this shared-config task.

If official docs and the currently installed Graphify version disagree, stop and report the difference before running Graphify. Apply Windows-specific procedures only when the user explicitly says the target environment is Windows.

## Reliability

Treat Graphify results as analysis aids, not absolute facts. Check graph creation time and freshness before relying on results. Cross-verify important relationships and change-impact claims against actual source code.

Distinguish confirmed facts from inference. Consider that dynamic calls, reflection, runtime dependency injection, generated code, and configuration-driven routing can be missing or incomplete. When Graphify conflicts with source code, source code wins. Do not modify project code solely from Graphify output.

## Security

Before any Graphify operation, confirm what Graphify will read and what should be excluded. Stop and report to the user if `.env` files, certificates, private keys, API keys, tokens, credentials, or other sensitive material may be included.

Do not print discovered secrets in results. Check generated data for possible sensitive content before recommending that it be committed or shared. Route deeper security analysis to `security-review`; Graphify is not a substitute for security validation.

## Report Format

When reporting Graphify analysis, include:

- Analysis target.
- Graphify version used.
- Graph or index state.
- Analysis scope.
- Confirmed relationships.
- Change-impact scope.
- Source-code cross-checks performed.
- Confirmed facts.
- Inferences or uncertainties.
- Dynamic behavior that may be missing.
- Recommended next actions.
- Whether any files were created or modified during execution.
