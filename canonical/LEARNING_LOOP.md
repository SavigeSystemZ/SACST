# SACST Learning Loop

## Purpose

Allow SACST to improve safely from successful project outcomes without letting live project state corrupt the template.

## Flow

1. Export a sanitized candidate from a project repo.
2. Store it in `learning/candidates/` with provenance and affected surfaces.
3. Run conflict, schema, adapter, and fixture impact review.
4. Require explicit approval before promotion.
5. Promote into canonical docs, templates, adapters, schemas, or platform modules.

## Rules

- No direct promotion from a live project repo into SACST.
- No unsanitized host-specific identifiers in promoted content.
- Every promotion must update validation coverage if behavior changes.
