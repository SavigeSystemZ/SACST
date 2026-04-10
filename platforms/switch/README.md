# Switch Platform Module

Managed-switch support uses the same inspect, preflight, backup, apply, validate, and rollback model as other platforms.

## Required Behaviors

- back up running configuration before changes
- preserve management-plane reachability
- validate port and VLAN state after mutation
