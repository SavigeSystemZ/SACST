# Legacy Project Adoption

Use legacy adoption when an existing project repo predates the current SACST structure.

## Goals

- preserve project-specific data
- replace outdated template-derived control structure
- remove legacy instruction-surface ambiguity
- keep git history and remote configuration intact

## Adoption Behavior

- add the current SACST root-level project structure
- preserve normalized context, logs, runtime, state, and host-specific documents
- back up overwritten template-managed files into `state/imports/<timestamp>/`
- move old control-plane instruction files out of active locations into the import archive
- regenerate current project adapter surfaces
