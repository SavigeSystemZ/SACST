# Sys-Agent Core - Product Requirements Document (PRD)

## Purpose
A multi-agent desktop operations control plane designed to let CLI AI agents collaborate with the user to inspect, configure, repair, optimize, and operate the workstation safely and efficiently.

## Users
- Human User (Owner / Operator)
- CLI AI Agents (Gemini CLI, Cursor, Copilot, Claude, Aider, Agent Zero, etc.)

## Jobs-to-be-done
1. **Understand the Machine:** Quickly ingest hardware, software, and configuration facts to provide tailored advice.
2. **Execute Operations:** Safely perform system configurations, software installations, and file modifications.
3. **Ensure Safety:** Provide strict boundaries, logging, and rollback capabilities for critical actions.
4. **Self-Improvement:** Learn from past interactions to refine templates and operational policies over time.

## Non-Goals
- Full autonomous takeover without user consent (unless explicitly granted via YOLO mode).
- Replacement of repo-local instructions (Sys-Agent Core augments, not overrides, project-specific contexts).

## Success Metrics
- Zero unrecoverable system breakages caused by AI agents.
- Reduction in agent "hallucinations" regarding system state and capabilities.
- Successful adoption and cross-compatibility across at least 3 different CLI AI agents.

## MVP Scope
- Foundational directory structure and control files.
- `GhostZ` instance implementation capturing Kubuntu 24.04 context.
- YOLO protocol definition and basic logging schemas.