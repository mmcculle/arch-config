#!/usr/bin/env bash

IgnorePath '/boot/*'
IgnorePath '/efi/*'
# efi_white_list=(
# 	'limine.conf'
# )
# IgnorePathsExcept '/efi' "${efi_white_list[@]}"
# IgnorePath '/efi/limine.conf*'
# IgnorePath '/efi/EFI/refind/keys'
# IgnorePath '/efi/EFI/tools'
# IgnorePath '/efi/System*'
IgnorePath '/etc/adjtime'
IgnorePath '/etc/ca-certificates/*'
IgnorePath '/etc/cups/*'
IgnorePath '/etc/fstab'
IgnorePath '/etc/NetworkManager/system-connections/*'
IgnorePath '/etc/pacman.d/gnupg/*'
IgnorePath '/etc/*.OLD'
IgnorePath '/etc/*.*bak'
IgnorePath '/etc/*-'
IgnorePath '/etc/.updated'
IgnorePath '/etc/ld.so.cache'
IgnorePath '/etc/lvm/backup/*'
IgnorePath '/etc/lvm/archive/*'
IgnorePath '/etc/machine-id'
IgnorePath '/etc/printcap'
IgnorePath '/etc/resolv.conf'
IgnorePath '/etc/ssl/certs/*'
IgnorePath '/etc/systemd/*.pem'
IgnorePath '/etc/tpm2-tss/fapi-profiles/*'
IgnorePath '/lost+found'
IgnorePath '/opt/piavpn/*'
IgnorePath '/opt/zen-browser-bin'
IgnorePath '/usr/lib/*'
IgnorePath '/usr/lib32/*'
IgnorePath '/usr/local/lib/*'
IgnorePath '/usr/local/man/*'
IgnorePath '/usr/local/share/*'
# share_white_list=(
# 	'refind/*'
# )
# IgnorePathsExcept '/usr/share' "${share_white_list[@]}"
IgnorePath '/usr/share/*'
IgnorePath '/var/*'
IgnorePath '/**/*.pacnew'
IgnorePath '/**/*.pacsave'
IgnorePath '/etc/**/*.backup*'

function HashCommentFilter() {
	grep -v '^#'
}
AddFileContentFilter '/etc/pacman.d/mirrorlist' HashCommentFilter
AddFileContentFilter '/etc/fstab' HashCommentFilter
AddFileContentFilter '/etc/conf.d/wireless-regdom' HashCommentFilter
AddFileContentFilter '/etc/mkinitcpio.conf' HashCommentFilter
