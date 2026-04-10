# SACST Error Handling Policy

## Loop

1. Detect the failure.
2. Diagnose without mutation.
3. Check whether freshness, permissions, or precedence caused the failure.
4. Create or confirm a checkpoint before risky remediation.
5. Propose or execute the fix according to mode.
6. Validate and log the result.

## Self-Healing Boundary

- Use `bin/sys-fix --template` only for known-safe SACST mechanical drift.
- Use `bin/sys-fix <project>` only for known-safe project contract drift.
- Use `bin/sys-reconcile-project <project>` when existing normalized context lacks current manifest/runtime metadata.
- Do not use self-healing commands to perform device configuration changes or to delete unknown project-specific data.

## Stop Conditions

- Stop after repeated failed remediations.
- Stop when management reachability is at risk and anti-lockout protection is not confirmed.
- Stop when secret exposure would be required.
