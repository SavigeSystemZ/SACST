# Sys-Agent Core - Runbook

## Setup (New Instance)
1. Ensure you are on the target machine.
2. Run `~/.MyAdminZ/_SYS_AGENT_CORE_TEMPLATE/bin/sys-init <InstanceName>`.
3. Verify `~/.MyAdminZ/<InstanceName>/context/raw-audit/` is populated.

## Refresh (Update State)
1. Run `~/.MyAdminZ/_SYS_AGENT_CORE_TEMPLATE/bin/sys-refresh <InstanceName>`.
2. The agent should re-normalize the raw audits into updated Markdown truth.

## Validation
1. Use `sys-validate` (upcoming M7 tool) or manually check `logs/critical-actions.jsonl` after major tasks.
2. Verify `MODE_STATE.yaml` matches the expected agent operational boundary.

## Rollback
1. If a critical action failed, locate the `rollback_refs` in `critical-actions.jsonl`.
2. Restore the configuration from `state/checkpoints/`.

## Promotion
1. Review `framework/learning/candidates/`.
2. Merge successful changes into `framework/templates/` or canonical documents.nical documents.