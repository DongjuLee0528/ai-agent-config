---
name: hardware-debugging
description: Use to diagnose observed hardware-connected embedded, robotics, IoT, sensor, actuator, electrical, communication, or mechanical failures. Analysis-only by default; use hardware-control-review instead for pre-execution control-code or safety review, and embedded-security-review for security.
---

# Hardware Debugging

## Purpose

Diagnose problems in systems connected to physical hardware: embedded systems, robotics, IoT devices, MCUs, SBCs, sensors, actuators, motors, servos, communication buses, electrical circuits, and mechanical assemblies.

This workflow is diagnosis-first and analysis-only by default. It does not modify source code, firmware, configuration, or project files, and it does not move or actuate physical hardware, unless the user explicitly approves the specific action.

---

# 1. Activation

Use this workflow when the user describes a hardware-connected symptom, for example:

- a device not responding, not powering on, or behaving unexpectedly,
- a sensor reading incorrect or missing values,
- a motor or servo not moving, moving incorrectly, or moving unexpectedly,
- a communication bus failing, timing out, or returning garbage,
- unexpected resets, overheating, or instability,
- a system that used to work and no longer does.

The initial symptom description comes from the user. Use it as the starting point, not as a confirmed root cause.

If the user explicitly requests implementation, code modification, or firmware upload without asking for diagnosis, follow the user's request and use `dual-agent-development` instead, subject to the approval gates in Section 5.

---

# 2. Read-Only by Default

During diagnosis:

- Do not modify source code, configuration, firmware, or project files.
- Do not automatically invoke `dual-agent-development`.
- Do not run commands that can change the physical state of connected hardware.
- Do not automatically retry a physical hardware test.

Automatically allowed, when they do not touch connected hardware:

- reading source code, configuration, and logs,
- `git status`, `git diff`, and other read-only Git inspection,
- static analysis, linting, type checking,
- compilation and build,
- non-hardware unit tests,
- other non-destructive software verification.

Compilation or non-hardware validation may happen automatically when it is safe and does not affect connected hardware. Firmware upload is not compilation and always requires explicit approval (Section 5).

If the user asks only for diagnosis or analysis, remain read-only for the entire session.

---

# 3. Baseline: Expected vs. Observed

Before analyzing causes, establish:

- **Expected behavior** — what the system is supposed to do, per the user's description, documentation, or datasheet.
- **Observed behavior** — what the user actually reports seeing, including error messages, readings, timing, and conditions.

Keep these two explicitly separate throughout the diagnosis. Do not blend them into a single narrative.

When relevant, determine:

- when the system last worked correctly,
- what changed afterward,
- software changes,
- firmware changes,
- wiring changes,
- power changes,
- hardware replacement,
- mechanical changes,
- configuration changes.

Ask the user for this information when it is not already known; do not assume a cause of change without evidence.

---

# 4. Diagnostic Domains

Diagnose across the domains relevant to the symptom. Not every domain applies to every symptom — scope to what is plausible, but do not stop after the first plausible domain if others remain relevant (Section 8).

## Software

- call flow, state machines, timing, concurrency,
- drivers, initialization order, configuration,
- protocol handling, input ranges, resource conflicts.

## Electrical

- supply voltage, voltage drop under load, current requirements, power capacity,
- common ground, logic levels, pull-up/pull-down requirements,
- polarity, connector orientation, signal integrity,
- power stability, overheating, protection circuits.

## Communication

- UART, I2C, SPI, CAN, USB, Ethernet,
- baud rate, addresses, bus conflicts, framing,
- initialization order, timeout behavior, protocol mismatches.

## Hardware

- MCU, SBC, sensors, actuators, motors, servos, motor drivers,
- power modules, interface boards, cables, connectors,
- defective components.

## Mechanical

- load, alignment, interference, range of motion, assembly,
- backlash, physical obstruction, mounting, center of gravity, actuator limits.

---

# 5. Physical Safety and Approval Gates

Physical safety is mandatory. Never recommend bypassing protection systems or exceeding manufacturer ratings.

## Requires explicit user approval before execution

Any action that may:

- move motors or servos, drive actuators,
- toggle GPIO outputs, generate PWM, activate relays,
- change power states, perform load testing, reboot connected equipment,
- flash or upload firmware,
- issue device commands that change device state,
- trigger mechanical movement, change electrical output,
- alter persistent hardware configuration.

When uncertain whether a command can affect physical hardware, treat it as potentially state-changing and require approval. Firmware upload always requires approval even when compilation was already performed automatically.

## Before proposing a physical hardware test, provide

- purpose,
- exact procedure,
- expected result,
- what each possible result means,
- risks,
- stop conditions.

Stop conditions should include, when relevant: unexpected motion, overheating, smoke, unusual smell, abnormal current, out-of-range voltage, mechanical collision, battery abnormality, unstable power, unsafe device behavior.

## Retesting

Hardware retesting must not happen automatically. Present the retest plan first and wait for user approval, even if a prior identical test was already approved once.

---

# 6. Evidence Discipline

Prefer, in this order: official datasheets and manufacturer documentation, actual source code, logs, measurements, and reproducible observations, over assumptions.

- Never present an unmeasured value as measured.
- Never present a hypothesis as confirmed fact.
- Separate **Observation**, **Interpretation**, **Evidence**, and **Hypothesis** at each step.

Use these evidence states for every hypothesis:

- **CONFIRMED** — verified by direct measurement, log, or reproducible test.
- **LIKELY** — strongly supported by evidence but not directly confirmed.
- **POSSIBLE** — consistent with symptoms but not yet supported by specific evidence.
- **RULED OUT** — contradicted by evidence.
- **UNVERIFIED** — relevant but not yet checked.

Do not assume:

- software tests passing means the hardware is healthy,
- hardware failure means the hardware component is defective (it may be wiring, power, configuration, or a peer component).

---

# 7. Diagnostic Reasoning Cycle

For each hypothesis:

Observation → Hypothesis → Test → Evidence → Elimination or Strengthening → Root Cause assessment.

- Prefer isolation tests: isolate layers, bypass higher-level components when safe, narrow the problem boundary step by step.
- Prefer known-good swap tests when safe and practical.
- Change only one diagnostic variable at a time whenever possible.
- Track reproducibility when relevant: occurrence frequency, repeated behavior, intermittent behavior.
- Use timestamps and event ordering when timing may be relevant.

Any test step that only reads state through an external instrument (for example, measuring voltage with a meter) or reads already-captured data (a log, a file) may be proposed and, once approved, walked through without a separate approval per reading.

Register, bus, port, and device access is not automatically safe merely because the intended operation is a read. This includes register reads, status reads, serial port access, I2C access, SPI access, CAN access, USB device access, device probing, port opening, and driver or interface initialization: some devices have read-to-clear registers, status flags cleared by reads, mode transitions triggered by access, write-before-read transactions, port initialization side effects, or a reset or state change on open or probe. Treat such an access as non-state-changing only when reliable device documentation or known device behavior confirms it does not change device state; otherwise treat it as potentially state-changing and require explicit user approval under Section 5.

Any test step that changes physical state, or whose effect on device state cannot be confirmed as above, falls under Section 5 and needs its own approval.

---

# 8. Diagnostic Depth

Do not stop after finding the first plausible problem. Continue through the reasonable diagnostic scope and evaluate other relevant hypotheses across the applicable domains (Section 4) before concluding.

At the end, distinguish:

- **Root Cause** — the confirmed or most strongly supported explanation.
- **Contributing Factors** — conditions that worsen or enable the symptom without being the primary cause.
- **Unverified Factors** — plausible causes that remain UNVERIFIED because a test was not possible or not yet approved.

---

# 9. When Code Modification Appears Necessary

If analysis concludes that source code, configuration, firmware, or a script must change:

1. report the finding,
2. explain the evidence supporting it,
3. explain the recommended correction direction (not a full implementation),
4. stop,
5. wait for explicit user approval.

Only after explicit approval may implementation be handed to `dual-agent-development`. Do not invoke it automatically, and do not implement the fix directly within this workflow.

---

# 10. Final Report

The final diagnostic report must be written in Korean.

Include:

- symptom summary,
- expected behavior,
- observed behavior,
- evidence collected,
- hypotheses considered,
- hypothesis status (using the evidence states in Section 6),
- ruled-out causes,
- likely or confirmed root cause,
- contributing factors,
- verification gaps,
- recommended next diagnostic step, if needed,
- recommended correction direction, if applicable,
- whether code modification appears necessary.

After the final diagnostic report, stop. Do not modify anything and do not run further hardware tests unless the user explicitly approves the next action.