# Third-Party Notices

This file records third-party skills and external tools referenced by this repository. Third-party copyrights remain with their original owners.

## Ponytail

- Name: Ponytail
- Official repository: https://github.com/DietrichGebert/ponytail
- Local path: `skills/ponytail`
- Copyright: Copyright (c) 2026 DietrichGebert
- License: MIT
- License text: `skills/ponytail/LICENSE`; duplicate copy at `licenses/ponytail-LICENSE`
- NOTICE file: none found in the local copy or upstream tag checked
- Upstream version: `v4.9.0`
- Upstream commit checked: `0a4dd63ad4541f4f655c4108a295916f3c1d8fda`
- Local copy status: vendored and locally modified copy; not guaranteed to be a complete upstream mirror; some files may differ from the upstream tag
- Local package metadata: `skills/ponytail/package.json` reports `@dietrichgebert/ponytail` version `4.9.0`, license `MIT`, homepage `https://github.com/DietrichGebert/ponytail`
- Redistribution: permitted under MIT if the copyright notice and permission notice are included in all copies or substantial portions
- Current obligation status: license and copyright notice are preserved
- Local authorship note: local changes are not represented as belonging to the original copyright holder
- Included runtime files: `AGENTS.md`, `__init__.py`, `hooks/`, `skills/`, `commands/`, plugin metadata, `pi-extension/`, `ponytail-mcp/`, `scripts/`, and `assets/`
- Included non-runtime files: readmes, examples, benchmarks, benchmark results, tests, docs, and images
- Excluded duplicate/generated/local files: `skills/ponytail/ponytail-main.zip`, `.DS_Store`
- Local differences from upstream tag `v4.9.0`: upstream hidden platform integration directories are not present locally (`.agents`, `.claude-plugin`, `.clinerules`, `.codex-plugin`, `.cursor`, `.devin-plugin`, `.github`, `.kiro`, `.openclaw`, `.opencode`, `.qoder`, `.qoder-plugin`, `.windsurf`, `.env.example`, `.gitignore`); local files differ for `README.md`, `README.es.md`, `README.ko.md`, `docs/agent-portability.md`, `hooks/claude-codex-hooks.json`, `hooks/ponytail-runtime.js`, `tests/hooks-windows.test.js`, and `tests/hooks.test.js`; local-only files include `plugin.json`, `tests/grok-plugin.test.js`, ignored `.DS_Store`, and ignored `ponytail-main.zip`

## Frontend Design

- Name: Frontend Design
- Official repository: https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design
- Local source used: `/Users/dongjulee/.claude/plugins/cache/claude-plugins-official/frontend-design/1df77764d7a9`
- Included local path: `skills/frontend-design`
- Copyright: Anthropic, as identified by the plugin metadata
- License: Apache License 2.0
- License text: copied skill license at `skills/frontend-design/LICENSE.txt`; plugin root Apache-2.0 license at `licenses/frontend-design-LICENSE.txt`
- NOTICE file: none found in the local plugin copy
- Upstream commit used by local Claude plugin marketplace/cache: `1df77764d7a936af30b51578b0c15fc5e8183715`
- Current official `claude-code` main commit checked: `ab9b2cf7bb9e4f98ff264c07a22e46d83c29c558`
- Redistribution: permitted under Apache-2.0 if the license is included, attribution notices are retained, modified files are marked, and any upstream NOTICE file is preserved when present
- Current obligation status: skill `LICENSE.txt` is included unchanged from the local plugin cache; the plugin root Apache-2.0 license is also preserved in `licenses/`; no local modifications were made to the copied skill files
- Included runtime files: `skills/frontend-design/SKILL.md`, `skills/frontend-design/LICENSE.txt`
- Excluded non-runtime files: Claude plugin cache state, `.in_use`, plugin README, and `.claude-plugin` metadata
- Local differences from current official `claude-code` main: the installed marketplace/cache copy differs from the current `main` plugin `SKILL.md` and `.claude-plugin/plugin.json`; this repository preserves the installed `1df77764d7a9` copy rather than current `main`

## Claudex Loop

- Name: Claudex Loop
- Official repository: https://github.com/chaseai-yt/claudex-loop
- Included local paths: `skills/claudex-loop`, `skills/codex-review`, `skills/codex-build`
- Copyright: Copyright (c) 2026 Chase AI
- License: MIT
- License text: `licenses/claudex-loop-LICENSE`
- Upstream commit: `8cf5e2c1771c5151d90c12642391d0ba8fa71b0e`
- Local copy status: the included skill directories are unmodified copies from the pinned commit
- Included runtime files: all files under the three included skill directories, including `claudex-loop/references/` and `claudex-loop/scripts/runner.py`
- Excluded upstream paths: `skills/claudex-route`, `legacy/`, `tests/`, `.github/`, `.claude-plugin/`, `.codex-plugin/`, and other repository/plugin metadata
- Third-party adaptation: `skills/claudex-loop/CONTEXT-FORMAT.md` and `skills/claudex-loop/ADR-FORMAT.md` are adapted from Matt Pocock's `grill-with-docs` skill, Copyright (c) 2026 Matt Pocock, under MIT
- Third-party notice: `licenses/claudex-loop-matt-pocock-NOTICE.md`
- Current obligation status: the upstream license, its attribution, and the applicable Matt Pocock notice and MIT text are preserved

## Graphify

- Name: Graphify
- Official repository: https://github.com/Graphify-Labs/graphify
- Local path: `skills/graphify/SKILL.md`
- Copyright: Copyright 2026 Safi Shamsi and the Graphify contributors, per upstream NOTICE
- License: Apache License 2.0
- License text reference: `licenses/graphify-LICENSE`; upstream legacy MIT text referenced by NOTICE is preserved at `licenses/graphify-LICENSE-MIT`
- NOTICE text reference: `licenses/graphify-NOTICE`
- Upstream commit checked: `c9f99018774e2e0380e9f65b3959944559a0d5f6`
- Redistribution: the Graphify program is not redistributed in this repository; the license and NOTICE are retained as reference for the external tool named by the wrapper
- Current obligation status: no Graphify source, package, generated graph, index, cache, or project configuration is included
- Included local file: independently authored operational wrapper at `skills/graphify/SKILL.md`
- Modification status: not a copied or modified Graphify upstream file
