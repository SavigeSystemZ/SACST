# Sys-Agent Core - Repo Precedence Model

## Rule
When an agent is launched from the instance control directory and then works on a target repository, it must:
1. Detect local repo instructions FIRST.
2. Inspect the repo for `.cursor/rules/`, `AGENTS.md`, `GEMINI.md`, `CLAUDE.md`, or `.github/copilot-instructions.md`.
3. Obey target repo instructions for files in their scope.
4. Use Sys-Agent Core ONLY for orchestration, operating safety, state capture, and non-conflicting workflow policy.

## Conflict Resolution
If a conflict exists between the repo instructions and Sys-Agent Core (e.g., repo says "use npm", system says "use yarn for all projects"), the REPO LOCAL instruction wins. Sys-Agent Core governs the *machine*, not the *codebase*.