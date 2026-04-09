# Sys-Agent Core - Architecture

## Control-Plane Model
The system operates as a file-based control plane, utilizing a set of canonical Markdown and YAML files to dictate policy, record state, and track actions. 

## Module Boundaries
1. **Framework (`/framework/`):** The global, portable meta-system containing canonical rules, schemas, templates, and the supervised learning loop.
2. **Instances (`/instances/`):** Machine-specific configurations housing the current state of truth derived from raw audits.
3. **Adapters (`/instances/<name>/control/`):** Thin, tool-native entry points (e.g., `AGENTS.md`, `GEMINI.md`) that point back to the framework's canonical truth.

## Precedence Model
1. Repo-Local Instructions (`.cursor/rules`, local `AGENTS.md`)
2. Sys-Agent Core Framework Policy
3. Sys-Agent Core Instance Truth
4. Session State

## Learning Loop Architecture
1. **Feedback Capture:** Session outcomes and explicit user feedback are logged.
2. **Candidate Generation:** Successful patterns are isolated into `candidates/`.
3. **Promotion Gate:** Supervised review required before a candidate modifies canonical templates.