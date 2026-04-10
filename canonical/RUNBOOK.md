# SACST Runbook

## Scaffold a Project Repo

1. Run `bin/sys-init <InstanceName>`.
2. Confirm the project repo was created outside SACST.
3. Run `bin/sys-validate --project <project-path>`.

## Refresh a Project Repo

1. Run `bin/sys-refresh <project-path>`.
2. Review normalized context and freshness state.
3. Regenerate adapters if needed.

## Refresh an Inventory Device

1. Confirm the device entry in `inventory/devices.yaml`.
2. Run `bin/sys-refresh <project-path> --device <device-name>`.
3. Review `context/normalized/devices/<device-name>/`.
4. Review `runtime/devices/<device-name>/DEVICE_STATE.yaml`.
5. Use `--output-scope both` only when intentionally promoting that device capture into the project’s primary normalized context.

## Sync Template Improvements

1. Review template changes in SACST.
2. Run `bin/sys-sync-template <project-path>`.
3. Re-run project validation and adapter generation.
