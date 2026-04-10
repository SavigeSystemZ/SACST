# SACST Project Sync Policy

Project repos receive template improvements through explicit sync or adoption, never by writing back into SACST.

## Modes

- `Fresh scaffold`: create a new project repo from the template.
- `Template sync`: update template-managed files in an existing SACST project repo.
- `Legacy adoption`: transform an existing non-SACST project repo in place without losing project-specific data.

## Ownership Rules

- Template-managed files may be replaced or regenerated during sync.
- Project-specific files must be preserved.
- Legacy instruction surfaces from older layouts should be imported out of active paths to avoid agent confusion.

## Required Safety

- Back up template-managed conflicts before replacement.
- Preserve pre-existing project-specific context.
- Generate an adoption or sync report whenever managed files are replaced or legacy surfaces are retired.
- Sync must not erase `LOCAL_CONTEXT.md` project-specific sections. Existing `Imported Legacy Context` or `Project-Specific Context` sections must be preserved without duplication.
