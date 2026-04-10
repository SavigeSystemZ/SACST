# SACST Web Task Protocol

Use external research only when local facts are insufficient, compatibility is uncertain, command syntax is version-sensitive, or the user asks for current vendor guidance.

For operational command research, follow `canonical/VENDOR_RESEARCH_PROTOCOL.md` and store project-specific notes only in the relevant project repo.

## Allowed Uses

- Verify vendor guidance for Linux, Windows, OPNsense, switches, routers, appliances, and security tooling.
- Confirm release compatibility or breaking changes.
- Research obscure operational failures after local inspection.
- Confirm syntax before firewall, routing, auth, boot, storage, crypto, or other high-risk commands.

## Requirements

- Prefer vendor or primary sources.
- Do not expose local secrets, private paths, or confidential config snippets.
- Explain third-party commands before execution.
- Record source, version/date, confidence, validation, and rollback notes when research influences an operational command.
