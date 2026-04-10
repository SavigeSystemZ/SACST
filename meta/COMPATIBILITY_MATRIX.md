# Compatibility Matrix

## Template Compatibility Policy

- Projects stamped with the same major template version can use `bin/sys-sync-template`.
- Minor updates may add files, expand schemas, and regenerate adapters without forcing a re-scaffold.
- Major updates may require migration notes under `docs/migration/`.

## Shim Policy

- SACST supports one compatibility-shim phase for path and command migrations.
- Deprecated path models must be removed after the first successful migration wave and validation pass.
