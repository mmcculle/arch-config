#!/usr/bin/env bash

if grep -q "\[cachyos\]" /etc/pacman.conf || grep -q "cachyos-mirrorlist" /etc/pacman.conf; then
  echo "CachyOS repositories are already configured on this system."
else

  AconfNeedProgram curl curl N
  echo "CachyOS repositories not found. Initiating installation..."
  # Create a temporary directory for the repository script setup
  TMP_DIR=$(mktemp -d)
  cd "$TMP_DIR" || return
  # Download the official CachyOS installer script archive
  curl -O https://mirror.cachyos.org/cachyos-repo.tar.xz
  # Extract the archive and enter the target folder
  tar xvf cachyos-repo.tar.xz && cd cachyos-repo || return
  # Run the automated installer script with root privileges
  sudo ./cachyos-repo.sh
  # Clean up the temporary folder after execution
  rm -rf "$TMP_DIR"
  echo "CachyOS repositories successfully added!"
  echo "Synchronizing package databases..."
  sudo pacman -Sy
fi

AddPackage aconfmgr-git   # A configuration manager for Arch Linux
AddPackage aurutils       # helper tools for the arch user repository
AddPackage pacman-contrib # Contributed scripts and tools for pacman systems
AddPackage reflector      # A Python 3 module and script to retrieve and filter the latest Pacman mirror list.
AddPackage vifm           # A file manager with curses interface, which provides Vi[m]-like environment
AddPackage cachyos-keyring # CachyOS keyring
AddPackage cachyos-mirrorlist # CachyOS repository mirrorlist
AddPackage cachyos-v3-mirrorlist # CachyOS repository mirrorlist
AddPackage cachyos-v4-mirrorlist # CachyOS repository mirrorlist
AddPackage chaotic-keyring # Chaotic-AUR PGP keyring
AddPackage chaotic-mirrorlist # Chaotic-AUR mirrorlist to use with Pacman

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

cat >"$(CreateFile /etc/pacman.d/hooks/sesh_completions_install.hook)" <<EOF
[Trigger]
Type = Package
Operation = Install
Operation = Upgrade
Target = sesh-bin

[Action]
Description = (Re)Installing sesh completion...
When = PostTransaction
Exec = /bin/sh -c 'sesh completion zsh > /usr/share/zsh/site-functions/_sesh && sesh completion bash > /etc/bash_completion.d/sesh-completion.bash'
EOF

sed -i -f - "$(GetPackageOriginalFile reflector /etc/xdg/reflector/reflector.conf)" <<EOF
/^#\?\s*--country/ s/.*/--country US/
/^--latest/ s/.*/--latest 10/
EOF

AconfNeedProgram reflector reflector N
reflector --protocol https --country US --latest 10 --sort age >"$(GetPackageOriginalFile pacman-mirrorlist /etc/pacman.d/mirrorlist)"

_pacman_conf=$(GetPackageOriginalFile pacman /etc/pacman.conf)

sed -i -f - "$_pacman_conf" << 'EOF'
/CleanMethod/ s/.*/CleanMethod = KeepCurrent/
/^#Color/ s/^#//
/^#CheckSpace/ s/^#//
/^#PrettyProgressBar/ s/^#//
/^#VerbosePkgLists/ s/^#//
/^#ParallelDownloads/ s/.*/ParallelDownloads = 5/
/\[core\]/i\
[cachyos-v4]\
Include = /etc/pacman.d/cachyos-v4-mirrorlist\
\
[cachyos-core-v4]\
Include = /etc/pacman.d/cachyos-v4-mirrorlist\
\
[cachyos-extra-v4]\
Include = /etc/pacman.d/cachyos-v4-mirrorlist\
\
[cachyos]\
Include = /etc/pacman.d/cachyos-mirrorlist\

/#\[custom\]/d
/#SigLevel/d
/#Server/d
EOF

cat << 'EOF' >> "$_pacman_conf"

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist

[mckraken]
SigLevel = Optional TrustAll
Server = https://mckraken-arch.s3.us-east-2.amazonaws.com/repo/x86_64/
EOF

if [ "$(IsIsaLevel4Supported)" -ne 1 ]; then
  sed -i '/cacnhyos*v4/ s/v4/v3/' "$_pacman_conf"
elif [ "$(IsZnvert45Supported)" -eq 0 ]; then
  sed -i '^\[cachyos*v4/ s/v4/znver4/' "$_pacman_conf"
fi

SetFileProperty /etc/pacman.conf mode 755

sed -i -f - "$(GetPackageOriginalFile pacman /etc/makepkg.conf)" <<EOF
s/-march=[^ ]*/-march=native/
s/-mtune=[^ ]*//
s/^#MAKEFLAGS=.*/MAKEFLAGS="-j\$(nproc)"/
s/^COMPRESSZST=.*/COMPRESSZST=(zstd -c -T0 --auto-threads=logical -)/
EOF

CreateLink /etc/systemd/system/timers.target.wants/reflector.timer /usr/lib/systemd/system/reflector.timer

CopyFile /etc/aurutils/makepkg-x86_64.conf
CopyFile /etc/aurutils/pacman-x86_64.conf
