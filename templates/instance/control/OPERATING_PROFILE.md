# Project Operating Profile

This project repo is a self-contained operational control plane derived from SACST.

## Focus

- system administration
- network administration
- host and device inspection
- safe change execution with logging, validation, and rollback
- inventory-backed multi-device collection and normalized context
- vendor, OS, appliance, Windows, Linux, and security-tool command research when syntax or compatibility is uncertain
- authorized defensive security assessment and hardening within explicit project scope

## Ground Rules

- Use normalized context as truth unless stale.
- Use per-device normalized bundles for inventory-managed devices when work targets a specific firewall, switch, or remote node.
- Use live research for unfamiliar or version-sensitive commands; prefer vendor and primary sources.
- Store credential references only, never raw secrets.
- Treat security testing as defensive-only unless the project scope explicitly authorizes more.
- Run project-local validation before high-risk work.
- Respect target-repo local instructions when entering another repo.
