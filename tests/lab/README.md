# SACST Lab Tests

Lab tests are opt-in and are not run by CI or `sys-release`.

They are for real devices that the operator owns or is explicitly authorized to test.

## Required Environment

- `SACST_LAB_PROJECT`: path or instance name of a SACST project repo
- `SACST_LAB_DEVICE`: inventory device name

## Example

```bash
SACST_LAB_PROJECT=GhostZ SACST_LAB_DEVICE=lab-switch ./tests/lab/test_device_inspect.sh
```
