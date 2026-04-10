# Windows Server Platform Module

This module extends the Windows desktop baseline for server operations.

## Assumptions

- Collection usually runs through Windows OpenSSH, a bastion, or an operator-provided raw audit bundle.
- Server roles vary widely; use live vendor/Microsoft documentation when role-specific PowerShell syntax is uncertain.
- Credentials remain external and are referenced through project inventory `auth_ref` values.

## Safety

- Treat Active Directory, DNS, DHCP, Hyper-V, firewall, WinRM/OpenSSH, BitLocker, Defender, update, storage, and service changes as critical.
- Preserve a known-good management path and rollback plan before changing access, firewall, or identity services.
- Keep security-assessment activity bound to `control/SECURITY_SCOPE.yaml`.
