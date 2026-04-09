# Sys-Agent Core - Template Context

## Role and Identity
This directory (`/home/whyte/.MyAdminZ/_SYS_AGENT_CORE_TEMPLATE`) is the master **Template and Meta-System** for the Sys-Agent Core.

**CRITICAL RULE:** This directory is strictly a template. It contains no computer-specific context, setup, or design files. It acts as the unmodifiable source of truth that defines how the system is built and how agents should behave.

## Scaffolding Process
When a new computer system is integrated, this template is scaffolded down into a computer-specific directory (for example, a sibling directory like `GhostZ/`). 

## Immutability
Agents working within a computer-specific directory (like `GhostZ/`) are strictly **forbidden** from modifying files in this template directory. Modifications here apply globally to the template itself and must only be done when officially updating the meta-system or core framework rules.
