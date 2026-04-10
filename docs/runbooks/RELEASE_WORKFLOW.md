# SACST Release Workflow

## Checklist

1. Update canonical docs, schemas, templates, and tests together.
2. Run template validation and integration tests.
3. Update `CHANGELOG.md`.
4. Update `meta/TEMPLATE_VERSION.yaml`.
5. Run `bin/sys-release --dry-run`.
6. If ready, run `bin/sys-release --tag`.
