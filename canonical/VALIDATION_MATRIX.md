# Sys-Agent Core - Validation Matrix

What must be checked after each class of action:

| Action Class | Required Validation |
| :--- | :--- |
| **Package Install** | Check binary exists in `$PATH`, check version, check `systemctl status` if a service was installed. |
| **Service Config** | `systemctl daemon-reload && systemctl restart <svc>`, then check `systemctl status <svc>` and `journalctl -u <svc> -n 20`. |
| **Network/Firewall** | `ufw status` or `iptables -L`, plus test connection via `curl` or `ping`. |
| **Disk/Mounts** | `mount -a`, `lsblk`, `df -h`. |
| **Kernel/Boot** | `update-grub` / `update-initramfs -u`, check for errors in output. |