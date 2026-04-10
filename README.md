# SACST

SACST is the reusable template source and meta-system for AI-assisted systems administration, network administration, and authorized defensive security operations.

It is not a live instance repository. SACST stores canonical policy, schemas, templates, platform modules, adapter generation inputs, tests, and synthetic fixtures. Live project copies are scaffolded outside this repo, typically under `$HOME/.MyAdminZ/<InstanceName>/`.

## Core Model

- Repo root is the canonical template and meta-system.
- Project copies are self-contained operational repos.
- Live runtime state does not belong in SACST.
- Linux, Windows, OPNsense, switch, router, and vendor-appliance support is modular and project-owned where target-specific facts are involved.
- Target-repo local instructions always outrank host-side SACST guidance when an agent pivots into another repository.

## Primary Commands

- `bin/sys-init <InstanceName>`: scaffold a project repo outside SACST.
- `bin/sys-init <InstanceName> --adopt-existing`: adopt an existing legacy project repo in place.
- `bin/sys-init <InstanceName> --create-remote`: also create or attach the GitHub remote for the project repo.
- `bin/sys-refresh <project-path>`: collect local audit data, normalize context, and regenerate adapters.
- `bin/sys-refresh <project-path> --source <raw-audit-dir>`: normalize fixture or externally captured platform audit data.
- `bin/sys-refresh <project-path> --device <device-name>`: collect or import audit data for an inventory device and write a per-device normalized bundle.
- `bin/sys-refresh <project-path> --device <device-name> --output-scope both`: refresh a device bundle and also promote that capture into the project’s primary normalized context.
- Inventory `collector_profile`, `validation_profile`, and `backup_profile` values can resolve to platform profile files under `platforms/<platform>/profiles/<profile>/`.
- `bin/sys-generate-adapters <project-path>`: regenerate project adapter surfaces.
- `bin/sys-validate --template|--project <path>`: validate template or project structure.
- `bin/sys-project-status <project-path>`: summarize project freshness, mode, version, and git state.
- `bin/sys-project-update <project-path>`: sync template-managed files, refresh, and revalidate.
- `bin/sys-sync-template <project-path>`: explicitly sync tracked template-derived files into a project repo.
- `bin/sys-reconcile-project <project-path>`: backfill missing normalization/runtime artifacts from already-existing normalized context without forcing a full refresh.
- `bin/sys-meta-check`: validate the SACST meta-system and agent read-order surfaces.
- `bin/sys-fix --template|<project-path>`: perform safe mechanical self-healing for template or project contract drift.
- `bin/sys-research-plan <project-path> --topic <topic>`: create a project-local research note scaffold for vendor, OS, appliance, Windows, Linux, or security-tool command research.
- `bin/sys-platform-plan <project-path> --vendor <vendor> --device-class <class> --intent <intent>`: create a safe project-local plan for unmodeled vendors, devices, and access methods.
- `bin/sys-vendor-profile --list|--vendor <profile-key>`: inspect curated safe-start vendor profiles for common infrastructure systems.
- `bin/sys-secret-check <project-path>`: validate project credential references without printing secret values.
- `bin/sys-scope-check <project-path> --activity <activity>`: enforce project-local security testing scope before pentest or assessment work.
- `bin/sys-git-bootstrap <project-path>`: initialize and configure project git defaults and GitHub SSH remote.
- `bin/sys-remote <project-path> <device> <command>`: run inventory-aware remote operations with backup, validation, probe, and delayed recheck controls.
- `bin/sys-release --dry-run|--tag`: validate the current SACST release candidate and optionally tag it locally.

## Repo Working Order

When working on SACST itself, start with:

1. `AGENTS.md`
2. `TEMPLATE_CONTEXT.md`
3. `canonical/ARCHITECTURE.md`
4. `canonical/RUNTIME_BOUNDARY.md`
5. `canonical/TEMPLATE_MUTATION_POLICY.md`
6. `canonical/REPO_PRECEDENCE.md`
7. `canonical/VENDOR_RESEARCH_PROTOCOL.md`
8. `canonical/CREDENTIAL_BOUNDARY.md`
9. `canonical/AUTHORIZED_SECURITY_TESTING.md`

## Multi-Device Model

- Project-level normalized context under `context/normalized/` remains the primary operator bundle.
- Inventory-backed device bundles live under `context/normalized/devices/<device-name>/`.
- Per-device collection state lives under `runtime/devices/<device-name>/DEVICE_STATE.yaml`.

## Research and Security Boundary

- SACST encodes how agents research unfamiliar or version-sensitive command syntax; project repos store the resulting notes under `research/`.
- SACST stores credential conventions only. Project repos may store credential references, but raw credentials, tokens, keys, and certificates must remain outside both SACST and normal logs.
- Security and penetration-testing work is defensive-only by default. Project repos must opt in with `control/SECURITY_SCOPE.yaml`, rules of engagement, and explicit approval references before broader assessment activity.
- Unmodeled vendors and devices use `generic-vendor` normalization plus project-local platform plans until a dedicated module is promoted through the learning loop.
