---
name: hardware-control-review
description: Use for analysis-only review of hardware-control code, configuration, mappings, and physical-safety implications before physical execution. Use hardware-debugging instead to diagnose observed device, electrical, communication, or mechanical failures.
---

# Hardware Control Review

## Purpose

Review software that controls or directly interacts with physical hardware: robotics, embedded systems, MCU/SBC projects, motors, servos, actuators, sensors, GPIO, PWM, relays, motor drivers, servo controllers, I2C, SPI, UART, CAN, USB/device interfaces, hardware abstraction layers, control loops, state machines, kinematics and inverse kinematics, and hardware configuration and mapping.

This workflow is strict, evidence-based, and analysis-only by default. It does not modify source code, firmware, configuration, scripts, tests, wiring documentation, or project files as a consequence of findings. It does not automatically invoke `dual-agent-development`. It does not actuate or reconfigure hardware.

---

# 1. Activation

Use this workflow when the user requests a review of hardware-control software, configuration, or mappings to assess correctness and physical-safety risks — before physical execution or independently of it.

Primary activation trigger: "Review this hardware-control implementation for correctness and physical-safety risks."

Do not activate this workflow when:

- the primary task is diagnosing an already-observed hardware malfunction — use `hardware-debugging` instead,
- the primary task is implementation, modification, bug fixing, or refactoring — use `dual-agent-development` instead,
- the primary task is application, web, API, or backend security analysis — use `security-review` instead,
- the primary task is embedded or device cybersecurity analysis — use `embedded-security-review` instead.

If the user explicitly requests implementation or a fix without asking for review, follow the user's request and use `dual-agent-development` instead, subject to the approval gates in Section 4.

---

# 2. Analysis-Only Boundary

Analysis only by default. Do not:

- modify source code, firmware, configuration, scripts, tests, wiring documentation, or project files,
- automatically invoke `dual-agent-development`,
- run commands that can change the physical or device state of connected hardware,
- automatically retry a physical hardware test,
- apply, stage, commit, or push any changes.

Follow AGENTS.md Git safety rules (Section 13) in full.

---

# 3. Role Boundaries

Use the primary objective to select the correct skill, not the surface affected.

| Skill | Primary task |
|-------|-------------|
| `hardware-control-review` | Review hardware-control software, configuration, mappings, or physical-safety implications — before or independently of physical execution |
| `dual-agent-development` | Implement, modify, bug-fix, or refactor code or project files |
| `hardware-debugging` | Diagnose a hardware-connected problem already manifesting as an observed malfunction |
| `security-review` | Analyze application, web, API, or backend security |
| `embedded-security-review` | Analyze embedded or device cybersecurity |

A review may identify a suspected cause of an already-observed malfunction. If the task becomes active diagnosis or reproduction of the malfunction, follow `hardware-debugging` instead of silently expanding scope.

If an issue concerns attacker-controlled input, authentication, authorization, firmware trust, secure boot, debug-interface attack exposure, network attack paths, or cyber-physical exploitation, report that `embedded-security-review` or `security-review` should be used. Do not automatically invoke either.

---

# 4. Hardware Safety and Approval Gates

Physical safety is mandatory. Never recommend bypassing protection systems or exceeding manufacturer ratings.

This review does not imply permission to physically test hardware.

## Automatically allowed when they do not interact with connected hardware

- reading source code, configuration, and documentation,
- reading already-captured logs,
- `git status`, `git diff`, and other read-only Git inspection,
- static analysis, linting, and type checking,
- compilation and build operations whose scripts, tasks, and hooks have been inspected sufficiently to establish that they do not upload firmware, initialize hardware, contact devices, mutate external state, or trigger hardware interaction,
- hardware-independent unit tests,
- other clearly non-destructive software verification.

A command's name — "build", "test", "check", "verify", "compile" — is not proof that it is non-state-changing. Inspect relevant scripts, tasks, and hooks first when necessary. Do not trust a command merely because of its name.

## Requires explicit user approval before execution

Any operation that may:

- move motors, servos, or other actuators,
- toggle GPIO outputs, generate PWM, or activate relays,
- upload or flash firmware,
- reset or reboot a connected device,
- probe hardware interfaces (I2C, SPI, UART, CAN, USB, serial),
- initialize drivers or interfaces when side effects are uncertain,
- perform load testing,
- alter persistent hardware configuration or calibration,
- write calibration data,
- change device configuration.

Register reads, status reads, bus access, serial or device port opening, probing, and interface initialization must not be assumed safe merely because the intent is read-only. They may only be treated as non-state-changing when reliable device documentation or known device behavior confirms that the specific operation does not change device state. If uncertain, treat as potentially state-changing and require explicit approval.

## Before proposing any physical or device-state-changing test

Provide:

1. what will be tested,
2. why it is necessary,
3. expected physical and device effects,
4. stop conditions when relevant.

Then obtain explicit user approval. A previous approval does not automatically authorize a later physical retest. Each retest requires its own approval following the same steps.

---

# 5. Evidence Discipline

Use an evidence-based workflow. Do not invent physical wiring, electrical configuration, or device behavior.

Potential evidence includes: direct user measurement or observation, actual wiring or pin map, schematic, project configuration, source code, datasheet or manufacturer documentation, logs, runtime traces, tests, and README or design documentation.

Distinguish observed physical reality from intended configuration. Compare independent evidence sources. Report contradictions explicitly.

Do not define a universal precedence where one evidence type always overrides another:

- For claims about actual runtime behavior, prefer current direct and reproducible evidence.
- For device specifications, use official hardware documentation.
- For software behavior, use actual current source and configuration.
- Do not let stale documentation silently override a current implementation.

If actual wiring or hardware configuration is unavailable, mark the physical mapping as UNVERIFIED rather than assuming the source configuration is correct. State exactly what evidence is missing.

---

# 6. Confidence Levels

Confidence describes how strongly the evidence supports a finding. Confidence and severity (Section 8) are independent axes. A potentially catastrophic physical consequence with weak evidence may be high severity but low confidence. Do not inflate severity merely because hardware is involved, and do not inflate confidence to make a finding appear more actionable.

**CONFIRMED**
The condition is directly supported by sufficient evidence: actual source or configuration proof, reliable measurement, log evidence, reproducible observation, or authoritative hardware documentation appropriate to the claim. Do not use CONFIRMED merely because a dangerous API, pattern, or value is present.

**LIKELY**
Strong evidence supports the issue, but one meaningful element cannot currently be directly verified. The failure path is realistic and mostly established. State exactly what remains unverified.

**POSSIBLE**
A plausible concern with a realistic failure path, but important evidence is missing. Do not describe a POSSIBLE finding as a confirmed or established defect.

**RULED OUT**
Contradicted by evidence.

**UNVERIFIED**
The available evidence is insufficient to determine whether the issue exists. State exactly what information or verification would be required to raise confidence.

---

# 7. Review Areas

Review the areas relevant to the target system. Not every area applies to every project — scope to what is plausible, but do not stop after the first issue if others remain relevant (Section 9).

## 7.1 Hardware Mapping and Connectivity

Review consistency between software and available hardware evidence, including when applicable: GPIO pin assignments, PWM channels, I2C addresses, SPI buses and chip selects, UART device paths and baud rates, CAN interfaces and identifiers, USB and device paths, PCA9685 or equivalent controller addresses and channels, motor-driver channels, servo channels, sensor channels, actuator mappings, and logical device names versus physical devices.

Detect mismatches between source code, configuration, wiring or pin maps, schematics, and hardware documentation.

Do not invent physical wiring. If actual wiring or hardware configuration is unavailable, mark the physical mapping as UNVERIFIED rather than assuming the source configuration is correct.

## 7.2 Electrical Assumptions Visible from Software or Configuration

Review only what available evidence supports, such as: 3.3 V versus 5 V logic assumptions, active-high or active-low behavior, pull-up and pull-down assumptions, output and input mode, power-enable logic, inversion, and interface voltage assumptions.

Do not pretend to perform an electrical inspection from source code alone. Missing physical or electrical evidence must be explicitly reported as UNVERIFIED when relevant.

## 7.3 Actuator Command Safety

Review: servo angle limits, motor speed limits, torque and current-related limits when represented in software, PWM bounds, direction handling, command clamping and saturation, calibration, offsets, inversion, gear ratio, unit conversion, startup and shutdown commands, safe or default position, and invalid command handling.

Treat calibration offsets, scaling factors, and tuning parameters as legitimate mechanisms, not unnecessary complexity. Review whether they are bounded, applied correctly, and cannot produce an out-of-range hardware command.

Trace values to the final hardware command whenever reasonably possible. For example:

StateMachine → gait or controller → kinematics or IK → calibration or offset → hardware driver → PWM or servo or motor command.

Do not stop at an intermediate layer if the final hardware output can reasonably be traced.

## 7.4 Kinematics and Mechanical Constraints

When relevant, review: coordinate frames, axis direction, degrees versus radians, mm/cm/m conversions, joint limits, unreachable IK targets, NaN and Inf handling, singularities when relevant, overextension risk, joint collision risk, body and leg geometry assumptions, calibration offsets, and command discontinuities.

Do not claim a mechanical failure is confirmed without adequate evidence.

## 7.5 Sensor Input Safety

Review: invalid values, stale data, NaN and Inf, out-of-range values, missing sensor data, timeout behavior, disconnect behavior, partial reads, initialization failures, fallback behavior, and whether unsafe actuator commands can result from bad sensor input.

## 7.6 Communication Failure Behavior

Review relevant I2C, SPI, UART, CAN, USB, Ethernet, serial, or other device communication behavior for: timeout, retry, reconnect, duplicate commands, stale commands, partial and malformed messages, dropped communication, bus and device errors, retry storms, repeated physical actions caused by retry logic, and unsafe recovery behavior.

## 7.7 State-Machine and Control-Flow Safety

Review: legal and illegal transitions, bypassed safety states, START/STAND/WALK/RUN/STOP/ERROR/ESTOP or equivalent transitions, commands issued during transitions, error-state and recovery-state behavior, command ordering, duplicate transitions, stale state, and unexpected fallthrough.

## 7.8 Fail-Safe Behavior

Review what happens when: an exception occurs, a process crashes, communication is lost, a sensor fails, an actuator command fails, initialization fails, the control loop stops, the application exits, or the device disconnects.

Check whether the software can leave an actuator at the last dangerous command or otherwise fail in an unsafe state.

Do not require a specific fail-safe architecture when the project context does not justify it. Evaluate the actual system.

## 7.9 Timing, Concurrency, and Control Loops

Review when applicable: control-loop frequency, blocking operations, sleeps and delays, race conditions, shared state, duplicate actuator commands, asynchronous command ordering, thread and process interactions, stale commands, timing assumptions, watchdog behavior, and queue buildup.

## 7.10 Startup and Shutdown Safety

Review: initialization ordering, output defaults, actuator enable ordering, sensor readiness before control, startup movement, shutdown sequence, cleanup behavior, emergency shutdown path, and whether initialization itself can trigger physical output.

## 7.11 Configuration Consistency

Review consistency across: source constants, environment and config files, hardware maps, calibration files, device addresses, channel assignments, limits, offsets, and runtime configuration. Report contradictory configuration rather than silently choosing one source.

---

# 8. Finding Standard

Each meaningful finding must include:

- **Severity** — CRITICAL, HIGH, MEDIUM, or LOW
- **Confidence** — CONFIRMED, LIKELY, POSSIBLE, or UNVERIFIED (Section 6)
- **File and location**
- **Observation** — what the code, configuration, or mapping shows
- **Evidence** — the specific source or data supporting the finding
- **Why it matters** — the significance
- **Software consequence**
- **Hardware or physical consequence**, when applicable
- **Trigger or prerequisite** — the condition or input that activates the failure path
- **Recommended correction direction**
- **Verification needed**, when applicable

Clearly distinguish: confirmed defect, likely defect, possible risk, missing evidence, and intentionally accepted behavior.

## Severity

Use severity appropriate to the realistic reachable consequence. Do not inflate severity merely because hardware is involved.

**CRITICAL** — can reasonably cause hardware damage, severe unsafe physical movement, serious injury risk, or catastrophic uncontrolled system behavior.

**HIGH** — can reasonably cause unsafe movement, significant physical limit violation, serious loss of control, or major functional failure with direct hardware consequence.

**MEDIUM** — limited functional defect, incorrect edge-case hardware behavior, or incomplete error handling with a realistic hardware consequence.

**LOW** — minor robustness problem or small but real maintainability concern affecting hardware-control code.

Severity and confidence are independent axes. A CRITICAL finding may have POSSIBLE confidence. Do not adjust either to match the other.

---

# 9. Full Review Requirement

Do not stop after finding the first issue. Review the complete reasonable requested scope before concluding.

When an issue is discovered:
1. record the finding,
2. continue reviewing,
3. inspect the remaining scope,
4. collect all material findings.

Group findings that share the same root cause instead of reporting the same defect multiple times. Preserve distinct impacts where useful.

Prioritize issues that can: damage hardware, create unsafe movement, violate physical limits, create uncontrolled or repeated actuator commands, cause dangerous startup or shutdown behavior, hide or amplify hardware failures, or produce incorrect control output.

Also report ordinary software correctness issues when they materially affect hardware behavior.

---

# 10. Verdict

Return exactly one verdict after completing the review.

**PASS** — no material defect was discovered, required verification was completed, and no important verification gap remains.

**PASS WITH RISKS** — no confirmed blocking defect, but meaningful verification could not be completed or unresolved risk remains (for example, physical hardware or wiring documentation was unavailable for confirmation).

**FAIL** — one or more confirmed material defects require correction.

A FAIL verdict does not authorize the reviewer to modify the implementation or automatically start a correction cycle.

---

# 11. Corrective Changes

If the review concludes that a correction is required:

1. report the finding,
2. show the evidence,
3. explain the expected software, hardware, and physical impact,
4. recommend a correction direction,
5. stop,
6. wait for explicit user approval.

Only after explicit user approval may implementation be delegated to `dual-agent-development`. Do not implement the correction directly within this workflow. Do not automatically invoke `dual-agent-development`. Do not create an automatic reviewer-to-fixer-to-reviewer loop.

Cross-agent execution must remain bounded to one implementation phase and one independent review phase, as defined by the existing `dual-agent-development` workflow rules.

---

# 12. Final Report

The final report must be written in Korean.

Include:

- reviewed scope and hardware targets,
- evidence collected and evidence gaps,
- confidence levels for each finding and what remained UNVERIFIED,
- findings grouped by severity,
- hardware and physical consequences,
- verification limitations and remaining risks,
- recommended correction direction for each material finding,
- verdict.

After the final report, stop. Do not modify anything and do not perform further hardware tests or commands unless the user explicitly approves the next action.
