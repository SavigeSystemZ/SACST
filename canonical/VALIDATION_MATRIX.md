# SACST Validation Matrix

| Action Class | Required Validation |
| :--- | :--- |
| Package change | Binary exists, version is readable, relevant service status is healthy |
| Service config | Config syntax or dry-run check, restart or reload status, recent logs, follow-up recheck if persistence matters |
| Firewall / routing | Management-path reachability, rule state, service connectivity probe, delayed recheck when rollback windows apply |
| Disk / mounts | `mount -a` or equivalent, `lsblk`, capacity check |
| Boot / crypto | Command output review, boot config syntax, rollback availability |
| SSH / PAM / auth | Alternative access path confirmed, config syntax, session test plan, post-change access recheck |
| Switch config | Running-config backup, management reachability, config diff validation, delayed recheck |
| OPNsense change | Backup/export captured, management reachability, service/rule verification, delayed recheck |
| Windows service or remote-access change | PowerShell validation, EventLog or target service status, firewall/profile check, management path recheck |
| Unmodeled vendor/device change | Project platform plan, source-cited syntax, explicit backup, validation, rollback, and management-path preservation |
| Security test | Project `SECURITY_SCOPE.yaml` allows the activity, rules of engagement are referenced when required, evidence handling is defined |
| Vendor researched command | Source cited, target version/platform matched, risk class assigned, validation and rollback recorded |
| Any delayed-risk remote action | Inventory timeout honored, management probe repeated on delayed recheck schedule, failure treated as actionable |
