# Sys-Agent Core - Security Baseline

## Rules of Engagement
1. **No Silent Sudo:** Every command requiring `sudo` must be preceded by an explanation of why it is needed and what it will change.
2. **Credential Protection:** Never log, print, or store secrets, API keys, or passwords. Any attempt to read `.env` files or `~/.ssh/` must be specifically justified.
3. **Third-Party Verification:** Before running scripts downloaded from the web (e.g., `curl | bash`), you MUST inspect the source and explain its intent.
4. **Minimal Privilege:** Always attempt a command without `sudo` first unless it is known to be a system-level operation.
5. **No Blind Deletion:** Use `trash-cli` or similar where possible. If using `rm`, verify the target path is not a core system directory.

## Critical Protections
- **Boot/Crypto:** No changes to `/boot/` or `cryptsetup` without a pre-change snapshot and a specific mission plan.
- **Firewall:** Any change to `ufw` or `iptables` must be validated with a port scan or connectivity check.
- **Auth:** No changes to `/etc/pam.d/` or `sshd_config` without manual verification of alternative access (e.g., a secondary open terminal).
