---
name: ml-data-model-review
description: Review machine-learning datasets, training and evaluation pipelines, model conversion, and inference integration. Analysis-only by default; do not use for ordinary application bugs without ML evidence.
---

# ML Data Model Review

## Purpose

Review machine-learning datasets, training pipelines, evaluation evidence, exported models, and inference integrations. This workflow is analysis-only by default. It does not modify data, labels, model files, source code, schemas, configuration, or documentation, and it does not train, retrain, export, quantize, deploy, or replace models without explicit user authorization.

When a correction is required: report the finding and evidence, explain the realistic impact, recommend a correction direction, stop, wait for explicit user authorization, then route authorized implementation to `dual-agent-development`.

## Activation

Use this workflow for dataset quality review, label validation, split and leakage analysis, class distribution, training or validation pipeline review, metric interpretation, failure-case analysis, model comparison, preprocessing or postprocessing consistency, framework-to-ONNX or other format parity, inference integration review, and deployment-target suitability.

Do not classify ordinary application bugs as ML defects without evidence.

## Review Boundary

Allowed when safe and relevant: inspect source code, configuration, datasets, metadata, labels, logs, schemas, specifications, Git history, and existing test results; perform read-only analysis; run hardware-independent, non-destructive verification; create temporary analysis artifacts outside the repository when genuinely needed.

Do not automatically:

- modify project code, configuration, datasets, labels, schemas, API contracts, model files, or documentation,
- train or retrain models,
- convert, export, replace, quantize, deploy, or upload models,
- execute destructive or state-changing tests,
- call live production APIs with mutations,
- perform hardware operations,
- weaken tests, validation, security controls, or acceptance criteria,
- treat a review finding as authorization to implement a correction.

Expensive benchmarks, downloads, cloud jobs, and target-device execution require appropriate user authorization.

## Evidence States

Use these states consistently and do not report guesses as confirmed facts:

- **CONFIRMED**: directly supported by actual project evidence or reproduced behavior.
- **LIKELY**: strong evidence supports the issue, but one meaningful part remains unverified.
- **POSSIBLE**: plausible, but important evidence is missing.
- **RULED OUT**: evidence contradicts the hypothesis.
- **UNVERIFIED**: not enough evidence to assess.

Use **CRITICAL**, **HIGH**, **MEDIUM**, and **LOW** severity only when it improves prioritization. Keep severity separate from confidence.

## Review Workflow

### Task and Label Semantics

Confirm the actual prediction task, class definitions, and class-index mappings. Distinguish image-level, object-level, crop-level, detection, classification, segmentation, and tracking semantics. Check inconsistent or contaminated labeling rules, including missing, malformed, ambiguous, and multi-object labels.

### Dataset Integrity

Check missing files, corrupt samples, invalid annotations, impossible bounding boxes, malformed polygons, unsupported formats, exact duplicates, and near duplicates. Review whether related frames, videos, scenes, subjects, cameras, or source groups cross train, validation, or test splits, and whether splitting occurs at the correct grouping level.

### Distribution

Review class counts and imbalance. When relevant, compare source, camera, environment, lighting, location, weather, viewpoint, resolution, and temporal distribution. Identify whether metrics may be dominated by an easier source or majority class.

### Pipeline Consistency

Trace data loading, augmentation, resizing, normalization, channel order, color space, tensor layout, dtype, batching, and label conversion. Compare training, validation, export, and runtime preprocessing. Compare training and runtime postprocessing, thresholds, NMS behavior, and class mapping. Flag silent fallback labels or arbitrary values that hide failures.

### Evaluation

Use metrics that match the task. Review per-class Precision, Recall, F1, AP, mAP, confusion matrices, support counts, false positives, and false negatives as applicable. Distinguish validation results from independent test results. Inspect failure examples rather than relying only on aggregate metrics. Consider operational error costs, such as missed safety violations versus false alerts.

### Export and Runtime

Where feasible without mutation, compare original-framework and exported-model outputs using representative inputs. Check input and output names, shapes, dynamic axes, opset or format version, dtype, class order, and numerical tolerance. Review target-device latency, throughput, memory use, package compatibility, and runtime availability. Do not claim deployment suitability without target-device evidence.

## Report

Include:

- scope,
- evidence inspected,
- findings with severity and confidence when appropriate,
- affected data or pipeline stage,
- expected practical impact,
- recommended correction direction,
- verification gaps,
- final assessment.
