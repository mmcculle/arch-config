#!/usr/bin/env bash

AddPackage efibootmgr     # Linux user-space application to modify the EFI Boot Manager
AddPackage limine # An advanced, portable, multiprotocol bootloader
AddPackage limine-mkinitcpio-hook # Install kernels for the Limine bootloader.
AddPackage linux          # The Linux kernel and modules
AddPackage linux-firmware # Firmware files for Linux - Default set
AddPackage linux-headers  # Headers and scripts for building modules for the Linux kernel
AddPackage linux-lts # The LTS Linux kernel and modules
AddPackage linux-lts-headers # Headers and scripts for building modules for the LTS Linux kernel
AddPackage linux-zen # The Linux ZEN kernel and modules
AddPackage linux-zen-headers # Headers and scripts for building modules for the Linux ZEN kernel
AddPackage plymouth # Graphical boot splash screen
AddPackage plymouth-theme-arch-charge-gdm # A Plyouth theme based on Fedora's Charge theme, but featuring the ArchLinux logo. Based on sjmcdougall's Arch Charge theme
AddPackage sbctl # Secure Boot key manager
AddPackage systemd-ukify # Combine kernel and initrd into a signed Unified Kernel Image
AddPackage tpm2-tools # Trusted Platform Module 2.0 tools based on tpm2-tss

cat >"$(CreateFile /etc/crypttab.initramfs)" <<"EOF"
cryptlvm	LABEL=Crypt	-	tpm2-device=auto
EOF

cat >"$(CreateFile /etc/cmdline.d/root.conf)" <<"EOF"
root=/dev/MyArchGroup/root rw add_efi_memmap splash quiet
EOF

cat >"$(CreateFile /etc/plymouth/plymouthd.conf)" <<'EOF'
[Daemon]
Theme=arch-charge-gdm
EOF

CopyFile /etc/kernel/uki.conf
CopyFile /etc/default/limine

CreateLink /etc/systemd/system/dbus-org.freedesktop.timesync1.service /usr/lib/systemd/system/systemd-timesyncd.service
CreateLink /etc/systemd/system/getty.target.wants/getty@tty1.service /usr/lib/systemd/system/getty@.service
CreateLink /etc/systemd/system/multi-user.target.wants/remote-fs.target /usr/lib/systemd/system/remote-fs.target
CreateLink /etc/systemd/system/sockets.target.wants/systemd-userdbd.socket /usr/lib/systemd/system/systemd-userdbd.socket
CreateLink /etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service /usr/lib/systemd/system/systemd-timesyncd.service
