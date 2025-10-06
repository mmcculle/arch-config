#!/usr/bin/env bash

IgnorePath '/boot/*'
efi_white_list=(
	'EFI/refind/refind.conf'
	'EFI/refind/themes/*'
)
IgnorePathsExcept '/efi' "${efi_white_list[@]}"
IgnorePath '/efi/EFI/refind/keys'
IgnorePath '/efi/EFI/tools'
IgnorePath '/efi/System*'
IgnorePath '/etc/adjtime'
IgnorePath '/etc/ca-certificates/*'
IgnorePath '/etc/cups/*'
IgnorePath '/etc/NetworkManager/system-connections/*'
IgnorePath '/etc/pacman.d/gnupg/*'
IgnorePath '/etc/*.OLD'
IgnorePath '/etc/*.*bak'
IgnorePath '/etc/.updated'
IgnorePath '/etc/ld.so.cache'
IgnorePath '/etc/lvm/backup/*'
IgnorePath '/etc/lvm/archive/*'
IgnorePath '/etc/machine-id'
IgnorePath '/etc/printcap'
IgnorePath '/etc/resolv.conf'
IgnorePath '/etc/ssl/certs/*'
IgnorePath '/lost+found'
IgnorePath '/opt/piavpn/*'
IgnorePath '/usr/lib/*'
IgnorePath '/usr/lib32/*'
IgnorePath '/usr/local/lib/*'
IgnorePath '/usr/local/man/*'
IgnorePath '/usr/local/share/*'
share_white_list=(
	'refind/*'
)
IgnorePathsExcept '/usr/share' "${share_white_list[@]}"
IgnorePath '/var/*'
IgnorePath '/**/*.pacnew'

function HashCommentFilter() {
	grep -v '^#'
}
AddFileContentFilter '/etc/pacman.d/mirrorlist' HashCommentFilter
