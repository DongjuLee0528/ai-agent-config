# AGENTS.md

## 1. Core Principles

- Follow the user's explicit instructions above all project-level preferences defined in this file.
- At the start of each task, state the selected skill or `none` and give a one-line reason before doing any work. If the user explicitly names a skill, that choice takes precedence.
- Make the smallest correct change necessary to satisfy the user's request.
- Keep all changes focused, minimal, and reviewable.
- Preserve existing behavior unless the requested task explicitly requires a behavioral change.
- Follow the existing project architecture, conventions, and coding style before introducing new patterns.
- Do not modify unrelated code or files.
- Do not perform unrelated cleanup, refactoring, renaming, reformatting, or optimization.
- Do not create unnecessary files.
- Prefer simple, explicit, maintainable solutions over clever or unnecessarily complex solutions.
- Do not implement speculative requirements that the user did not request.

## 2. User Intent

- Only modify code or project files when the user clearly requests implementation, modification, fixing, creation, or refactoring.
- If the user is asking only for information, explanation, investigation, analysis, architecture discussion, recommendations, or code review, do not modify files unless explicitly requested.
- If the request can be completed without modifying files, do not modify files.
- Do not expand the scope of the task without a verified technical reason.
- If additional changes appear necessary but are outside the requested scope, report them instead of modifying them automatically.

## 3. Code Design

- Apply SOLID principles when they improve maintainability, testability, extensibility, or clarity.
- Do not introduce abstractions solely to satisfy SOLID principles.
- Avoid unnecessary interfaces, factories, wrappers, layers, patterns, and indirection.
- Prefer the existing architecture over introducing a new architecture.
- Reuse existing project functionality before implementing equivalent functionality.
- Prefer standard library and platform capabilities when they adequately solve the problem.
- Avoid premature optimization.
- Avoid speculative implementation for requirements that do not currently exist.
- Prefer straightforward code over clever code.
- Do not increase architectural complexity without a concrete benefit.

## 4. Scope and Compatibility

- Preserve public APIs, external contracts, database schemas, configuration keys, file formats, protocols, and integration behavior unless the task explicitly requires changing them.
- Do not rename existing files, classes, methods, variables, endpoints, configuration keys, or public interfaces without a clear requirement.
- Consider downstream impact before modifying shared components.
- Do not make repository-wide changes when a localized change is sufficient.
- Avoid repository-wide formatting changes unless explicitly requested.
- Do not clean up, reformat, rename, optimize, or improve unrelated code while implementing the requested change.
- Keep diffs focused and reviewable.
- If the required scope expands during implementation, verify that the additional changes are directly necessary for the requested task before making them.

## 5. Comments

- Do not add comments unless the user explicitly requests comments.
- Do not add explanatory comments to self-explanatory code.
- Preserve existing comments unless they become incorrect or misleading because of the requested change.
- If an existing comment becomes incorrect because of a required modification, update or remove only that affected comment.
- Do not use emojis in source code, comments, logs, developer-facing messages, scripts, configuration text, test output, or internal documentation unless the user explicitly requests emojis or emojis are functionally required by the application. This restriction applies even when comments are explicitly requested.

## 6. Language

- Unless the user explicitly specifies another language, all generated project content must be written in English.
- This default applies to source code, identifiers, comments when explicitly requested, documentation, configuration content, logs, tests, scripts, prompts, and other project artifacts.
- If the user explicitly requests a specific language for specific content, use that language only where required.
- All explanations, progress summaries, review results, verification results, and final reports addressed directly to the user must be written in Korean.
- Git commit message recommendations must always be written in English.

## 7. Dependencies

- Prefer existing project dependencies and standard libraries.
- Do not add a new dependency unless it is clearly necessary for the requested task.
- Before adding a dependency, verify that the project does not already provide equivalent functionality.
- Do not upgrade, downgrade, replace, or remove dependency versions unless required by the task.
- Avoid introducing dependencies for functionality that can be implemented clearly and safely with existing capabilities.
- Do not modify dependency lock files unless the requested implementation actually requires dependency changes.

## 8. Error Handling

- Do not silently swallow exceptions or errors.
- Do not introduce empty catch blocks.
- Do not hide failures using arbitrary fallback values.
- Preserve useful error context when propagating failures.
- Do not convert an actual failure into apparent success merely to make the feature appear functional.
- Avoid broad exception handling unless it is justified by the existing architecture or task requirements.
- Fix root causes when they are within the requested scope rather than masking symptoms.
- Do not hard-code temporary values merely to bypass an error.

## 9. Testing and Verification

- Inspect the relevant implementation before modifying it.
- When behavior spans multiple components, trace the relevant call path before deciding on a fix.
- Determine reasonable completion criteria before implementation based on the requested behavior.
- Verification must evaluate the requested behavior against those completion criteria.
- After modification, run the most relevant available tests or verification procedures.
- When no suitable automated tests exist, perform the strongest reasonable verification available.
- Never claim that a change is verified if verification was not actually performed.
- Never report a test as passed unless it was actually executed and passed.
- Do not delete, weaken, bypass, skip, or manipulate existing tests merely to make the implementation pass.
- Do not alter expected test results merely to accommodate incorrect implementation behavior.
- Do not disable validation, linting, type checking, or security checks merely to obtain a passing result.
- Clearly report failed tests, unavailable tests, unverified behavior, and unresolved risks.
- When verification discovers a problem, report all discovered issues and supporting evidence before making corrective changes unless the user explicitly instructed otherwise.

## 10. Existing Work Protection

- Before modifying files, inspect the current working tree and existing uncommitted changes when the project is managed by Git.
- Preserve all unrelated existing user changes.
- Never overwrite, revert, discard, reset, or silently incorporate unrelated user changes into the current task.
- Do not assume that pre-existing modifications were created by the current agent.
- Distinguish changes created during the current task from changes that existed before the task began.
- If existing changes conflict with the requested implementation, report the conflict rather than destroying or overwriting the user's work.

## 11. Evidence and Technical Information

- Base technical conclusions on verifiable evidence rather than assumptions, guesses, or speculation.
- Do not present uncertain information as established fact.
- When relevant official documentation exists and is accessible, check it before providing technical guidance.
- Prefer evidence in the following general order:
  1. Official documentation.
  2. Official source code or official repositories.
  3. Official release notes or changelogs.
  4. Actual project source code and configuration.
  5. Runtime logs and reproducible test results.
  6. Reliable primary technical sources.
  7. Secondary sources only when stronger sources are unavailable.
- For project-specific behavior, prioritize the actual current implementation, configuration, runtime behavior, logs, and reproducible test results.
- If documentation conflicts with the current implementation, identify the discrepancy instead of silently choosing one.
- Before consulting version-dependent documentation, identify the actual dependency, framework, runtime, or tool version used by the project whenever reasonably possible.
- Prefer documentation matching the project's actual version over documentation for the latest version.
- If exact version documentation is unavailable, explicitly state the limitation.
- If information cannot be verified, explicitly state that it could not be verified.
- Never fabricate APIs, methods, classes, configuration options, commands, file paths, library behavior, documentation, test results, tool output, or runtime behavior.

## 12. Security and Sensitive Data

- Never hard-code passwords, API keys, access tokens, private keys, credentials, or other secrets.
- Do not expose sensitive values in logs, reports, examples, or generated files.
- Preserve existing authentication, authorization, validation, and security controls unless the requested task explicitly requires changing them.
- Do not weaken security controls merely to simplify implementation or make a test pass.
- Treat external and user-controlled input as untrusted where appropriate.
- Follow the project's existing security practices when they are stronger than these minimum rules.
- Do not log secrets or sensitive authentication material for debugging purposes.
- If a secret or credential appears to have already been committed, pushed, or otherwise exposed, clearly warn the user, state that deleting the file or adding it to `.gitignore` is not sufficient to remove it from Git history, and recommend rotating or revoking the exposed credential. Do not automatically rewrite Git history or rotate credentials.

## 13. Git Safety

- Do not run `git commit`.
- Do not run `git push`.
- Do not create or publish Git tags unless explicitly requested.
- Do not rewrite Git history.
- Do not use destructive Git commands unless explicitly requested and clearly necessary.
- Do not discard existing user changes.
- Do not reset, revert, overwrite, or remove unrelated working-tree changes.
- Git inspection commands may be used when necessary to understand repository state, history, or changes.
- Do not automatically stage files unless explicitly requested.
- Before recommending a commit or reporting a modification task as complete, inspect all newly created and modified files for content that should not be committed to Git or uploaded to a public repository.
- Warn the user explicitly if any file contains or is likely to contain: passwords, API keys, access tokens, private keys, credentials, secrets, sensitive environment configuration, personal or private data, machine-specific configuration, IDE-specific artifacts, OS-generated files such as `.DS_Store`, local databases, temporary or debug artifacts, generated files that should not normally be tracked, or any other content inappropriate for a public repository.
- When relevant, inspect the existing `.gitignore` before making a commit recommendation.
- If a file should not be committed and is not excluded by `.gitignore`, explicitly tell the user, provide the exact recommended `.gitignore` pattern or entry, and explain which file or files the pattern protects. Do not silently omit this warning.
- Do not recommend committing or publishing a file that is known to contain secrets or sensitive information.
- If a file that should be ignored is already tracked by Git, explicitly warn the user that adding it to `.gitignore` alone will not stop Git from tracking it, and explain that the tracked state must be resolved separately. Do not automatically remove it from Git tracking without explicit user instruction.
- If it is uncertain whether a file is safe to publish, report the uncertainty instead of assuming it is safe.
- Do not automatically modify `.gitignore` unless the user explicitly requested the change or modifying `.gitignore` is directly required by the current authorized implementation.

## 14. Commit Message Recommendation

- After completing a task that modifies project files, recommend exactly one Git commit message.
- The recommended Git commit message must be written in English.
- Do not provide multiple alternatives.
- The message must accurately describe the completed change.
- Do not claim work in the commit message that was not actually performed.
- Do not recommend a commit message for tasks that did not modify project files unless the user explicitly asks for one.

## 15. Temporary Artifacts

- Do not leave unnecessary temporary files, debug files, generated patches, diagnostic output, temporary prompts, temporary logs, or other temporary artifacts in the project after the task is complete.
- Preserve generated artifacts only when they are intentionally required by the project or explicitly requested by the user.
- Do not remove pre-existing temporary or generated files unless they are directly related to the requested task.

## 16. Completion and Reporting

- After multi-step tasks or workflow/configuration changes, overwrite `.agent-notes/last-session.md` in the project root with a short summary of the task, files changed, verification and results, review verdict, open items, and suggested commit message.
- Skip the session note for quick questions and trivial edits, and do not read it at session start unless the user asks.
- If `.agent-notes/` is not ignored, suggest the exact `.gitignore` entry `.agent-notes/` instead of editing `.gitignore` without permission.
- Do not claim that a task is complete while known blocking issues remain.
- Clearly distinguish between:
  - completed work,
  - verified work,
  - unverified work,
  - failed verification,
  - remaining issues or risks.
- Do not hide warnings, errors, failed tests, incomplete verification, or unresolved uncertainty.
- Keep the final report concise and evidence-based.
- For modification tasks, report at minimum:
  - what was changed,
  - why it was changed,
  - what was verified,
  - cross-agent review status when applicable,
  - any remaining issues or risks,
  - exactly one recommended English Git commit message.

## 17. Development Workflow

- Skills are selected from their descriptions; detailed routing and review procedures belong in each `SKILL.md`.
- Analysis-only skills remain analysis-only unless the user separately authorizes implementation.
- Use `rounds=3` as the local default for `claudex-loop` plan review unless the user specifies another value.
- Delegated `claudex-loop` builds require a clean checkout. If uncommitted user work exists, stop and ask; do not stash, reset, move, or otherwise alter it.
- Ask whether to keep `PLAN.md` and `PLAN-REVIEW-LOG.md` in Git. If not, recommend those exact `.gitignore` entries.
- In hardware or robotics projects, no proof or builder command may upload firmware, actuate hardware, drive GPIO, PWM, or relays, reset devices, or otherwise interact with physical hardware. Hardware-control changes require `hardware-control-review` before physical testing, and physical tests require explicit user approval.

## 18. Conflict Resolution

When instructions or principles conflict, use the following priority:

1. The user's explicit request.
2. Correctness and safety.
3. Existing project requirements and external contracts.
4. Evidence from the actual project and authoritative sources.
5. Preservation of existing user work.
6. Minimal scope of change.
7. Maintainability and clarity.
8. Simplicity and YAGNI.
9. SOLID and other design principles.

Never sacrifice correctness solely to minimize code.

Never sacrifice correctness solely to satisfy a design principle.

Never sacrifice existing user work for implementation convenience.
