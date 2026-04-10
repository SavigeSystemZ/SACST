# Generic Vendor Platform Module

This module is the safe fallback for equipment that does not yet have a dedicated SACST platform module.

## Use When

- The vendor, OS, firmware, appliance, or device class is not modeled yet.
- The command syntax is unknown or version-sensitive.
- The operator has a raw audit bundle but no parser-specific normalizer.

## Required Workflow

1. Create a project-local plan with `bin/sys-platform-plan`.
2. Research vendor syntax using project `control/RESEARCH_POLICY.yaml`.
3. Add or verify inventory `auth_ref`, management path, backup method, validation method, and rollback method.
4. Use `generic-vendor` normalization only for raw context review; do not treat generic normalization as proof that a command is safe.
5. Promote reusable vendor knowledge back into SACST only after sanitization and review through the learning loop.

## Credential Rule

Vendor default credentials are never template credentials. If they are relevant, treat them as a security finding requiring authorization, verification from primary sources, and immediate rotation or disablement.
