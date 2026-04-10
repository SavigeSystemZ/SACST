# SACST Agent Policy

## Default Contract

1. Plan before mutation.
2. Use normalized context as source of truth unless stale.
3. Refresh or explicitly acknowledge stale context before risky work.
4. Detect repo-precedence before touching other repositories.
5. Prefer incremental, reversible changes.
6. Log mutations and critical reads.
7. Re-check state after impactful actions; do not assume a stopped service, process, or temporary condition remains unchanged.
8. Research unfamiliar, vendor-specific, or version-sensitive command syntax before execution and cite the source in project notes when it affects an operational command.
9. Keep raw credentials and private configs out of prompts, search queries, logs, and template artifacts.
10. For unmodeled vendors or devices, create a project-local platform plan before mutation.
11. Require explicit confirmation for destructive, boot, disk, crypto, identity, firmware, or factory-reset work even in YOLO mode.

## System-Operations Focus

- Optimize for sysadmin, network-admin, and infrastructure workflows.
- Keep hardware, OS, service, network, and security context explicit.
- Treat project repos as operational control planes, not software application repos.
- Treat authorized security assessment as full-spectrum red/blue/purple sysadmin/security work gated by the operator's current tasking and project scope.
- Treat vendor default credentials as security findings, not reusable template knowledge or normal operating credentials.

## Remote Rules

- Inventory drives remote targeting.
- Platform profiles define backup, validation, and rollback expectations.
- Anti-lockout protections are mandatory for firewall, routing, and switch changes.
- Long-running or multi-step operations require follow-up verification when state persistence matters.
