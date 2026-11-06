---
name: unslop
description: Review and refine AI-generated code, documentation, UI, and copy when they feel generic, exaggerated, over-decorated, or disconnected from the product context.
---

# Unslop

Use this skill when a result feels like generic AI output and needs a more specific, restrained, human-directed finish. Apply it to code, documentation, UI structure, visual decisions, and interface copy.

## Scope

- Identify boilerplate language, vague claims, repetitive structure, unnecessary abstraction, decorative UI, and choices that do not serve the product or user.
- Replace generic choices with decisions grounded in the project's domain, audience, existing conventions, and stated requirements.
- Prefer concrete language, useful hierarchy, deliberate restraint, and the smallest change that improves the result.
- Preserve required behavior, domain terminology, accessibility guidance, security warnings, legal notices, and user intent.
- Do not remove content merely because it sounds formal, technical, or unfamiliar.

## Routing

- Use for review or refinement of code, documentation, UI, and copy that appears formulaic or AI-generated.
- For visual UI/UX design, use with `frontend-design`; keep `frontend-design` responsible for visual direction and this skill responsible for critique and refinement.
- For actual Figma file reads or writes, use the official Codex Figma plugin's `figma-use` skill. Do not assume this repository includes or replaces that plugin.
- Do not apply automatically to unrelated bug fixes, API work, authentication, security review, or ordinary implementation where no such refinement is needed.

## Review and Change Boundary

Start with a concise list of concrete findings and explain why each choice feels generic, excessive, or context-free. Separate confirmed observations from suggestions.

Do not modify files unless the user requests implementation or explicitly approves the proposed changes. When implementation is approved, preserve existing architecture and route the work through `dual-agent-development` when it involves code or project-file changes.

Do not claim that a result is human-authored or undetectable by AI detectors. The goal is context-specific quality and intentionality, not evasion of provenance or review systems.

## Output

Report:

- reviewed scope
- concrete observations
- recommended refinements
- preserved requirements or constraints
- changes made, if authorized
- remaining uncertainty
