# SACST Security Baseline

## Core Rules

1. Explain privileged intent before using `sudo`.
2. Never log or persist raw secrets, credentials, or private keys.
3. Prefer least privilege and the smallest safe change.
4. Inspect downloaded scripts before execution.
5. Treat firewall, auth, boot, crypto, disk, routing, and core-service work as critical actions.
6. Treat security testing as defensive-only unless `control/SECURITY_SCOPE.yaml` explicitly authorizes the activity and names the rules of engagement.
7. Store credential references only; keep raw credentials in external secret stores, SSH agents, password managers, or operator-held sessions.

## Remote Safety

- Preserve the management path before applying remote network or firewall changes.
- Take a pre-change backup before remote config mutation.
- Validate reachability and state after every remote change.
- Record rollback manifests for remote mutations, including the rollback command or restore instructions when a device-specific rollback command is not available.

## Research Safety

- Use live research when command syntax is unfamiliar, vendor-specific, or version-sensitive.
- Do not paste private configs, secrets, token values, or confidential topology into research queries.
- Convert researched commands into preflighted project actions with validation and rollback notes before execution.

## Destructive Action Safety

- Destructive deletion, disk, boot, crypto, identity, firmware, and factory-reset actions require explicit confirmation even in YOLO mode.
- Unmodeled vendor devices require a project-local platform plan before mutation.
- Unknown rollback paths block critical remote changes unless the operator explicitly provides a rollback reference and accepts the risk.

## Repo Pivot Safety

- When entering another repository, detect its local instruction files before editing.
- SACST guidance governs machine operations and orchestration, not target-repo implementation preferences.
