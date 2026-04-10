# Project Lifecycle

## Fresh Project

1. `bin/sys-init <InstanceName>`
2. `bin/sys-validate --project <path>`
3. `bin/sys-refresh <path>`

## Legacy Project Adoption

1. `bin/sys-init <InstanceName> --path <existing-project> --adopt-existing --dry-run`
2. Review the planned managed-path replacements.
3. Run the real adoption.
4. Review `reports/latest/ADOPTION_REPORT.md`.

## Template Update

1. `bin/sys-sync-template <project> --dry-run`
2. Review the managed-file replacement report.
3. Run the real sync.
4. Re-run project validation and refresh as needed.

## Inventory Device Refresh

1. Confirm the target device exists in `inventory/devices.yaml`.
2. Run `bin/sys-refresh <project> --device <device-name> --report`.
3. Review the generated per-device bundle under `context/normalized/devices/<device-name>/`.
4. Review `runtime/devices/<device-name>/DEVICE_STATE.yaml`.
5. Only use `--output-scope both` when the device capture should replace the project’s primary normalized context.
