# SACST Normalization Spec

Normalization converts raw audit output into stable operator-facing truth.

## Pipeline

1. Collect raw data into timestamped directories.
2. Parse platform-specific facts.
3. Emit stable Markdown summaries and machine-readable manifests.
4. Stamp provenance, freshness, and schema version.
5. Regenerate adapters that depend on normalized truth.

## Supported Platform Shapes

- `linux-desktop`: workstation and developer desktop baseline.
- `linux-server`: remote host baseline with stronger service and storage emphasis.
- `opnsense`: appliance-oriented firewall and edge-services summary from safe read-only captures.
- `switch`: generic managed-switch summary from running-state and config-summary captures.

Platform command packs may differ, but normalized output families remain stable so agents always load the same top-level context files.

## Required Output Families

- Host profile
- OS and kernel
- Hardware
- Storage
- Toolchain
- AI stack
- Network and ports
- Services
- Security posture
