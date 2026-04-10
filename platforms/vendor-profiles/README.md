# Vendor Profile Catalog

This catalog provides safe starting profiles for common infrastructure vendors before a dedicated parser or apply workflow exists.

## Rules

- Treat these profiles as planning inputs, not permission to mutate devices.
- Use live vendor research for version-sensitive syntax before executing commands.
- Store target-specific facts, citations, access details, credential references, and findings in the project repo.
- Do not store vendor default credentials here. If default credentials are relevant, treat them as a security finding requiring authorization and immediate rotation or disablement.
- Promote a profile into a dedicated platform module only after sanitized project experience and validation through the learning loop.

## Included Starting Profiles

- Cisco IOS / IOS XE
- Cisco NX-OS
- Juniper Junos
- Aruba AOS-CX
- Ubiquiti UniFi / EdgeOS
- MikroTik RouterOS
- Fortinet FortiOS
- Proxmox VE
- TrueNAS
- pfSense
- Synology DSM
- Dell iDRAC
- HPE iLO
