#!/usr/bin/env bash

AddPackage 7zip               # File archiver for extremely high compression
AddPackage abook              # Text-based addressbook designed for use with Mutt
AddPackage bitwarden          # A secure and free password manager for all of your devices
AddPackage bitwarden-cli      # The command line vault
AddPackage btop               # A monitor of system resources, bpytop ported to C++
AddPackage chezmoi            # Manage your dotfiles across multiple machines
AddPackage ctpv-git           # Fast image previews for lf
AddPackage dropbox            # A free service that lets you bring your photos, docs, and videos anywhere and share them easily.
AddPackage fastfetch          # A feature-rich and performance oriented neofetch like system information tool
AddPackage ffmpegthumbnailer  # Lightweight video thumbnailer that can be used by file managers
AddPackage firefox            # Fast, Private & Safe Web Browser
AddPackage fzf                # Command-line fuzzy finder
AddPackage ghostty            # Fast, native, feature-rich terminal emulator pushing modern features
AddPackage go-mtpfs-git       # Simple tool for viewing MTP devices as FUSE filesystems
AddPackage gocryptfs          # Encrypted overlay filesystem written in Go.
AddPackage gparted            # A Partition Magic clone, frontend to GNU Parted
AddPackage htop               # Interactive process viewer
AddPackage hunspell-en_us     # US English hunspell dictionaries
AddPackage kicad              # Electronic schematic and printed circuit board (PCB) design tools
AddPackage kicad-library      # KiCad symbol, footprint and template libraries
AddPackage kicad-library-3d   # KiCad 3D model libraries
AddPackage kitty              # A modern, hackable, featureful, OpenGL-based terminal emulator
AddPackage lazygit            # Simple terminal UI for git commands
AddPackage lf                 # A terminal file manager inspired by ranger
AddPackage libreoffice-fresh  # LibreOffice branch which contains new features and program enhancements
AddPackage lshw               # A small tool to provide detailed information on the hardware configuration of the machine.
AddPackage lynx               # A text browser for the World Wide Web
AddPackage mopidy             # An extensible music server written in Python
AddPackage mopidy-mpd         # Mopidy extension for controlling playback from MPD clients
AddPackage mopidy-ytmusic-git # Mopidy extension for playing music from Youtube Music
AddPackage mpv                # a free, open source, and cross-platform media player
AddPackage mutt-wizard-git    # Easily auto-configure neomutt and isync/mpop with safe passwords (IMAP/POP3/SMTP)
AddPackage ncmpcpp            # Featureful ncurses based MPD client inspired by ncmpc
AddPackage nerdfix            # nerdfix helps you to find/fix obsolete Nerd Font icons in your project.
AddPackage obsidian           # A powerful knowledge base that works on top of a local folder of plain text Markdown files
AddPackage pass               # Stores, retrieves, generates, and synchronizes passwords securely
AddPackage playerctl          # mpris media player controller and lib for spotify, vlc, audacious, bmp, xmms2, and others.
AddPackage ranger             # Simple, vim-like file manager
AddPackage rofi-dmenu         # Symlink for using Rofi as a drop-in replacement to dmenu
AddPackage sesh-bin           # Smart session manager for the terminal
AddPackage simple-mtpfs       # A FUSE filesystem that supports reading/writing from MTP devices
AddPackage tmux               # Terminal multiplexer
AddPackage tree-sitter        # Incremental parsing library
AddPackage udiskie            # Removable disk automounter using udisks
AddPackage ueberzugpp         # Command line utility which allows to display images in the terminal, written in C++
AddPackage vivid              # LS_COLORS manager with multiple themes
AddPackage wezterm-git        # A terminal emulator implemented in Rust, using OpenGL ES 2 for rendering.
AddPackage yazi               # Blazing fast terminal file manager written in Rust, based on async I/O
AddPackage yt-dlp             # A youtube-dl fork with additional features and fixes
AddPackage zathura            # Minimalistic document viewer
AddPackage zathura-pdf-mupdf  # PDF support for Zathura (MuPDF backend) (Supports PDF, ePub, and OpenXPS)
AddPackage zen-browser-bin    # Performance oriented Firefox-based web browser
AddPackage zoxide             # A smarter cd command for your terminal

AddUser mopidy '!*' 46 46 '!*' 'Mopidy User' /var/lib/mopidy /usr/bin/nologin audio ''

# Gnome Keyring - Dependencies of  bitwarden
CreateLink /etc/systemd/user/sockets.target.wants/gnome-keyring-daemon.socket /usr/lib/systemd/user/gnome-keyring-daemon.socket
