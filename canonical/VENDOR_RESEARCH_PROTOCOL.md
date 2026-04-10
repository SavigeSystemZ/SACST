# SACST Vendor Research Protocol

SACST must be adaptable across vendors, operating systems, appliances, and security tooling. Agents should research command syntax when local context or platform modules are insufficient.

## When Live Research Is Required

- Vendor CLI syntax is unfamiliar or version-sensitive.
- A command may change firewall, routing, auth, boot, storage, crypto, or service behavior.
- The task involves Windows, network equipment, or a platform not already covered by local SACST platform modules.
- The user asks for current commands, latest syntax, compatibility, firmware behavior, or vendor-supported procedure.
- Existing normalized context is stale or incomplete for the target platform.

## Source Rules

- Prefer vendor or primary documentation.
- Use security advisories, release notes, and official manuals for version-specific behavior.
- Use community posts only as secondary context unless the vendor docs are unavailable or incomplete.
- Never paste secrets, private config, or full internal topology into web queries.
- Record the source, version, date accessed, and uncertainty in project research notes when the result influences an operational command.

## Command Verification Rules

Before running researched commands:

1. Identify the target platform and version from project context or inventory.
2. Confirm the command is inspect-only or classify its action risk.
3. Map the command to backup, validation, and rollback expectations.
4. Run `sys-preflight` for non-inspect or critical actions.
5. Prefer dry-run, show, validate, check, or syntax-test variants first.

## Research Storage Boundary

- SACST stores this protocol and generic examples only.
- Project repos may store research notes and citations under `research/` when they are relevant to that project.
- Raw vendor documentation dumps, secrets, private configs, and target-specific exploit notes do not belong in SACST.
