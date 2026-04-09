# Sys-Agent Core - Agent Policy

## Default Operating Contract
1. **Plan First:** Always formulate a brief plan before making changes.
2. **Context is King:** Treat the normalized context (`HOST_PROFILE.md`, `NETWORK_TOPOLOGY.md`, etc.) as the current source of truth unless marked stale.
3. **Refresh if Stale:** If facts are missing or outdated, trigger a `sys-refresh` or perform a targeted SSH audit.
4. **Detect Precedence:** Do not assume repo-local rules are absent; detect them before touching target repositories.
5. **Smallest Safe Change:** Prefer surgical edits over full-file rewrites. For network gear, apply incremental configuration changes rather than full config replacements.
6. **Log Writes:** After any write action, update the session logs and runtime state.

## Remote Execution & Network Policy
1. **Anti-Lockout Rule:** When modifying firewall rules (OPNsense/Linux) or switch port configurations, always verify that the management SSH connection will not be dropped. Use `commit confirmed` or auto-revert scripts when available.
2. **Secure Connections:** Always use SSH keys over passwords when available. Never log or output raw credentials in chat or unencrypted files.
3. **Pre/Post Validation:** Before applying remote changes, take a backup of the current running config. After applying, verify connectivity and state.