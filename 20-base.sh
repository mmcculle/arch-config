#!/usr/bin/env bash

AddPackage autoconf                # A GNU tool for automatically configuring source code
AddPackage automake                # A GNU tool for automatically creating Makefiles
AddPackage base                    # Minimal package set to define a basic Arch Linux installation
AddPackage bison                   # The GNU general-purpose parser generator
AddPackage dash                    # POSIX compliant shell that aims to be as small as possible
AddPackage debugedit               # Tool to mangle source locations in .debug files
AddPackage devtools                # Tools for Arch Linux package maintainers
AddPackage dialog                  # A tool to display dialog boxes from shell scripts
AddPackage dmidecode               # Desktop Management Interface table related utilities
AddPackage fd                      # Simple, fast and user-friendly alternative to find
AddPackage eza                     # A modern replacement for ls (community fork of exa)
AddPackage fakeroot                # Tool for simulating superuser privileges
AddPackage gdb                     # The GNU Debugger
AddPackage git                     # the fast distributed version control system
AddPackage intel-ucode             # Microcode update files for Intel CPUs
AddPackage libfido2                # Library functionality for FIDO 2.0, including communication with a device over USB
AddPackage libcurl-gnutls          # command line tool and library for transferring data with URLs (no versioned symbols, linked against gnutls)
AddPackage lvm2                    # Logical Volume Manager 2 utilities
AddPackage m4                      # The GNU macro processor
AddPackage make                    # GNU make utility to maintain groups of programs
AddPackage man-db                  # A utility for reading man pages
AddPackage man-pages               # Linux man pages
AddPackage moreutils               # A growing collection of the unix tools that nobody thought to write thirty years ago
AddPackage openssh                 # SSH protocol implementation for remote login, command execution and file transfer
AddPackage pam-u2f                 # Universal 2nd Factor (U2F) PAM authentication module from Yubico
AddPackage patch                   # A utility to apply patch files to original sources
AddPackage pkgconf                 # Package compiler and linker metadata toolkit
AddPackage ripgrep                 # A search tool that combines the usability of ag with the raw speed of grep
AddPackage ripgrep-all             # rga: ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc.
AddPackage rofi                    # A window switcher, application launcher and dmenu replacement
AddPackage srm                     # A secure replacement for rm(1) that overwrites data before unlinking
AddPackage sudo                    # Give certain users the ability to run some commands as root
AddPackage texinfo                 # GNU documentation system for on-line information and printed output
AddPackage time                    # Utility for monitoring a program's use of system resources
AddPackage tldr                    # Command line client for tldr, a collection of simplified man pages.
AddPackage unzip                   # For extracting and viewing files in .zip archives
AddPackage vi                      # The original ex/vi text editor
AddPackage vim                     # Vi Improved, a highly configurable, improved version of the vi text editor
AddPackage wget                    # Network utility to retrieve files from the web
AddPackage which                   # A utility to show the full path of commands
AddPackage whois                   # Intelligent WHOIS client
AddPackage yubikey-manager         # Python library and command line tool for configuring a YubiKey
AddPackage yubico-pam              # Yubico YubiKey PAM module
AddPackage yubikey-personalization # Yubico YubiKey Personalization library and tool
AddPackage zsh                     # A very advanced and programmable command interpreter (shell) for UNIX

CreateDir /etc/userdb

cat >"$(CreateFile /etc/hostname)" <<EOF
$_hostname
EOF

CreateLink /etc/os-release ../usr/lib/os-release
CreateLink /etc/localtime /usr/share/zoneinfo/US/Eastern
CreateLink /usr/bin/sh dash

CreateFile /etc/.pwd.lock 600 >/dev/null
SetFileProperty /usr/bin/groupmems group groups
SetFileProperty /usr/bin/groupmems mode 2750

sed -i -f - "$(GetPackageOriginalFile glibc /etc/locale.gen)" <<EOF
s/^#\(en_US.UTF-8\)/\1/
EOF

cat >"$(CreateFile /etc/locale.conf)" <<EOF
LANG=en_US.UTF-8
EOF

cat >"$(CreateFile /etc/vconsole.conf)" <<EOF
FONT=ter-v16b
EOF

sed -i -f - "$(GetPackageOriginalFile sudo /etc/sudoers)" <<EOF
s/^# \(%wheel ALL=(ALL:ALL) ALL\)$/\1/
EOF

cat >"$(CreateFile /etc/pacman.d/hooks/dash_as_sh.hook)" <<EOF
[Trigger]
Type = Package
Operation = Install
Operation = Upgrade
Target = bash

[Action]
Description = Re-pointing /bin/sh symlink to dash...
When = PostTransaction
Exec = /usr/bin/ln -sfT dash /usr/bin/sh
Depends = dash
EOF

cat >>"$(GetPackageOriginalFile filesystem /etc/shells)" <<EOF
/bin/zsh
/usr/bin/zsh
/usr/bin/git-shell
/usr/bin/systemd-home-fallback-shell
/bin/dash
EOF

sed -i -f - "$(GetPackageOriginalFile pambase /etc/pam.d/system-local-login)" <<EOF
/^#%PAM-1.0/ a auth      sufficient pam_u2f.so  nouserok pinverification=1 cue
/^\s*$/d
EOF

sed -i -f - "$(GetPackageOriginalFile sudo /etc/pam.d/sudo)" <<EOF
/^#%PAM-1.0/ a auth        sufficient  pam_u2f.so  nouserok pinverification=1 cue
EOF

cat >"$(CreateFile /etc/zsh/zshenv)" <<"EOF"
#!usr/bin/env zsh
# Global zshenv
#
# Set the global Environmental Variables

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"

if [[ -d "$XDG_CONFIG_HOME/zsh/" ]]; then
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"
fi
EOF

CreateLink /etc/systemd/system/timers.target.wants/fstrim.timer /usr/lib/systemd/system/fstrim.timer
CreateLink /etc/systemd/system/sockets.target.wants/pcscd.socket /usr/lib/systemd/system/pcscd.socket
CreateLink /etc/systemd/user/sockets.target.wants/p11-kit-server.socket /usr/lib/systemd/user/p11-kit-server.socket
