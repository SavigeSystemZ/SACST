# SACST Read Bundles

Use the smallest useful bundle for the task.

## Template Working Bundle

- `AGENTS.md`
- `TEMPLATE_CONTEXT.md`
- `canonical/ARCHITECTURE.md`
- `canonical/RUNTIME_BOUNDARY.md`
- `canonical/TEMPLATE_MUTATION_POLICY.md`

## Project Operating Bundle

- `AGENTS.md`
- `control/PROJECT_PROFILE.yaml`
- `control/MODE_POLICY.yaml`
- `control/PERMISSIONS_POLICY.yaml`
- `control/FRESHNESS_POLICY.yaml`
- `control/RESEARCH_POLICY.yaml`
- `control/CREDENTIAL_REFERENCES.yaml`
- `control/SECURITY_SCOPE.yaml`
- `context/normalized/HOST_PROFILE.md`

## Network and Security Bundle

- `context/normalized/NETWORK_AND_PORTS.md`
- `context/normalized/SERVICES.md`
- `context/normalized/SECURITY_POSTURE.md`
- `control/SECURITY_SCOPE.yaml`
- `control/CREDENTIAL_REFERENCES.yaml`
- `runtime/RUNTIME_STATE.yaml`
- `inventory/devices.yaml`

## Vendor Research Bundle

- `control/RESEARCH_POLICY.yaml`
- `control/CREDENTIAL_REFERENCES.yaml`
- `control/SECURITY_SCOPE.yaml`
- `research/README.md`
- `research/notes/<relevant-note>.md`
- `canonical/VENDOR_RESEARCH_PROTOCOL.md` when working in SACST itself
- vendor or primary external sources cited in the project research note

## Unmodeled Vendor Bundle

- `inventory/devices.yaml`
- `control/RESEARCH_POLICY.yaml`
- `control/CREDENTIAL_REFERENCES.yaml`
- `control/SECURITY_SCOPE.yaml`
- `research/notes/PLATFORM_PLAN_<timestamp>.md`
- `research/notes/RESEARCH_<timestamp>.md`
- `context/normalized/` or `context/normalized/devices/<device-name>/` when generic normalization exists
- `platforms/generic-vendor/README.md` when working in SACST itself

## Device Bundle

- `inventory/devices.yaml`
- `context/normalized/devices/<device-name>/HOST_PROFILE.md`
- `context/normalized/devices/<device-name>/NETWORK_AND_PORTS.md`
- `context/normalized/devices/<device-name>/SECURITY_POSTURE.md`
- `runtime/devices/<device-name>/DEVICE_STATE.yaml`

## Repo Pivot Bundle

- `canonical/REPO_PRECEDENCE.md`
- target repo local instruction files
