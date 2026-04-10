# SACST Product Requirements

## Purpose

SACST is a reusable template and meta-system for AI-assisted systems administration and network administration. It produces self-contained project repos that help agents inspect, configure, repair, validate, and document Linux systems, Windows systems, OPNsense firewalls, managed switches, routers, vendor appliances, and related infrastructure safely.

## Primary Outcomes

1. Give AI agents a reliable control plane for infrastructure work.
2. Reduce hallucination by grounding agents in normalized host and network truth.
3. Enforce safety through mode gating, validation, checkpointing, rollback, and anti-lockout workflows.
4. Improve the template over time through a supervised meta-system.
5. Support current vendor, OS, appliance, Windows, Linux, and security-tool command research without storing live project findings in the template.

## Users

- Human operators
- Codex, Gemini, Claude, Cursor, Copilot, Aider, Agent Zero, Windsurf, Grok, DeepSeek, and similar tools

## Non-Goals

- Hosting live instance runtime inside SACST
- Acting like an application-project framework
- Replacing target-repo local instructions during later repo pivots
- Heavy centralized orchestration such as full IaC replacement
- Storing credentials, private configs, exploit evidence, or target-specific security findings in SACST
