# Windows Desktop Platform Module

This module provides baseline Windows endpoint collection guidance for SACST project repos.

## Assumptions

- Transport is usually SSH into a Windows OpenSSH server or an operator-provided capture bundle.
- Commands are PowerShell-first and must be verified against the target Windows version before mutation.
- This module does not store credentials; inventory entries should use `auth_ref` values that point to external secret handling.

## Safety

- Treat firewall, WinRM/OpenSSH, BitLocker, local admin, Defender, update, and service changes as critical.
- Preserve at least one known-good management path before changing firewall or remote-access settings.
- Use `control/RESEARCH_POLICY.yaml` for version-sensitive PowerShell syntax.
- Use `control/SECURITY_SCOPE.yaml` before any security-assessment activity beyond defensive review.
