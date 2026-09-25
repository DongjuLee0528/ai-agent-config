---
name: api-contract-review
description: Use for analysis-only reviews of REST, OpenAPI, DTO, client-server, WebSocket, webhook, message-schema, versioning, and compatibility contracts. Use security-review instead for authentication, authorization, vulnerabilities, or broader security analysis.
---

# API Contract Review

## Purpose

Review API and event contracts across services and clients. This workflow is analysis-only by default. It does not modify source code, configuration, schemas, API contracts, generated clients, documentation, or project files unless the user explicitly authorizes a separate implementation task.

When a correction is required: report the finding and evidence, explain the realistic impact, recommend a correction direction, stop, wait for explicit user authorization, then route authorized implementation to `dual-agent-development`.

## Activation

Use this workflow for REST APIs, OpenAPI specifications, request and response DTOs, frontend-backend integration, mobile-backend integration, service-to-service APIs, WebSocket events, webhooks, asynchronous message schemas, versioning, and compatibility reviews.

Do not use this workflow as a substitute for `security-review`. Report security issues discovered during contract review and route to `security-review` when deeper security analysis is required.

## Review Boundary

Allowed when safe and relevant: inspect source code, configuration, metadata, logs, schemas, specifications, generated clients, Git history, and existing test results; perform read-only analysis; run hardware-independent, non-destructive verification; create temporary analysis artifacts outside the repository when genuinely needed.

Do not automatically:

- modify contracts, implementations, configuration, schemas, generated clients, tests, or documentation,
- execute destructive or state-changing tests,
- call live production APIs with mutations,
- perform load, fuzz, exploit, or destructive tests,
- perform hardware operations,
- weaken tests, validation, security controls, or acceptance criteria,
- treat a review finding as authorization to implement a correction.

## Evidence States

Use these states consistently and do not report guesses as confirmed facts:

- **CONFIRMED**: directly supported by actual project evidence or reproduced behavior.
- **LIKELY**: strong evidence supports the issue, but one meaningful part remains unverified.
- **POSSIBLE**: plausible, but important evidence is missing.
- **RULED OUT**: evidence contradicts the hypothesis.
- **UNVERIFIED**: not enough evidence to assess.

Use **CRITICAL**, **HIGH**, **MEDIUM**, and **LOW** severity only when it improves prioritization. Keep severity separate from confidence.

## Review Workflow

### Contract Sources

Identify the actual sources of truth. Compare OpenAPI or other specifications with server implementation, client implementation, tests, generated clients, examples, and deployed behavior when evidence is available. Report contradictions instead of silently selecting one source.

### Request Contract

Review HTTP method and path; path, query, header, cookie, and body fields; required versus optional fields; names, types, formats, ranges, enum values, defaults, nullability, and validation; content type and encoding; coordinate, date, time, timezone, identifier, pagination, sorting, and filtering formats where applicable.

### Response Contract

Review status codes, response body schema, error response schema, empty-result behavior, pagination metadata, nullability and omitted fields, content type, ordering guarantees, identifier stability, and timestamp and timezone behavior.

### Cross-Layer Consistency

Compare backend DTOs, domain models, persistence mappings, frontend or mobile models, serialization configuration, and generated clients. Check camelCase and snake_case conversions, integer width, floating-point precision, decimal handling, enum serialization, date formats, and coordinate ordering. Identify clients that depend on undocumented behavior.

### Real-Time and Asynchronous Contracts

Review event names, payload schema, message version, ordering, duplication, idempotency, acknowledgement, retry behavior, reconnect behavior, stale-event handling, and compatibility between producers and consumers.

### Compatibility

Identify breaking and non-breaking changes. Check field removal, renaming, required-field additions, type changes, enum changes, semantic changes, and status-code changes. Review versioning and migration strategy. Do not claim backward compatibility without checking known consumers.

## Report

Include:

- contract surfaces reviewed,
- sources of truth,
- producer and consumer mappings,
- confirmed mismatches,
- severity and confidence,
- realistic failure impact,
- compatibility assessment,
- correction direction,
- unverified external behavior.
