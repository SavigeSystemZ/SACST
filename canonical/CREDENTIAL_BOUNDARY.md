# SACST Credential Boundary

SACST does not store real credentials.

## Template Boundary

The template may define credential-reference fields, redaction rules, and safe lookup conventions. It must not contain passwords, private keys, tokens, certificates, VPN profiles, recovery keys, or live device secrets.

## Project Boundary

Project repos may store credential references such as:

- `ssh-agent:default`
- `pass:network/opnsense/admin`
- `secret-tool:collection/item`
- `1password:vault/item/field`
- `env:VARIABLE_NAME`
- `hardware-token:yubikey-slot`

Project repos should still avoid raw secret values. Agents must retrieve secrets through the user-approved local mechanism at execution time.

## Logging Rules

- Log secret references only when needed for auditability.
- Never log raw secret values.
- Redact command output if a tool prints credentials or tokens.
- If a secret is accidentally exposed, stop, notify the user, and treat cleanup as a security incident.

## Default Credential Rule

- SACST must not store vendor default credentials.
- Agents must not assume default credentials are valid or authorized.
- If default credentials are relevant to a task, treat them as a security finding and verify through primary vendor sources or project-local scope.
- Any authorized use of a default credential requires an immediate rotation, disablement, or compensating-control plan.
