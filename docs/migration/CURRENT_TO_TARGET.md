# Current to Target Migration

## Source State

- Mixed template-root and internal `framework/` path assumptions.
- Runtime generation attempted inside SACST.
- Thin command layer with weak validation and logging.

## Target State

- Repo root is the canonical template and meta-system.
- Project repos are scaffolded outside SACST and are self-contained.
- Canonical docs, schemas, templates, adapters, and tests stay aligned.

## Migration Sequence

1. Replace mixed path assumptions with repo-root truth.
2. Move project scaffold logic to `templates/instance/`.
3. Validate and scaffold projects externally.
4. Regenerate adapters from canonical truth.
5. Remove compatibility shims after one successful migration wave.
6. Use legacy adoption for pre-existing repos such as GhostZ instead of overwriting them blindly.
