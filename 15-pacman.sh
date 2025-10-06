#!/usr/bin/env bash

AddPackage aconfmgr-git   # A configuration manager for Arch Linux
AddPackage aurutils       # helper tools for the arch user repository
AddPackage pacman-contrib # Contributed scripts and tools for pacman systems
AddPackage reflector      # A Python 3 module and script to retrieve and filter the latest Pacman mirror list.
AddPackage vifm           # A file manager with curses interface, which provides Vi[m]-like environment

cat >"$(CreateFile /etc/pacman.d/hooks/paccache-remove.hook)" <<EOF
[Trigger]
Operation = Remove
Type = Package
Target = *

[Action]
Description = Cleaning pacman cache...
When = PostTransaction
Exec = /usr/bin/paccache -ruk0
EOF

cat >"$(CreateFile /etc/pacman.d/hooks/paccache-upgrade.hook)" <<EOF
[Trigger]
Operation = Upgrade
Type = Package
Target = *

[Action]
Description = Cleaning pacman cache...
When = PostTransaction
Exec = /usr/bin/paccache -rk2
EOF

sed -i -f - "$(GetPackageOriginalFile reflector /etc/xdg/reflector/reflector.conf)" <<EOF
/^#\?\s*--country/ s/.*/--country US/
/^--latest/ s/.*/--latest 10/
EOF

AconfNeedProgram reflector reflector N
reflector --protocol https --country US --latest 10 --sort age >"$(GetPackageOriginalFile pacman-mirrorlist /etc/pacman.d/mirrorlist)"

sed -i -f - "$(GetPackageOriginalFile pacman /etc/pacman.conf)" <<EOF
/CleanMethod/ s/.*/CleanMethod = KeepCurrent/
/^#Color/ s/^#//
/^#CheckSpace/ s/^#//
/^#VerbosePkgLists/ s/^#//
/^#ParallelDownloads/ s/.*/ParallelDownloads = 5/
/ParallelDownloads/ a ILoveCandy
/#\[custom\]/ s/.*/\[mckraken\]/
/#SigLevel/ s/^#//
/#Server/ s/.*/Server = https:\/\/mckraken-arch.s3.us-east-2.amazonaws.com\/repo\/x86_64\//
EOF

SetFileProperty /etc/pacman.conf mode 755

sed -i -f - "$(GetPackageOriginalFile pacman /etc/makepkg.conf)" <<EOF
s/-march=[^ ]*/-march=native/
s/-mtune=[^ ]*//
s/^#MAKEFLAGS=.*/MAKEFLAGS="-j\$(nproc)"/
s/^COMPRESSZST=.*/COMPRESSZST=(zstd -c -T0 --auto-threads=logical -)/
EOF

sed -i -f - "$(GetPackageOriginalFile pacman /etc/makepkg.conf.d/rust.conf)" <<"EOF"
/^#RUSTFLAGS/ s/^.*/RUSTFLAGS="-C force-frame-pointer=yes"/
/^#DEBUG_RUSTFLAGS/ s/^.*/DEBUG_RUSTFLAGS="-C debuginfo=2"/
EOF

CopyFile /etc/aurutils/makepkg-mckraken.conf
CopyFile /etc/aurutils/pacman-mckraken.conf 755

CreateLink /etc/systemd/system/multi-user.target.wants/reflector.service /usr/lib/systemd/system/reflector.service
