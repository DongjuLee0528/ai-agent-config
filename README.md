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

`ponytail`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`, `ponytail-review`, and `frontend-design` are omitted because they are already provided by `ponytail@ponytail` and `frontend-design@claude-plugins-official`; linking these repository copies would create duplicates.

```sh
mkdir -p ~/.claude/skills ~/.agents/skills
for skill_path in \
  api-contract-review claudex-loop codex-build codex-review \
  dual-agent-development embedded-security-review graphify \
  hardware-control-review hardware-debugging ml-data-model-review \
  security-review software-debugging
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

## Project instruction templates

Copy `templates/project-AGENTS.md` to `./AGENTS.md` in the project root and fill in only its project-specific placeholders. For Claude Code versions that do not load `AGENTS.md` directly, also copy `templates/project-CLAUDE.md` to `./CLAUDE.md` in the same directory. These destination names matter because Claude Code discovers `CLAUDE.md` by name and its `@AGENTS.md` directive imports a sibling file named exactly `AGENTS.md`.

## External Tools Not Included

Graphify is not included as a program, package, generated graph, index, cache, or project configuration. `skills/graphify/SKILL.md` is an independently authored wrapper that documents when and how to use project-local Graphify safely. Graphify source is https://github.com/Graphify-Labs/graphify and is licensed under Apache-2.0. The verified upstream Apache-2.0 license, MIT legacy license, and notice texts are preserved for reference at `licenses/graphify-LICENSE`, `licenses/graphify-LICENSE-MIT`, and `licenses/graphify-NOTICE`.

## Harness

`AGENTS.md` is a set of instructions the model can choose to follow. The harness under `harness/` is a second, independent layer that enforces a small set of the most critical rules at the tool level, so they hold even if the model ignores or misreads `AGENTS.md`, and even in permission modes that skip normal confirmation prompts (Claude Code's `bypassPermissions` / `--dangerously-skip-permissions`, Codex's `never` approval policy). The harness does not replace `AGENTS.md`: it enforces only a narrow set of destructive or hardware-affecting actions; everything else is still governed by `AGENTS.md` and ordinary judgment.

The files under `harness/` are templates only. Nothing in this repository is applied automatically, and installing the harness never modifies files inside this repository. You merge the templates into your own `~/.claude/` and `~/.codex/` configuration by hand, using the commands below.

| Rule | Claude Code | Codex |
| --- | --- | --- |
| Block `git commit` | `permissions.deny` in `harness/claude/settings.json` | `forbidden` rule in `harness/codex/rules/harness.rules` |
| Block `git push` (incl. force) | `permissions.deny` | `forbidden` rule |
| Block `git reset --hard` | `permissions.deny` | `forbidden` rule |
| Block `git clean` | `permissions.deny` | `forbidden` rule |
| Block `rm -rf` | `permissions.deny` | `forbidden` rule |
| Block reading/editing `.env`, private keys, credential files | `permissions.deny` (`Read` rules; also blocks `Edit`/`Write` on the same path). `.env.example` and `.env.sample` are carved out with `Read(!.env.example)` / `Read(!.env.sample)` gitignore-negation entries so template files stay readable; every other `.env.*` suffix stays blocked. | not covered — execpolicy only governs shell commands, not file reads |
| Block firmware flash tools (`arduino-cli upload`, `platformio`/`pio upload`, `avrdude`, `esptool`, `st-flash`, `dfu-util`, `openocd`) | `PreToolUse` hook in `harness/claude/hooks/block-hardware-commands.sh` (`permissionDecision: "deny"`) — Claude Code cannot run it at all; the message tells the user to run it manually in their own terminal | `prompt` rule in `harness/codex/rules/harness.rules` — Codex asks the user for approval (see the approval-policy caveat below) |
| Block direct serial-device writes (`/dev/tty*`, `/dev/cu*`) | same `PreToolUse` hook, matched on the full command text, same `"deny"` decision | not directly matched by execpolicy (prefix-only); covered instead by `sandbox_mode = "workspace-write"` in `harness/codex/config.snippet.toml`, since `/dev/tty*` is outside the workspace and normally falls through to approval (see caveat below) |

Known limits, so the harness isn't mistaken for a sandbox: Claude Code's `Bash` deny rules match the literal command text Claude writes, not the underlying program, so `Bash(rm -rf *)` stops `rm -rf` but not `/bin/rm -rf`, `sh -c 'rm -rf ...'`, or a different argument order like `rm -fr`. Codex's `execpolicy` rules match an argv prefix the same way. Neither is a substitute for OS-level sandboxing; pair them with Claude Code's Bash sandbox or Codex's `workspace-write` sandbox for enforcement that doesn't depend on command text.

`Bash(rm -rf *)` stays broad on purpose — the harness blocks the agent from running any recursive force delete rather than trying to distinguish a destructive path from a safe one. This means the agent also can't clean up build output, `node_modules`, or similar directories on its own; run that cleanup manually yourself.

Codex's `platformio`/`pio` `prompt` rules only match `run -t upload` and `run --target upload` as a fixed token sequence right after `run`, so a plain `pio run` or `pio run -e <env>` build is allowed without a prompt. `prefix_rule` in execpolicy matches a fixed position in argv, not "contains anywhere" — so any other flag between `run` and the target flag is not caught, and neither is the target flag written in some other position. For example, `pio run -e esp32dev -t upload` (an environment flag before `-t upload`) is not matched and runs without a prompt. Treat this as a convenience guard against the common invocation, not a guarantee against every valid PlatformIO argument order.

Claude Code's `permissions.deny` list allows gitignore-style `!` negation entries listed after the pattern they carve an exception out of, but only within the same settings file: `Read(!.env.example)` and `Read(!.env.sample)` (after `Read(.env.*)`) is how the `.env` example/template carve-out above works. The private-key and credential rules (`*.pem`, `*.key`, `id_*`, `.aws/credentials`, `.npmrc`, `.netrc`, `.git-credentials`) are left broad and un-carved on purpose: the same trade-off would also make a project's test fixtures named like real key/credential files unreadable to Claude Code (for example a fixture `id_rsa_test` or a test `.pem`) — that is an accepted false positive, not a bug, since silently narrowing these patterns risks missing a real secret file with an unusual name. Rename test fixtures to avoid the sensitive-looking pattern, or read them yourself, instead of loosening these rules.

Codex's `prompt` rules assume an approval policy that can actually prompt (e.g. `approval_policy = "on-request"`, the default this harness sets). Under `approval_policy = "never"` — set explicitly by some callers, such as claudex-loop builder runs (`skills/claudex-loop/scripts/runner.py` passes `-c approval_policy="never"`) — Codex has no prompt to fall back to: a command that would otherwise be a `prompt` decision is rejected outright instead of asked about, and a sandbox-escaping write such as `/dev/tty*` under `sandbox_mode = "workspace-write"` fails instead of falling through to approval. Either way the action doesn't run, just without a chance to approve it in the moment.

### Install / merge steps

Run these yourself; nothing here is applied for you.

All of these commands are safe to re-run: an existing hook/rules/profile file is left alone (a warning names it instead of overwriting it), and the `settings.json` merge deduplicates by hook command instead of appending a second copy each time.

**Claude Code** — install the hardware hook, then merge deny rules and the hook registration into `~/.claude/settings.json`, without discarding your existing settings, plugins, other hooks, or MCP entries:

```sh
mkdir -p ~/.claude/hooks
if [ -e ~/.claude/hooks/block-hardware-commands.sh ]; then
  echo "Existing file, check before replacing: ~/.claude/hooks/block-hardware-commands.sh"
else
  cp ~/ai-agent-config/harness/claude/hooks/block-hardware-commands.sh ~/.claude/hooks/
  chmod +x ~/.claude/hooks/block-hardware-commands.sh
fi

mkdir -p ~/.claude
[ -e ~/.claude/settings.json ] || echo '{}' > ~/.claude/settings.json

jq --arg home "$HOME" -s '
  .[0] as $base | .[1] as $tmpl |
  ($tmpl.hooks.PreToolUse | map(.hooks |= map(.command |= sub("\\$HOME"; $home)))) as $tmpl_hooks |
  ($base.hooks.PreToolUse // []) as $base_hooks |
  ([$base_hooks[].hooks[]?.command]) as $existing_commands |
  ($base.permissions.deny // []) as $base_deny |
  $base
  | .permissions.deny = ($base_deny + ($tmpl.permissions.deny - $base_deny))
  | .hooks.PreToolUse = ($base_hooks + ($tmpl_hooks | map(select(([.hooks[].command] - $existing_commands) != []))))
' ~/.claude/settings.json ~/ai-agent-config/harness/claude/settings.json > /tmp/claude-settings-merged.json

diff ~/.claude/settings.json /tmp/claude-settings-merged.json   # review before applying
mv /tmp/claude-settings-merged.json ~/.claude/settings.json
```

The `select(([.hooks[].command] - $existing_commands) != [])` step is the dedupe for hooks: a template `PreToolUse` entry is only appended if at least one of its hook commands isn't already present anywhere in your existing `PreToolUse` list, so re-running this after it already merged once adds nothing new. `permissions.deny` is deduped the same way, with `$base_deny + ($tmpl.permissions.deny - $base_deny)` rather than `unique` — `unique` sorts the array, which would reorder the `Read(!.env.example)` / `Read(!.env.sample)` negation entries ahead of the `Read(.env.*)` pattern they carve an exception out of, and gitignore-negation order matters (a `!` entry only carves out the patterns listed *before* it). The `-` form only ever appends new template entries after whatever's already there, so relative order — and the negation carve-out — survives every re-run. Everything else already in your `settings.json` — plugins, other hooks, `mcpServers`, etc. — passes through untouched because the merge only ever assigns `.permissions.deny` and `.hooks.PreToolUse` on top of `$base`.

If `~/.claude/CLAUDE.md` does not already exist, install the `AGENTS.md` import:

```sh
[ -e ~/.claude/CLAUDE.md ] && echo "Existing file, check before replacing: ~/.claude/CLAUDE.md" \
  || cp ~/ai-agent-config/harness/claude/CLAUDE.md ~/.claude/CLAUDE.md
```

**Codex** — install the execpolicy rules and the optional review profile, then merge the sandbox/approval keys into `~/.codex/config.toml`:

```sh
mkdir -p ~/.codex/rules
if [ -e ~/.codex/rules/harness.rules ]; then
  echo "Existing file, check before replacing: ~/.codex/rules/harness.rules"
else
  cp ~/ai-agent-config/harness/codex/rules/harness.rules ~/.codex/rules/harness.rules
fi

if [ -e ~/.codex/review.config.toml ]; then
  echo "Existing file, check before replacing: ~/.codex/review.config.toml"
else
  cp ~/ai-agent-config/harness/codex/review.config.toml ~/.codex/review.config.toml
fi

grep -nE '^(sandbox_mode|approval_policy)\s*=' ~/.codex/config.toml \
  && echo "sandbox_mode/approval_policy already set — edit ~/.codex/config.toml by hand instead of appending" \
  || cat ~/ai-agent-config/harness/codex/config.snippet.toml >> ~/.codex/config.toml
```

Use the review profile for one session with `codex --profile review` (raises `model_reasoning_effort` to `high` for that session only; the base config keeps `low` as the default).

These commands assume the repository is cloned at `~/ai-agent-config`; if it is elsewhere, replace `$HOME/ai-agent-config` with the repository's actual absolute path. Files here are copied, not symlinked, so pulling an update to this repository does not update your installed copies by itself. Re-running the commands above after a pull picks up new `permissions.deny` entries and the hook registration in `~/.claude/settings.json` (they merge). It does **not** update the hook script, `harness.rules`, `review.config.toml`, or `CLAUDE.md` themselves, since an existing file there is deliberately left alone — remove or diff-and-replace that specific file yourself first if you want a content change from an update to take effect.

## Local Source of Truth

- Repository rules: `AGENTS.md`
- Tool-level enforcement templates: `harness/` (see [Harness](#harness))
- Shared skill routing and behavior: each top-level `skills/*/SKILL.md`
- Third-party inventory and obligations: `THIRD_PARTY_NOTICES.md`
- Third-party license texts: `skills/ponytail/LICENSE`, `skills/frontend-design/LICENSE.txt`, and `licenses/`
- Project AGENTS.md template shared skill path: `~/ai-agent-config/skills/frontend-design/SKILL.md`

## Usage

Clone this repository and point your AI coding tools at the relevant `AGENTS.md` and `skills/` files. Do not commit local IDE settings, `.DS_Store`, plugin cache files, generated archives, Graphify indexes, Graphify caches, or project-specific generated analysis data.
