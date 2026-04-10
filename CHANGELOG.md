# Changelog

## 1.0.2

- Opted SACST CI into the GitHub Actions Node.js 24 runtime before GitHub's June 2, 2026 default switch.

## 1.0.1

- Added curated vendor profile catalog and `sys-vendor-profile` for common infrastructure vendors.
- Added `sys-secret-check` for credential-reference validation without printing secret values.
- Added opt-in lab-device inspection harness for authorized real-device tests.
- Fixed raw-audit timestamp selection so `raw-audit/devices/` is not treated as a primary refresh capture.

## 1.0.0

- Replaced the mixed `framework/` plus in-repo `instances/` model with a root-canonical SACST template.
- Added external self-contained project scaffolding, adoption, sync, adapter generation, and validation flows.
- Added expanded canonical docs, schemas, platform modules, and integration tests.
- Added platform-specific normalization support for Linux server, OPNsense, and managed-switch fixture inputs.
- Added JSONL log contract validation and delayed remote management recheck controls.
- Added inventory-device refresh, per-device normalized bundles, and per-device runtime state tracking.
- Added meta-system validation and conservative self-healing commands for template and project contract drift.
- Added rollback manifest generation and rollback log references for remote non-inspect device changes.
- Added vendor research, credential-boundary, and authorized security-testing protocols with project-local scope and research controls.
- Added first-class Windows desktop/server platform families, baseline collectors, normalization, and fixture validation.
- Added generic vendor/device fallback planning and normalization for unmodeled IT systems.
- Tightened destructive-action confirmation and default-credential handling.
