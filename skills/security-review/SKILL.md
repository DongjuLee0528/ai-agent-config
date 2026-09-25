---
name: security-review
description: Use for analysis-only security reviews of web applications, APIs, services, databases, authentication, deployment, containers, and CI/CD. Use embedded-security-review instead when firmware, devices, or cyber-physical paths are in scope; use api-contract-review for schema and compatibility review without a security focus.
---

# Security Review

## Purpose

Perform strict, evidence-based security reviews of web applications, APIs, backend services, frontend applications, databases, authentication systems, deployment configuration, containers, CI/CD configuration, and cloud-facing application components.

This workflow is analysis-only by default. It never automatically fixes a vulnerability and never automatically invokes `dual-agent-development`. Permission to review security is not permission to exploit, modify, attack, or remediate.

---

# 1. Activation

Use this workflow when the user requests a security review, vulnerability assessment, penetration-test-style analysis, or asks whether code, configuration, or a deployment is secure.

If the user explicitly requests implementation or a fix without asking for review, follow the user's request and use `dual-agent-development` instead, subject to the approval gates in Section 14.

---

# 2. Review Boundary

Analysis only by default. Do not:

- modify source code, configuration, or infrastructure files,
- modify dependency versions or lock files,
- modify `.gitignore`,
- rotate or regenerate credentials,
- rewrite Git history,
- invoke destructive security tooling,
- automatically invoke `dual-agent-development`,
- perform real exploitation against external, third-party, or production systems without explicit user approval.

Follow AGENTS.md Git publication safety rules (Section 12, credential and `.gitignore` handling) when a secret or sensitive file is discovered during review.

---

# 3. Reference Standards

Use, when relevant: OWASP Top 10:2025, OWASP ASVS 5.0, official framework/library documentation, official security advisories, and the actual project's code, configuration, dependency versions, and runtime evidence.

Do not blindly apply a checklist. For each candidate issue, verify whether it has a realistic path in the actual project before reporting it.

---

# 4. Attack Surface Discovery

Before evaluating vulnerabilities, identify the actual attack surface. When relevant, inspect: public endpoints, authenticated endpoints, administrative endpoints, internal APIs, device APIs, WebSocket endpoints, upload endpoints, callback/webhook endpoints, authentication flows, authorization boundaries, database access, file system access, external HTTP calls, queues, caches, message brokers, frontend trust boundaries, backend trust boundaries, third-party services, and CI/CD secrets and deployment paths.

Identify trust boundaries explicitly before evaluating what crosses them.

---

# 5. Threat Actor Modeling

During attack surface discovery, identify the realistic attacker(s) for the system under review. Consider, when relevant: anonymous external attacker, authenticated normal user, privileged user, administrator, compromised account, malicious internal service, compromised dependency, malicious uploaded content, compromised device, local attacker, CI/CD or supply-chain attacker.

Do not assume every attacker class applies to every project or every finding. For each significant finding, identify the realistic attacker prerequisite (Section 10). Use the attacker model to reduce false positives, avoid severity inflation, and avoid unrealistic exploit assumptions.

---

# 6. Review Domains

Review the domains relevant to the attack surface. Not every domain applies to every project — scope to what is plausible, but do not stop after the first plausible domain if others remain relevant (Section 12).

## Authentication

Login, password reset, account recovery, MFA, session establishment, logout, account enumeration, brute-force protections, credential-stuffing protections, default accounts, authentication bypass paths. Do not confuse authentication with authorization.

## Authorization

Object-level authorization, function-level authorization, horizontal and vertical privilege escalation, IDOR/BOLA, administrative routes, resource ownership checks, role enforcement, device-level authorization, backend trust assumptions. Trace authorization from input to protected resource.

## Session / JWT / Cookie Security

Token generation, signature verification, algorithm validation, expiration, issuer, audience, refresh tokens, token revocation, token storage, cookie `Secure`/`HttpOnly`/`SameSite`, session fixation, logout invalidation, replay risk.

## Input Validation and Injection

SQL injection, NoSQL injection, command injection, LDAP injection, expression-language injection, template injection, path traversal, unsafe deserialization, XML-related injection, header injection, log injection. Do not report injection solely because a risky API exists — verify a realistic source-to-sink path.

## Browser / Frontend Security

XSS, DOM XSS, unsafe HTML rendering, CSP where relevant, CSRF, clickjacking, unsafe redirects, token exposure, localStorage/sessionStorage sensitivity, frontend authorization assumptions, sensitive data embedded in bundles, source maps in production.

## SSRF and External Requests

User-controlled URLs, redirect following, internal network access, metadata endpoints, DNS rebinding considerations, protocol restrictions, allowlists, URL parsing inconsistencies.

## File Handling

Upload validation, MIME validation, extension validation, storage path safety, filename traversal, executable uploads, archive extraction, decompression bombs, overwrite risks, download authorization, temporary file handling.

## Secrets and Sensitive Data

Inspect relevant `.env`, `application.yml`/`.properties`, docker-compose files, CI configuration, shell scripts, test fixtures, documentation, logs, frontend environment files, and source files for passwords, API keys, access tokens, private keys, credentials, database secrets, and cloud credentials.

If a secret appears committed or exposed: report it clearly, state that deletion or `.gitignore` alone is not sufficient to remove it from history, recommend rotation/revocation when appropriate, and do not automatically rotate credentials or rewrite history.

## Cryptography and Password Storage

Password hashing, salts, approved password-hashing algorithms, hard-coded cryptographic keys, weak algorithms, insecure random generation, IV/nonce reuse, encryption-at-rest claims, TLS assumptions. Do not invent cryptographic weaknesses without evidence.

## API Security

Authentication, authorization, request validation, mass assignment, excessive data exposure, rate limiting, pagination abuse, replay, idempotency where relevant, error responses, version exposure, undocumented endpoints.

## Error Handling

Fail-open behavior, stack trace leakage, sensitive internal error exposure, exception swallowing, inconsistent authorization failure handling, exceptional-condition logic.

## Dependency and Supply Chain

Inspect actual project versions. Use official advisories, vendor advisories, or authoritative vulnerability databases when available. Do not claim a dependency is vulnerable merely because the library has historical CVEs — verify whether the project's actual version is affected. Review dependency vulnerabilities, unmaintained packages, suspicious package sources, lock files, dependency confusion risks, build scripts, third-party actions/plugins, and CI dependencies.

## CI/CD and Supply Chain Pipeline Security

Untrusted pull-request execution, forked pull-request trust boundaries, workflow permissions, token permissions, secret availability to untrusted jobs, third-party actions/plugins, action/version pinning where relevant, artifact generation, artifact integrity, artifact poisoning, artifact download/use trust, deployment credentials, release credentials, environment protection, privileged runners, self-hosted runner exposure, build/release scripts. Do not label a CI/CD configuration vulnerable without a realistic attacker path.

## Configuration and Deployment

Debug mode, default credentials, exposed management endpoints, CORS, TLS, reverse proxy configuration, environment separation, database exposure, open ports, Docker configuration, container privileges, mounted secrets, writable volumes, host networking, Linux permissions, service accounts.

## Logging and Monitoring

Secret leakage, token leakage, password leakage, personal/sensitive data in logs, security-relevant event logging, auditability, tamper considerations.

## Abuse and Availability

Rate-limit gaps, resource exhaustion, unbounded queries, expensive endpoints, upload abuse, queue flooding, authentication abuse. Do not perform DoS testing automatically (Section 7).

---

# 7. Security Testing Safety

Automatically allowed when safe: source inspection, configuration inspection, dependency inspection, `git status`, `git diff`, static analysis, build, non-destructive existing tests, offline analysis.

A command's name — "build", "test", "verify", "check" — is not proof that it is non-destructive. Before automatically running a build, test, package script, or task runner (npm/Gradle/Maven/Make/CMake or similar), inspect it when reasonably possible for side effects such as post-build deployment, live service calls, database or external API mutation, integration-environment mutation, destructive cleanup, or credential use. If side effects cannot be confidently ruled out, treat the command as potentially state-changing, explain the uncertainty, and require explicit user approval before execution.

This skill can also encounter device APIs, compromised devices, integration tests, and mixed application/device projects. A build, test, script, package task, integration test, or project-specific command that may interact with connected hardware or firmware tooling must not be treated as automatically safe either. This includes, when relevant: PlatformIO tasks, firmware build tasks, firmware flashing, firmware upload, device reset, device reboot, hardware probing, serial/device port interaction, hardware initialization, network fuzzing, device fuzzing, physical device interaction, GPIO/PWM/relay/actuator interaction, commands that may indirectly invoke device tooling, and post-build or post-test hooks that may interact with hardware. If such a side effect cannot be confidently ruled out, treat the command as potentially state-changing, explain the uncertainty, and require explicit user approval before execution. This skill remains primarily an application, web, and API security review skill; this paragraph exists only so an application-side build or test command does not accidentally cross into a connected-device or firmware side effect. For a system whose primary review target is the device, firmware, or embedded platform itself, use `embedded-security-review` instead.

Explicit user approval required before: brute-force testing, credential attacks, destructive fuzzing, high-volume requests, DoS tests, SQL injection exploitation against a live system, SSRF exploitation against real infrastructure, malicious file uploads, state-changing API attacks, account lockout tests, external system exploitation, or any action that alters data.

If uncertain whether a test is state-changing or harmful, require approval.

Approval for an active security test authorizes only that specific, approved execution. Prior approval does not authorize retries, repeated exploitation, repeated brute force, repeated credential attacks, repeated malicious uploads, repeated state-changing API tests, repeated SQL injection exploitation, repeated SSRF exploitation, repeated fuzzing, repeated high-volume testing, repeated DoS/load testing, repeated account lockout testing, or another materially equivalent active test. Before repeating an active test, present: the retest purpose, why repetition is necessary, the exact test, expected impact and risk, and stop conditions when relevant — then obtain explicit user approval again. Do not treat previous approval as persistent approval, and do not automatically loop or retry active exploitation.

---

# 8. Evidence Discipline

Prefer, in order: official documentation, official advisories, actual project source code and configuration, dependency manifests and lock files, runtime logs, reproducible tests, over assumptions.

Separate observation, inference, and confirmed evidence at each step. Do not fabricate vulnerabilities. Do not assume exploitability without a realistic attacker-to-impact path. Do not confuse insecure-looking code with confirmed exploitability. Never present an unverified claim as confirmed.

---

# 9. Confidence Levels

Confidence describes how strongly the evidence supports a finding. It is assessed independently of severity (Section 11) — a finding can be **CRITICAL** in severity while its confidence is only **POSSIBLE**, and that combination must never be silently rounded up to CONFIRMED, or dropped, or treated as equivalent to `Severity: CRITICAL / Confidence: CONFIRMED`.

**CONFIRMED**
- The security condition is directly supported by strong evidence from the actual project or environment: a verified reachable code or configuration path, reproducible behavior, a confirmed vulnerable dependency version, or a directly observable security-control failure.
- Active exploitation is not required to reach CONFIRMED when code or configuration evidence is already sufficient on its own.
- Do not use CONFIRMED merely because a dangerous API, pattern, or keyword is present.

**LIKELY**
- Strong evidence supports the issue, but one meaningful element cannot currently be directly verified (for example, the sink is reachable and unguarded but live confirmation was not performed).
- The attack path is realistic and mostly established.
- State exactly what remains unverified.

**POSSIBLE**
- There is a plausible security concern with a realistic hypothesis, but important evidence is missing.
- Do not describe a POSSIBLE finding as an established vulnerability in the report text.

**UNVERIFIED**
- The available evidence is insufficient to determine whether the issue actually exists.
- State exactly what information or verification would be required to move the finding to a higher confidence level.

Do not inflate confidence to make a finding appear more actionable. Do not deflate confidence to avoid reporting an inconvenient finding.

---

# 10. Finding Standard

Every reported vulnerability must include: severity, confidence, location, attack surface, attacker prerequisite, preconditions, source, sink or protected resource, attack path, evidence, impact, and recommended correction direction.

Use the confidence levels defined in Section 9: **CONFIRMED**, **LIKELY**, **POSSIBLE**, **UNVERIFIED**.

Do not report style preferences as vulnerabilities. Do not report theoretical issues without a realistic attack path.

---

# 11. Severity

Use **CRITICAL**, **HIGH**, **MEDIUM**, **LOW**, considering exploitability, privilege required, user interaction, data sensitivity, blast radius, integrity impact, availability impact, persistence, and physical consequences where relevant. Do not inflate or deflate severity to make a finding appear more or less important.

Severity and confidence (Section 9) are independent axes. Set each based on its own criteria; a high severity does not justify raising confidence, and a low confidence does not justify lowering severity.

---

# 12. Full Review Requirement

Do not stop after finding the first vulnerability. Continue the complete reasonable review across the applicable domains (Section 6) and collect all material findings before concluding. Deduplicate findings that share the same root cause; preserve distinct impacts where useful.

---

# 13. Verdict

Return exactly one:

- **PASS** — no material issue found and meaningful verification completed.
- **PASS WITH RISKS** — no confirmed blocking issue, but meaningful areas remain unverified.
- **FAIL** — one or more confirmed material security defects require correction.

A FAIL verdict does not authorize automatic corrective modification.

---

# 14. Corrective Changes

If the review concludes that corrective implementation is necessary:

1. complete the entire reasonable security review,
2. report all material findings,
3. explain the evidence and impact for each,
4. explain the recommended correction direction,
5. stop,
6. wait for explicit user approval.

Only after explicit approval may implementation be handed to `dual-agent-development`. Do not implement the fix directly within this workflow, and do not invoke `dual-agent-development` automatically.

---

# 15. Final Report

The final report must be written in Korean.

Include: reviewed scope, attack surface summary, confirmed findings, confidence, severity, evidence, affected components, exploit path, impact, verification limitations, recommended remediation direction, and whether implementation is required.

After the final report, stop. Do not modify anything and do not perform further security testing unless the user explicitly approves the next action.
