#!/usr/bin/env bash

AddPackage 7zip               # File archiver for extremely high compression
AddPackage abook              # Text-based addressbook designed for use with Mutt
AddPackage bitwarden          # A secure and free password manager for all of your devices
AddPackage bitwarden-cli      # The command line vault
AddPackage btop               # A monitor of system resources, bpytop ported to C++
AddPackage cava               # Console-based Audio Visualizer with support for multiple backends
AddPackage chezmoi            # Manage your dotfiles across multiple machines
AddPackage chezit             # Terminal UI for chezmoi dotfile management
AddPackage ctpv-git           # Fast image previews for lf
AddPackage cyme # List system USB buses and devices; a lib and modern cross-platform lsusb
AddPackage dropbox            # A free service that lets you bring your photos, docs, and videos anywhere and share them easily.
AddPackage fastfetch          # A feature-rich and performance oriented neofetch like system information tool
AddPackage ffmpegthumbnailer  # Lightweight video thumbnailer that can be used by file managers
AddPackage firefox            # Fast, Private & Safe Web Browser
AddPackage firefoxpwa         # A tool to install, manage and use Progressive Web Apps (PWAs) in Mozilla Firefox (native component)
AddPackage fzf                # Command-line fuzzy finder
AddPackage ghostty            # Fast, native, feature-rich terminal emulator pushing modern features
AddPackage gimp               # GNU Image Manipulation Program
AddPackage go-mtpfs-git       # Simple tool for viewing MTP devices as FUSE filesystems
AddPackage gocryptfs          # Encrypted overlay filesystem written in Go.
AddPackage goobook            # Access your Google contacts from the command line
AddPackage gparted            # A Partition Magic clone, frontend to GNU Parted
AddPackage htop               # Interactive process viewer
AddPackage hunspell-en_us     # US English hunspell dictionaries
AddPackage keyd               # A key remapping daemon for linux
AddPackage kicad              # Electronic schematic and printed circuit board (PCB) design tools
AddPackage kicad-library      # KiCad symbol, footprint and template libraries
AddPackage kicad-library-3d   # KiCad 3D model libraries
AddPackage kitty              # A modern, hackable, featureful, OpenGL-based terminal emulator
AddPackage lazygit            # Simple terminal UI for git commands
AddPackage lf                 # A terminal file manager inspired by ranger
AddPackage libreoffice-fresh  # LibreOffice branch which contains new features and program enhancements
AddPackage lieer              # Fast fetch and two-way tag synchronization between notmuch and GMail
AddPackage lshw               # A small tool to provide detailed information on the hardware configuration of the machine.
AddPackage lynx               # A text browser for the World Wide Web
AddPackage mediainfo          # Supplies technical and tag information about media files (CLI interface)
AddPackage most               # A terminal pager similar to 'more' and 'less'
AddPackage mpv                # a free, open source, and cross-platform media player
AddPackage msmtp-mta          # A mini SMTP client - the regular MTA
AddPackage ncmpcpp            # Featureful ncurses based MPD client inspired by ncmpc
AddPackage nerdfix            # nerdfix helps you to find/fix obsolete Nerd Font icons in your project.
AddPackage nmap               # Utility for network discovery and security auditing
AddPackage obsidian           # A powerful knowledge base that works on top of a local folder of plain text Markdown files
AddPackage ouch               # A command line utility for easily compressing and decompressing files and directories
AddPackage pass               # Stores, retrieves, generates, and synchronizes passwords securely
AddPackage perl-image-exiftool # Read and write EXIF information
AddPackage playerctl          # mpris media player controller and lib for spotify, vlc, audacious, bmp, xmms2, and others.
AddPackage python-pywalfox # Native app used alongside the Pywalfox browser extension
AddPackage ranger             # Simple, vim-like file manager
AddPackage sesh-bin           # Smart session manager for the terminal
AddPackage simple-mtpfs       # A FUSE filesystem that supports reading/writing from MTP devices
AddPackage solaar # Linux device manager for a wide range of Logitech devices
AddPackage starship # The cross-shell prompt for astronauts
AddPackage tmux               # Terminal multiplexer
AddPackage trash-cli # Command line trashcan (recycle bin) interface
AddPackage tree-sitter        # Incremental parsing library
AddPackage ttf-monaspace-variable # An innovative superfamily of fonts for code, by GitHub
AddPackage udiskie            # Removable disk automounter using udisks
AddPackage ueberzugpp         # Command line utility which allows to display images in the terminal, written in C++
AddPackage urlscan # Mutt and terminal url selector
AddPackage urlview # A curses URL parser for text files
AddPackage vivid              # LS_COLORS manager with multiple themes
AddPackage w3m # Text-based Web browser as well as pager
AddPackage wezterm-git        # A terminal emulator implemented in Rust, using OpenGL ES 2 for rendering.
AddPackage yazi               # Blazing fast terminal file manager written in Rust, based on async I/O
AddPackage yt-dlp             # A youtube-dl fork with additional features and fixes
AddPackage xdg-ninja-git # A shell script which checks your $HOME for unwanted files and directories.
AddPackage zathura            # Minimalistic document viewer
AddPackage zathura-pdf-mupdf  # PDF support for Zathura (MuPDF backend) (Supports PDF, ePub, and OpenXPS)
AddPackage zen-browser-bin    # Performance oriented Firefox-based web browser
AddPackage zoxide             # A smarter cd command for your terminal

AddGroup docker '!*' 972

CopyFile /etc/bash_completion.d/sesh-completion.bash
CopyFile /etc/keyd/default.conf
CopyFile /etc/systemd/user/tmux@.service

# Gnome Keyring - Dependencies of  bitwarden
CreateLink /etc/systemd/user/sockets.target.wants/gnome-keyring-daemon.socket /usr/lib/systemd/user/gnome-keyring-daemon.socket
