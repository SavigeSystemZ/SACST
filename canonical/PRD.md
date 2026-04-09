# Sys-Agent Core - Product Requirements Document (PRD)

## Purpose
A multi-agent operations control plane designed to let CLI AI agents collaborate with the user to inspect, configure, repair, optimize, and operate infrastructure safely and efficiently. This includes local workstations, remote Linux servers, OPNsense firewalls, and network switches via SSH.

## Users
- Human User (SysAdmin / Network Admin / Operator)
- CLI AI Agents (Gemini CLI, Cursor, Copilot, Claude, Aider, Agent Zero, etc.)

## Jobs-to-be-done
1. **Understand the Infrastructure:** Quickly ingest hardware, software, network topology, and configuration facts across a fleet of devices to provide tailored advice.
2. **Execute Operations:** Safely perform system configurations, software installations, file modifications, and network state changes (VLANs, firewall rules, routing).
3. **Ensure Safety:** Provide strict boundaries, logging, rollback capabilities for critical actions, and prevent network lockouts during remote SSH operations.
4. **Self-Improvement:** Learn from past interactions to refine templates and operational policies over time.

## Non-Goals
- Full autonomous takeover without user consent (unless explicitly granted via YOLO mode).
- Replacement of repo-local instructions (Sys-Agent Core augments, not overrides, project-specific contexts).
- Centralized heavyweight orchestration (like Ansible/Terraform); this is a lightweight agentic control plane.

## Success Metrics
- Zero unrecoverable system or network breakages caused by AI agents.
- Reduction in agent "hallucinations" regarding infrastructure state and capabilities.
- Successful adoption and cross-compatibility across at least 3 different CLI AI agents.

## MVP Scope
- Foundational directory structure and control files for local and remote devices.
- `default` instance implementation capturing local OS context and a sample network inventory.
- YOLO protocol definition and basic logging schemas.
- Support for SSH-based auditing of Linux, OPNsense, and standard network switches.