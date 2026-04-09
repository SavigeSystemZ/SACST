# Sys-Agent Core - Agent Policy

## Default Operating Contract
1. **Plan First:** Always formulate a brief plan before making changes.
2. **Context is King:** Treat the normalized context (`HOST_PROFILE.md`, etc.) as the current source of truth unless marked stale.
3. **Refresh if Stale:** If facts are missing or outdated, trigger a `sys-refresh`.
4. **Detect Precedence:** Do not assume repo-local rules are absent; detect them before touching target repositories.
5. **Smallest Safe Change:** Prefer surgical edits over full-file rewrites.
6. **Log Writes:** After any write action, update the session logs and runtime state.