#!/usr/bin/env bash

AddPackage efibootmgr     # Linux user-space application to modify the EFI Boot Manager
AddPackage linux          # The Linux kernel and modules
AddPackage linux-firmware # Firmware files for Linux - Default set
AddPackage linux-headers  # Headers and scripts for building modules for the Linux kernel
AddPackage refind         # An EFI boot manager

sed -i -f - "$(GetPackageOriginalFile refind /usr/share/refind/refind.conf-sample)" <<"EOF"
/^#resolution max/ s/^#//
/^#showtools/ s/.*/showtools shell, memtest, reboot, shutdown, about/
/^#extra_kernel_version_strings/ s/.*/extra_kernel_version_strings linux-hardened,linux-rt-lts,linux-zen,linux-lts,linux-rt,linux/
$a\\ninclude themes/rEFInd-minimal-dark/theme.conf
EOF

CopyFileFromOutputTo /usr/share/refind/refind.conf-sample /efi/EFI/refind/refind.conf 755

GetFilesFromOnlineTarball \
	https://github.com/quantrancse/rEFInd-minimal-themes/archive/refs/heads/master.tar.gz \
	rEFInd-minimal-themes-master/rEFInd-minimal-dark 1 /efi/EFI/refind/themes 755

CopyFile /efi/EFI/refind/themes/rEFInd-minimal-dark/theme.conf 755
SetFileProperty /efi/EFI/refind/themes/rEFInd-minimal-dark/icons_dark mode ''
SetFileProperty /efi/EFI/refind/themes/rEFInd-minimal-dark mode ''

cat >"$(CreateFile /etc/crypttab.initramfs)" <<"EOF"
cryptlvm	LABEL=Crypt	-	fido2-device=auto
EOF

genfstab -U / >>"$(GetPackageOriginalFile filesystem /etc/fstab)"

CreateLink /etc/systemd/system/dbus-org.freedesktop.timesync1.service /usr/lib/systemd/system/systemd-timesyncd.service
CreateLink /etc/systemd/system/getty.target.wants/getty@tty1.service /usr/lib/systemd/system/getty@.service
CreateLink /etc/systemd/system/multi-user.target.wants/remote-fs.target /usr/lib/systemd/system/remote-fs.target
CreateLink /etc/systemd/system/sockets.target.wants/systemd-userdbd.socket /usr/lib/systemd/system/systemd-userdbd.socket
CreateLink /etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service /usr/lib/systemd/system/systemd-timesyncd.service
