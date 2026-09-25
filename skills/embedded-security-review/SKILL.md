---
name: embedded-security-review
description: Use for analysis-only security reviews of embedded systems, IoT, robotics, MCU/SBC firmware, device communications, and cyber-physical control paths. Use security-review instead for web/API/backend-only security, or hardware-debugging for non-security device failures.
---

# Embedded Security Review

## Purpose

Perform strict, evidence-based security review for embedded systems, IoT devices, robotics systems, MCU/SBC platforms, firmware, device communication, physical interfaces, device identity, update mechanisms, and cyber-physical control paths.

This workflow is analysis-only by default. It never automatically fixes a vulnerability, never automatically actuates or reconfigures hardware, and never automatically invokes `dual-agent-development`. Permission to review security is not permission to exploit, modify, attack, or remediate.

This workflow inherits the physical-safety approval gates of `hardware-debugging` for any action that may change device or physical state. It does not weaken or replace them.

---

# 1. Activation

Use this workflow when the user requests a security review, threat assessment, or vulnerability analysis of a device, firmware, embedded control system, or cyber-physical product.

For a functional or diagnostic problem with no security question ("why doesn't the servo move"), use `hardware-debugging` instead. For a review of a purely web/API/backend surface with no embedded or device component, use `security-review` instead. A system with both a device and a backend/app may need both skills; run each within its own scope.

If the user explicitly requests implementation, firmware modification, or a fix without asking for review, follow the user's request and use `dual-agent-development` instead, subject to the approval gates in Section 15. Firmware flashing and device actuation always require explicit approval regardless of which workflow is active.

---

# 2. Review Boundary

Analysis only by default. Do not:

- modify firmware, source code, or configuration,
- flash firmware,
- reset or reboot devices,
- probe hardware interfaces,
- actuate hardware,
- send attack packets or malformed messages to a live device,
- fuzz live devices,
- alter boot configuration or persistent device configuration,
- rotate or revoke credentials,
- upgrade, downgrade, or otherwise change dependency versions,
- modify `.gitignore`,
- rewrite Git history,
- remove a tracked file,
- delete a secret as a form of remediation,
- automatically invoke `dual-agent-development`.

If an embedded credential or secret (device key, factory password, signing key, backend API token, Wi-Fi/BLE provisioning secret, or similar) appears committed, pushed, distributed in a firmware image, or otherwise exposed: report it clearly, state that deleting the source file or adding it to `.gitignore` alone may not be sufficient to remove it from Git history or from already-distributed firmware, recommend rotation/revocation where appropriate, identify Git/publication risk when relevant, and follow AGENTS.md Git publication safety rules (Section 12). Do not perform any of this remediation automatically.

---

# 3. Reference Standards

Use, when relevant: OWASP IoT Security Verification Standard (ISVS), NISTIR 8259A IoT Device Cybersecurity Capability Core Baseline, manufacturer documentation, official datasheets, chip/vendor security documentation, and the actual firmware, source, configuration, and device architecture.

Do not require an unavailable hardware security feature (secure boot, hardware root of trust) as a universal defect without considering the platform's actual capability and the relevant threat model.

OWASP ISVS has, at points in its history, been published as a release candidate or draft rather than a finalized stable standard. Before citing it as an audit reference, verify its current version and publication status. Distinguish release-candidate/draft guidance from a finalized stable standard in the finding text when the distinction materially affects the finding's weight, and do not hard-code a specific ISVS version in a finding unless that version was actually verified at review time.

---

# 4. System and Threat Model

Identify relevant components: MCU, SBC, bootloader, firmware, OS, storage, sensors, actuators, motor controllers, debug interfaces, communication buses, wireless interfaces, network services, backend APIs, cloud services, and mobile/web control applications.

Identify realistic attackers for the system under review: remote network attacker, local network attacker, authenticated low-privilege user, malicious peer device, physical attacker, maintenance technician, compromised backend, supply-chain attacker. Do not assume every threat model applies equally to every finding — state which attacker(s) a given finding requires.

---

# 5. Cyber-Physical Attack Path

When applicable, explicitly trace: cyber input → software command → authorization decision → device command → hardware state change → physical consequence.

Review whether a security weakness can produce: unsafe motor movement, servo overtravel, actuator activation, relay activation, unsafe power-state change, disabling safety mechanisms, false sensor input, navigation manipulation, physical damage, or unsafe robot behavior. Physical consequences must influence severity (Section 12).

---

# 6. Review Domains

Review the domains relevant to the system under review. Not every domain applies to every device — scope to what is plausible, but do not stop after the first plausible domain if others remain relevant (Section 13).

## Device Identity and Authentication

Unique device identity, unique device credentials, shared factory passwords, default credentials, hard-coded tokens, certificate provisioning, device impersonation, backend-to-device authentication, device-to-backend authentication.

## Firmware Security

Embedded secrets, debug code, test backdoors, unsafe parsers, memory corruption, buffer overflow, integer overflow, use-after-free, unsafe string/memory operations, input length validation, privileged command handlers.

## Secure Boot and Firmware Integrity

Secure boot, signature verification, chain of trust, bootloader integrity, firmware integrity verification, unauthorized firmware execution — where supported by the hardware.

## Firmware Update Security

Signed updates, authenticated update source, integrity verification, rollback/downgrade protection, update authorization, recovery paths, interrupted-update handling, OTA security, local update security, USB/SD update paths.

## Debug and Maintenance Interfaces

JTAG, SWD, UART console, serial console, bootloader shell, recovery shell, debug USB, engineering/test modes. Review whether production systems expose unnecessary privileged interfaces.

## Storage Security

Flash, EEPROM, SD cards, eMMC, NVMe, removable media, filesystem permissions, plaintext credentials, tokens, private keys, logs, cached data, and model files where security-sensitive.

## Communication Security

UART, I2C, SPI, CAN, USB, Ethernet, Wi-Fi, BLE, MQTT, HTTP, WebSocket, and custom protocols. Evaluate authentication, integrity, confidentiality, replay protection, spoofing, command injection, malformed-message handling, message authorization, protocol downgrade, and device impersonation. Do not assume an internal bus is trusted merely because it is physically internal.

## Replay and Command Authenticity

Whether a captured legitimate command can be replayed. Review nonces, counters, timestamps, sequence numbers, MAC/signatures, and command authorization.

## Privilege and OS Security

For Linux/SBC systems: root processes, unnecessary privileges, Linux capabilities, service permissions, device-node permissions, unnecessary daemons, SSH configuration, sudo permissions, file permissions, container privileges.

## Hardware Root of Trust

Secure elements, TPM, TrustZone, hardware-backed keys, OTP/eFuse protections, protected key storage — when the hardware supports them.

## Physical Access Threats

Removable storage, exposed UART/JTAG/SWD, boot source manipulation, firmware extraction, credential extraction, removable media replacement, debug pads, accessible reset/boot pins.

## Sensor and Actuator Trust

Forged sensor readings, spoofed sensor data, invalid-range handling, actuator command validation, movement limits, command authorization, fail-safe behavior, safety interlocks.

## Device Recovery and Failure Modes

Fail-open behavior, fail-safe behavior, watchdog behavior, recovery mode, boot loops, authentication failure handling, update failure handling, corrupted configuration handling.

## Device Cybersecurity State Awareness

Whether an authorized operator or backend system can determine the device's current security state. Review, when relevant: security-relevant event generation, security logging, device security-state reporting, authentication failures, authorization failures, firmware update failures, secure-boot/integrity failures, configuration changes, credential changes, debug-interface access, recovery-mode entry, repeated failed access attempts, abnormal network or device behavior, tamper-relevant events, security-relevant telemetry, auditability, and event retention where relevant.

Do not require every device to implement enterprise-style logging. Evaluate the device's actual capability relative to its hardware limitations, device role, threat model, storage/network constraints, and operational requirements. Use NISTIR 8259A as an authoritative reference when relevant.

## Supply Chain

Third-party firmware, vendor SDKs, unsigned binaries, downloaded artifacts, package sources, toolchains, build dependencies, board support packages — when evidence exists.

---

# 7. Safety-Security Boundary

Distinguish a security defect from a safety consequence, and explicitly connect them when one can cause the other (Section 5). Do not report a mechanical or electrical fault as a security vulnerability unless there is a realistic security-triggered path to it; a purely mechanical problem with no attacker-controllable trigger belongs to `hardware-debugging`, not this review.

---

# 8. Security Testing Safety

Automatically allowed only when clearly non-state-changing: source inspection, configuration inspection, firmware source analysis, offline binary metadata analysis, dependency inspection, build, compilation, hardware-independent tests.

A command's name — "build", "test", "verify", "check" — is not proof that it is non-destructive, particularly for embedded and firmware tooling. Before automatically running a build, test, package script, or task runner (Gradle/Maven/npm/Make/CMake/PlatformIO/firmware build tasks or similar), inspect it when reasonably possible for side effects such as post-build upload, firmware flashing, device reset, hardware probing, live service calls, integration-environment mutation, destructive cleanup, credential use, network fuzzing, or physical device interaction. If side effects cannot be confidently ruled out, treat the command as potentially state-changing, explain the uncertainty, and require explicit user approval before execution. The hardware safety rules inherited from `hardware-debugging` (Section 5, Physical Safety and Approval Gates) apply in full to any such side effect.

Explicit user approval required before: JTAG/SWD probing, UART/serial probing, I2C/SPI/CAN probing, USB device probing, firmware dumping from a live device, firmware flashing, bootloader interaction, malformed packet injection, CAN injection, network fuzzing, BLE attack testing, Wi-Fi attack testing, brute force, credential attacks, device reboot, persistent configuration modification, actuator commands, motor/servo commands, GPIO changes, relay activation, and DoS/load testing.

If there is uncertainty whether an action can change device or physical state, treat it as potentially state-changing and require explicit approval, per the same principle used in `hardware-debugging`.

Approval for an active security test authorizes only that specific, approved execution. Prior approval does not authorize retries, repeated exploitation, repeated brute force, repeated credential attacks, repeated fuzzing, repeated injection attempts, or another materially equivalent active or device-interaction test. Do not automatically repeat a physical or device-interaction security test. Before repeating one, present the retest purpose, why repetition is necessary, the exact test, expected impact and risk, and stop conditions when relevant, and wait for user approval again — even if a prior identical test was already approved once.

---

# 9. Evidence Discipline

Prefer, in order: official datasheets and manufacturer/vendor security documentation, actual firmware and source code, actual device configuration, reproducible measurements and captures, over assumptions.

Separate observation, inference, and confirmed evidence at each step. Do not fabricate vulnerabilities. Do not assume exploitability without a realistic attacker-to-impact path. Do not confuse insecure-looking code with confirmed exploitability. Never present an unverified claim as confirmed.

---

# 10. Confidence Levels

Confidence describes how strongly the evidence supports a finding. It is assessed independently of severity (Section 12) — a finding can be **CRITICAL** in severity while its confidence is only **POSSIBLE**, and that combination must never be silently rounded up to CONFIRMED, or dropped, or treated as equivalent to `Severity: CRITICAL / Confidence: CONFIRMED`.

**CONFIRMED**
- The security condition is directly supported by strong evidence from the actual firmware, source, configuration, or device: a verified reachable code or configuration path, reproducible behavior, a confirmed vulnerable dependency/component version, or a directly observable security-control failure.
- Active exploitation or live-device interaction is not required to reach CONFIRMED when firmware/source/configuration evidence is already sufficient on its own.
- Do not use CONFIRMED merely because a dangerous API, pattern, or keyword is present.

**LIKELY**
- Strong evidence supports the issue, but one meaningful element cannot currently be directly verified (for example, live-device confirmation was not performed or approved).
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

# 11. Finding Standard

Every finding must include: severity, confidence, component, attack prerequisite, attack surface, attack path, evidence, security impact, physical impact if applicable, and recommended correction direction.

Use the confidence levels defined in Section 10: **CONFIRMED**, **LIKELY**, **POSSIBLE**, **UNVERIFIED**.

---

# 12. Severity

Use **CRITICAL**, **HIGH**, **MEDIUM**, **LOW**, considering exploitability, privilege required, user interaction, data sensitivity, blast radius, integrity impact, availability impact, persistence, and physical consequences (Section 5). A finding with a confirmed path to unsafe physical motion or device damage should weigh physical consequence at least as heavily as data impact. Do not inflate or deflate severity to make a finding appear more or less important.

Severity and confidence (Section 10) are independent axes. Set each based on its own criteria; a high severity does not justify raising confidence, and a low confidence does not justify lowering severity.

---

# 13. Full Review Requirement

Do not stop after the first finding. Review all reasonable relevant security domains (Section 6) before concluding. Consolidate findings that share the same root cause; preserve distinct impacts where useful.

---

# 14. Verdict

Return exactly one:

- **PASS** — no material issue found and meaningful verification completed.
- **PASS WITH RISKS** — no confirmed blocking issue, but meaningful areas remain unverified (for example, hardware or a live device was unavailable for confirmation).
- **FAIL** — one or more confirmed material security defects require correction.

A FAIL verdict does not authorize automatic corrective modification.

---

# 15. Handoff

If the review concludes that corrective implementation is necessary:

1. complete the entire reasonable security review,
2. report all material findings,
3. explain the evidence and impact for each,
4. explain the recommended correction direction,
5. stop,
6. wait for explicit user approval.

Only after explicit approval may corrective implementation be handed to `dual-agent-development`. Do not implement the fix directly within this workflow, and do not invoke `dual-agent-development` automatically.

---

# 16. Final Report

The final report must be written in Korean.

Include: reviewed device/system scope, threat model, attack surfaces, findings, severity, confidence, evidence, cyber-physical consequences, verification gaps, recommended remediation direction, and whether code/firmware/configuration modification is required.

After the final report, stop. Do not modify anything and do not perform further security testing or device interaction unless the user explicitly approves the next action.
