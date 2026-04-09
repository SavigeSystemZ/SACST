# Sys-Agent Core - Critical Action Classes

The following systems are considered CRITICAL. Any modification to these requires logging, snapshots, and validation, even in YOLO mode.

1. **Bootloader:** `/boot/`, GRUB config.
2. **Initramfs:** `/etc/initramfs-tools/`.
3. **Kernel:** Package changes to `linux-image-*`, `linux-headers-*`.
4. **Disk/Crypto:** `cryptsetup`, `/etc/fstab`, `parted`, `fdisk`, `mkfs.*`.
5. **Firewall/Network:** `ufw`, `iptables`, `nftables`, `/etc/network/`, Netplan.
6. **PAM / SSH Auth:** `/etc/pam.d/`, `/etc/ssh/sshd_config`, `~/.ssh/authorized_keys`.
7. **GPU Driver:** NVIDIA/AMD driver installations or removals.
8. **Core Services:** `systemd`, `dbus`, `docker` / `containerd` replacements.