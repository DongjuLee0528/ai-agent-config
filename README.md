# ai-agent-config

Shared AI agent instructions, skills, and routing rules for local development.

## Repository Contents

This repository contains two kinds of material:

- Locally authored shared rules and skills: `AGENTS.md` and the top-level shared skills under `skills/*/SKILL.md`, including `graphify`, `software-debugging`, `api-contract-review`, `security-review`, hardware review/debugging, ML review, and dual-agent workflow guidance.
- Third-party public skills used from this configuration: Ponytail, Frontend Design, and Claudex Loop.

External project copyrights remain with their original copyright holders. This repository preserves third-party license texts and records source, version, and modification status in `THIRD_PARTY_NOTICES.md`.

## Included Third-Party Skills

| Project | Local path | Source | License |
| --- | --- | --- | --- |
| Ponytail | `skills/ponytail` | https://github.com/DietrichGebert/ponytail | MIT |
| Frontend Design | `skills/frontend-design` | https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design | Apache-2.0 |
| Claudex Loop | `skills/claudex-loop`, `skills/codex-review`, `skills/codex-build` | https://github.com/chaseai-yt/claudex-loop | MIT |

Ponytail is included as a vendored and locally modified copy, not as a complete upstream repository mirror. The local copy is based on upstream tag `v4.9.0` (`0a4dd63ad4541f4f655c4108a295916f3c1d8fda`). Some files may differ from the upstream tag. The original MIT copyright notice and license are preserved at `skills/ponytail/LICENSE` and copied to `licenses/ponytail-LICENSE`; local changes are not attributed to the original copyright holder.

Frontend Design is included from the locally installed Claude plugin cache at commit `1df77764d7a936af30b51578b0c15fc5e8183715`. Only the skill file and its `LICENSE.txt` are included under `skills/frontend-design/`. The copied skill license is preserved at `skills/frontend-design/LICENSE.txt`; the plugin root Apache-2.0 license text is preserved at `licenses/frontend-design-LICENSE.txt`.

## Claudex Loop

Claudex Loop hardens plans through independent Claude/Codex review before an optional build and final cross-inspection. Use it for larger features, multi-module changes, or significant design decisions; keep `dual-agent-development` as the default for scoped bug fixes, targeted features, refactors, tests, and configuration changes.

The vendored copy is pinned to `8cf5e2c1771c5151d90c12642391d0ba8fa71b0e` and includes `skills/claudex-loop`, `skills/codex-review`, and `skills/codex-build` unchanged. It excludes `skills/claudex-route`, `legacy/`, `tests/`, `.github/`, and plugin manifests. The upstream MIT license is preserved at `licenses/claudex-loop-LICENSE`; the Matt Pocock MIT notice required by the adapted context and ADR formats is preserved at `licenses/claudex-loop-matt-pocock-NOTICE.md`.

In hardware or robotics projects, no `PROOF_CMD` or builder-run command may upload firmware, actuate hardware, drive GPIO/PWM/relays, reset devices, or otherwise interact with physical hardware. Run `hardware-control-review` before physical testing, which still requires explicit user approval.

Install all shared skills manually without modifying this repository. These commands assume the repository is cloned at `~/ai-agent-config`; if it is elsewhere, replace `$HOME/ai-agent-config` with the repository's actual absolute path.

Check existing entries with the same names before installing. The commands below report and preserve existing files or links instead of overwriting them. If Claudex Loop is already installed through the Claude Code marketplace, these symlinks will create duplicate skills; uninstall either the marketplace plugin or the symlinked copy before using them.

```sh
mkdir -p ~/.claude/skills ~/.agents/skills
for skill_path in \
  api-contract-review claudex-loop codex-build codex-review \
  dual-agent-development embedded-security-review frontend-design graphify \
  hardware-control-review hardware-debugging ml-data-model-review \
  security-review software-debugging \
  ponytail/skills/ponytail ponytail/skills/ponytail-audit \
  ponytail/skills/ponytail-debt ponytail/skills/ponytail-gain \
  ponytail/skills/ponytail-help ponytail/skills/ponytail-review
do
  skill_name=${skill_path##*/}
  for skill_root in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
    target="$skill_root/$skill_name"
    if [ -e "$target" ] || [ -L "$target" ]; then
      printf 'Existing entry, check before replacing: %s\n' "$target"
    else
      ln -s "$HOME/ai-agent-config/skills/$skill_path" "$target"
    fi
  done
done
```

To update the vendored copy, clone the upstream repository into a temporary directory, check out the desired commit, replace only the same three skill directories, copy the upstream `LICENSE`, preserve any applicable third-party notices, then update the pinned SHA in this README and `THIRD_PARTY_NOTICES.md`. Do not import the excluded paths, and verify the copied files byte-for-byte before review.

## External Tools Not Included

Graphify is not included as a program, package, generated graph, index, cache, or project configuration. `skills/graphify/SKILL.md` is an independently authored wrapper that documents when and how to use project-local Graphify safely. Graphify source is https://github.com/Graphify-Labs/graphify and is licensed under Apache-2.0. The verified upstream Apache-2.0 license, MIT legacy license, and notice texts are preserved for reference at `licenses/graphify-LICENSE`, `licenses/graphify-LICENSE-MIT`, and `licenses/graphify-NOTICE`.

## Local Source of Truth

- Repository rules: `AGENTS.md`
- Shared skill routing and behavior: each top-level `skills/*/SKILL.md`
- Third-party inventory and obligations: `THIRD_PARTY_NOTICES.md`
- Third-party license texts: `skills/ponytail/LICENSE`, `skills/frontend-design/LICENSE.txt`, and `licenses/`
- Project AGENTS.md template shared skill path: `~/ai-agent-config/skills/frontend-design/SKILL.md`

## Usage

Clone this repository and point your AI coding tools at the relevant `AGENTS.md` and `skills/` files. Do not commit local IDE settings, `.DS_Store`, plugin cache files, generated archives, Graphify indexes, Graphify caches, or project-specific generated analysis data.
