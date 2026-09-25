---
name: dual-agent-development
description: Use by default to implement scoped bug fixes, targeted features, refactors, tests, and configuration changes with conditional independent Codex/Claude review. Use claudex-loop instead for larger multi-module features or significant design decisions that benefit from plan hardening; do not use for analysis-only requests.
---

# Dual Agent Development

## Purpose

Coordinate implementation and proportionate verification between Codex and Claude Code.

The workflow must:

1. understand the requested task,
2. inspect the actual project,
3. protect existing user work,
4. define completion criteria,
5. select the most appropriate implementation agent,
6. implement the smallest correct change,
7. verify the implementation,
8. invoke the opposite agent for independent review when required,
9. complete the entire review even when issues are discovered,
10. report the final result to the user.

When review is required, the implementation agent and review agent must remain independent.

---

# 1. Activation

This is the default implementation workflow for scoped bug fixes, targeted features, refactors, tests, and configuration changes.

Use `claudex-loop` instead for larger features, multi-module changes, or work with significant design decisions where plan hardening before implementation is valuable. This routing does not replace this workflow or relax any existing rule: do not commit or push without explicit user instruction, protect user changes, and keep analysis-only skills analysis-only.

Delegated `claudex-loop` builds require a clean checkout. If the target has uncommitted user work, stop and ask rather than stashing, resetting, moving, or otherwise altering it. Because `claudex-loop` creates `PLAN.md` and `PLAN-REVIEW-LOG.md`, ask whether to keep them in Git; if not, recommend the exact `.gitignore` entries `PLAN.md` and `PLAN-REVIEW-LOG.md`.

For hardware or robotics projects, `PROOF_CMD` and every builder-run command must not upload firmware, move actuators, drive GPIO, PWM, or relays, reset devices, or otherwise interact with physical hardware. Hardware-control changes must go through `hardware-control-review` before physical testing, and physical tests still require explicit user approval.

Use this workflow when the user explicitly requests:

- implementation,
- bug fixing,
- code modification,
- refactoring,
- feature creation,
- behavior changes,
- or other changes to project files.

Do not activate this workflow when the user only requests:

- information,
- explanation,
- investigation,
- analysis,
- code review,
- architecture discussion,
- documentation lookup,
- or recommendations without modification.

If the user explicitly requests a different workflow, follow the user's request.

---

# 2. Recursion Protection

Before starting, inspect the environment variable:

`DUAL_AGENT_ROLE`

Supported values:

- `implementer`
- `reviewer`

If:

`DUAL_AGENT_ROLE=reviewer`

then:

- do not invoke another agent,
- do not invoke this workflow recursively,
- do not perform implementation,
- perform only the assigned review,
- return the complete review result.

A reviewer must never create another reviewer.

A reviewer must never start another dual-agent workflow.

Cross-agent execution must be bounded to one implementation phase and one independent review phase unless the user explicitly requests another iteration.

---

# 3. Preflight Inspection

Before modifying project files:

1. inspect the repository structure,
2. identify the relevant implementation,
3. inspect relevant configuration,
4. inspect relevant dependency and runtime versions,
5. inspect existing tests,
6. inspect Git status when Git is available,
7. inspect existing uncommitted changes,
8. identify relevant external contracts,
9. identify the likely change scope.

Existing user changes must be preserved.

Never:

- reset unrelated changes,
- revert unrelated changes,
- overwrite unrelated changes,
- include unrelated user work in the implementation,
- or treat existing user modifications as changes created by the current task.

---

# 4. Evidence Collection

Base implementation decisions on actual evidence.

Use, when relevant:

- current source code,
- configuration,
- dependency manifests,
- runtime versions,
- logs,
- tests,
- official documentation,
- official source repositories,
- official release notes.

For version-dependent behavior, determine the version actually used by the project before relying on documentation whenever reasonably possible.

Do not invent missing technical information.

If necessary information cannot be verified, explicitly mark it as unverified.

---

# 5. Completion Criteria

Before implementation, determine reasonable completion criteria.

Completion criteria should describe what must be true for the requested task to be considered successful.

Keep the criteria proportional to the task.

Do not create unnecessary process overhead for trivial changes.

Possible criteria include:

- requested behavior works,
- existing behavior remains intact,
- relevant tests pass,
- error cases behave correctly,
- external contracts remain compatible,
- no unrelated files are modified,
- no known regression is introduced.

Use these criteria during implementation and verification.

---

# 6. Change Plan

Create a concise internal change plan before editing.

The plan should identify:

- likely files involved,
- relevant call paths,
- intended behavior change,
- verification approach.

The initial scope is not an absolute file lock.

If additional files become necessary:

1. verify why they are required,
2. confirm that the change directly supports the requested task,
3. keep the expansion minimal.

Do not expand the task into unrelated cleanup or refactoring.

---

# 7. Implementer Selection

Choose between Codex and Claude Code based on the actual task.

The following are preferences, not absolute rules.

## Prefer Codex when the task is primarily:

- localized bug fixing,
- clearly scoped implementation,
- modification of specific functions or files,
- test implementation,
- targeted refactoring,
- mechanical code changes,
- focused verification,
- small or medium changes with well-defined boundaries.

## Prefer Claude Code when the task is primarily:

- broad codebase exploration,
- unfamiliar repository analysis,
- cross-module reasoning,
- architecture-level changes,
- complex dependency tracing,
- large refactoring,
- behavior spanning many components,
- tasks requiring extensive repository context.

## Frontend UI/UX Routing

Frontend work is not automatically routed by file type. Route on the task's **primary objective**, not on whether the code happens to be frontend code. This is not "all frontend work → Claude Code" — see the exceptions below.

Prefer Claude Code, using the official `frontend-design` skill when installed and relevant, when the primary objective is:

- UI or UX design or improvement, page design or layout, visual hierarchy,
- styling, responsive design, typography, spacing, visual consistency or polish,
- dashboard or component visual design, animations, micro-interactions, visual accessibility,
- creation or redesign of a visually important frontend component or page.

Examples: "Create the dashboard UI", "Redesign the login page", "Improve the responsive layout", "Improve the visual quality of this React component."

Use the normal preferences above instead — do not route to `frontend-design` — when the primary objective is:

- business logic, authentication, authorization, JWT/token handling,
- API integration, state management, data fetching, caching, routing logic, TypeScript logic, frontend architecture,
- performance debugging, build/configuration issues, test failures, non-visual bug fixes.

Examples: "JWT refresh does not work in React" and "The API response is not updating the state" use normal routing even though the code is frontend code. "Fix an authorization vulnerability in the frontend/backend flow" follows security routing, not `frontend-design`, merely because React is involved.

For a mixed task, route by primary objective: a visual/UX goal with incidental supporting logic changes may still go to Claude Code + `frontend-design`; a functional, architectural, security, data-flow, or bug-fix goal with incidental visual changes uses normal routing. Do not split a trivial mixed task across two agents to satisfy this rule; separate clearly separable large UI and logic/security components only when doing so materially improves correctness or review quality.

When `frontend-design` implementation proceeds, it still follows Section 8 (Implementation) and AGENTS.md in full:

- preserve the project's existing design system, component library, typography, spacing, color tokens, CSS/Tailwind conventions, reusable components, and accessibility conventions; prefer consistency with the existing product over `frontend-design`'s default aesthetic; do not redesign unrelated areas. A greenfield project with no established design system may adopt `frontend-design`'s aesthetic direction instead.
- Ponytail, when available, still applies in full — `frontend-design` is not license for unnecessary abstraction, components, dependencies, speculative functionality, unrelated redesign, or excessive animation/visual complexity.
- do not add a UI library or dependency merely for convenience (AGENTS.md Section 7); prefer what the project already provides.
- it does not override project architecture, framework conventions, component boundaries, or security requirements.

Review routing is unchanged: this implementation still goes through Sections 10-20 exactly as any other Claude Code implementation. Codex performs the independent review, must complete the full reasonable review before concluding (Section 13), and must not automatically modify the implementation (Section 20) — no automatic reviewer-to-fixer loop.

`frontend-design` never changes *whether* a task is a security review or a diagnostic task. A primarily security task uses `security-review` or `embedded-security-review`, not this workflow, merely because the affected code is frontend code; an approved security correction that requires frontend changes still follows the implementation flow above. A dashboard controlling physical hardware may use `frontend-design` for its visual layer, but hardware behavior, firmware, device security, and physical-state testing remain owned by `hardware-debugging` and `embedded-security-review`.

If `frontend-design` cannot be loaded (not installed, disabled, or unavailable), do not fabricate its behavior or invent a replacement skill. Claude Code may still implement the UI using existing project conventions; state plainly in the report that `frontend-design` was not used.

Do not select an agent solely because of these categories.

Consider:

- task complexity,
- repository size,
- change scope,
- context requirements,
- required reasoning depth,
- available tools,
- previous verified evidence within the current task.

The goal is to select the agent most suitable for the specific task.

---

# 8. Implementation

The selected implementation agent must:

1. follow AGENTS.md,
2. follow applicable project-specific instructions,
3. apply Ponytail when available,
4. preserve existing architecture where appropriate,
5. implement the smallest correct change,
6. avoid unrelated modifications,
7. avoid speculative functionality,
8. preserve external contracts unless change is required,
9. preserve existing user work,
10. verify the implementation.

Do not run `git commit`.

Do not run `git push`.

---

# 9. Implementer Verification

After implementation, the implementer must perform the strongest reasonable verification available.

Use relevant:

- automated tests,
- targeted tests,
- build checks,
- compilation,
- static analysis,
- linting,
- type checking,
- runtime verification,
- focused manual verification.

Do not run unrelated expensive verification without a reason.

Never claim a test was executed when it was not.

Never claim verification succeeded when it was not performed.

Record:

- verification performed,
- verification passed,
- verification failed,
- verification unavailable.

---

# 10. Review Decision and Reviewer Selection

Skip opposite-agent review only for trivial changes such as:

- documentation-only edits,
- comment or typo fixes,
- very small changes that cannot affect logic or runtime behavior.

Always require opposite-agent review for changes involving:

- logic,
- security,
- authentication or authorization,
- data handling,
- configuration that affects runtime behavior,
- hardware-control code.

Changes to `AGENTS.md`, any `SKILL.md`, review scripts, or agent or harness configuration are workflow configuration changes, not documentation-only edits. Workflow configuration changes always require independent review. When run through claudex-loop, its opposite-provider final inspection satisfies this requirement, so no additional dual-agent review is needed.

When unsure, run the review. The implementer must state in the final report whether review was run or skipped and why.

When review is required, the reviewer must be the opposite agent.

If:

`IMPLEMENTER=codex`

then:

`REVIEWER=claude`

If:

`IMPLEMENTER=claude`

then:

`REVIEWER=codex`

Invoke the reviewer with:

`DUAL_AGENT_ROLE=reviewer`

The reviewer must not invoke another agent.

---

# 11. Review Handoff

Before invoking the reviewer, provide a short handoff containing exactly:

- changed files,
- intent,
- verification commands run and their results,
- known risks,
- anything explicitly out of scope.

Write the handoff to a temporary file outside the target repository and pass it to the review script as its second argument. The handoff is a navigation aid, not evidence. The reviewer must verify the actual diff and relevant files, but should start from the handoff instead of re-exploring unrelated parts of the repository.

---

# 12. Reviewer Independence

The reviewer must independently inspect the implementation.

Do not trust the implementer's summary as proof of correctness.

The reviewer should inspect, when relevant:

- Git diff,
- modified files,
- surrounding implementation,
- relevant call paths,
- affected interfaces,
- tests,
- test results,
- configuration,
- dependency changes,
- error handling,
- security implications,
- regression risk.

The reviewer may independently execute safe verification commands when appropriate.

The reviewer must not modify implementation files.

The reviewer must not fix discovered issues.

---

# 13. Full Review Requirement

Finding one problem must not terminate the review.

When a problem is discovered:

1. record the finding,
2. continue reviewing,
3. inspect the remaining changed code,
4. inspect relevant affected behavior,
5. continue collecting material findings.

The reviewer must complete the entire reasonable review scope before issuing the final verdict.

Do not stop at the first failure.

---

# 14. Review Scope

The reviewer should evaluate:

## Correctness

- Does the implementation satisfy the requested behavior?
- Are there logical errors?
- Are edge cases mishandled?

## Regression

- Could existing behavior be broken?
- Are shared components affected unexpectedly?

## Scope

- Were unrelated files changed?
- Was unnecessary refactoring introduced?
- Is the change larger than necessary?

## Architecture

- Does the change respect the existing architecture?
- Was unnecessary abstraction introduced?
- Is SOLID being applied reasonably rather than mechanically?

## Error Handling

- Are failures hidden?
- Are exceptions swallowed?
- Are invalid fallback values masking errors?

## Security

- Were authentication or authorization controls weakened?
- Were secrets exposed?
- Was unsafe input handling introduced?

## Dependencies

- Were unnecessary dependencies introduced?
- Were dependency versions changed without justification?

## Testing

- Were relevant tests executed?
- Were tests weakened or bypassed?
- Are important cases unverified?

## Compatibility

- Were APIs, schemas, configuration keys, protocols, or external contracts unintentionally changed?

## Maintainability

- Is the implementation understandable?
- Is complexity justified by the requirement?

---

# 15. Finding Quality

Only report findings that are supported by evidence.

Do not report personal style preferences as defects.

Do not invent hypothetical problems without a realistic failure path.

Each material finding should contain:

- severity,
- location,
- problem,
- evidence or reasoning,
- impact,
- recommended direction.

Do not automatically modify the code.

---

# 16. Finding Deduplication

After completing the review:

1. examine all findings,
2. identify findings caused by the same root cause,
3. consolidate duplicates,
4. preserve distinct impacts where useful.

Do not inflate the report by listing the same defect multiple times.

Prefer one root-cause finding with clearly described consequences.

---

# 17. Severity

Use the following severity levels.

## CRITICAL

Use when the issue can reasonably cause:

- severe security compromise,
- destructive data loss,
- catastrophic system behavior,
- or another immediately unacceptable production risk.

## HIGH

Use when the issue can reasonably cause:

- major functional failure,
- authentication or authorization problems,
- significant regression,
- serious reliability problems,
- major contract breakage.

## MEDIUM

Use when the issue causes:

- limited functional defects,
- incorrect edge-case behavior,
- meaningful maintainability problems with practical impact,
- incomplete error handling with realistic consequences.

## LOW

Use for:

- minor non-blocking defects,
- limited robustness problems,
- small but real maintainability concerns.

Do not assign severity merely to make a finding appear more important.

---

# 18. Verdict

After the full review, issue exactly one verdict.

## PASS

Use when:

- no material defect was discovered,
- required verification succeeded,
- no important verification gap remains.

## PASS WITH RISKS

Use when:

- no confirmed blocking defect was discovered,
- but meaningful verification could not be completed,
- or environmental limitations leave unresolved risk.

Examples:

- unavailable hardware,
- unavailable external service,
- missing runtime environment,
- tests that cannot be executed for a documented reason.

## FAIL

Use when:

- one or more confirmed material defects require correction.

A FAIL verdict does not authorize the reviewer to modify the implementation.

---

# 19. Reviewer Failure

If the secondary agent:

- is unavailable,
- cannot start,
- times out,
- crashes,
- returns unusable output,
- or cannot access the required project context,

do not report cross-agent verification as successful.

Report the review as incomplete.

Do not silently replace independent review with the implementer's own review.

Do not create an unbounded retry loop.

---

# 20. Corrective Changes

If the reviewer returns FAIL:

- do not automatically modify the implementation,
- do not automatically invoke the implementer again,
- report all findings to the user,
- wait for explicit user instruction before starting corrective implementation.

If the user requests correction:

1. begin a new bounded implementation cycle,
2. address the approved findings,
3. verify the corrections,
4. perform a new independent review.

---

# 21. Temporary Artifacts

Do not leave unnecessary:

- temporary files,
- debug files,
- diagnostic output,
- generated patches,
- temporary prompts,
- temporary logs

inside the project after completion.

Preserve artifacts that are intentionally required by the project or explicitly requested by the user.

---

# 22. Final Report

The final report to the user must be written in Korean.

Keep it concise but complete.

For modification tasks, report:

1. implementation agent,
2. reason for agent selection,
3. changed files and behavior,
4. verification performed,
5. reviewer agent when review was run,
6. whether review was run or skipped and why,
7. review verdict when review was run,
8. material findings, if any,
9. verification limitations or remaining risks,
10. exactly one recommended Git commit message in English.

Do not claim successful cross-agent verification unless the independent reviewer actually completed the review.

Do not hide failed verification or reviewer failure.
