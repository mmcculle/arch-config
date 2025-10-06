#!/usr/bin/env bash

# Common
AddPackage noto-fonts-cjk              # Google Noto CJK fonts
AddPackage noto-fonts-emoji            # Google Noto Color Emoji font
AddPackage terminus-font               # Monospace bitmap font (for X11 and console)
AddPackage ttf-caladea                 # A serif font family metric-compatible with Cambria font family
AddPackage ttf-carlito                 # Google's Carlito font
AddPackage ttf-firacode-nerd           # Patched font Fira (Fura) Code from nerd fonts library
AddPackage ttf-jetbrains-mono          # Typeface for developers, by JetBrains
AddPackage ttf-jetbrains-mono-nerd     # Patched font JetBrains Mono from nerd fonts library
AddPackage ttf-meslo-nerd              # Patched font Meslo LG from nerd fonts library
AddPackage ttf-nerd-fonts-symbols      # High number of extra glyphs from popular 'iconic fonts'
AddPackage ttf-nerd-fonts-symbols-mono # High number of extra glyphs from popular 'iconic fonts' (monospace)
AddPackage ttf-noto-nerd               # Patched font Noto from nerd fonts library

# Xorg
AddPackage dunst            # Customizable and lightweight notification-daemon
AddPackage betterlockscreen # A simple, minimal lockscreen
AddPackage bspwm            # Tiling window manager based on binary space partitioning
AddPackage feh              # Fast and light imlib2-based image viewer
AddPackage geoclue          # Modular geoinformation service built on the D-Bus messaging system
AddPackage picom            # Lightweight compositor for X11
AddPackage polybar          # A fast and easy-to-use status bar
AddPackage redshift         # Adjusts the color temperature of your screen according to your surroundings.
AddPackage stalonetray      # STAnd-aLONE sysTRAY. It has minimal build and run-time dependencies: the Xlib only.
AddPackage sxhkd            # Simple X hotkey daemon
AddPackage sxiv             # Simple X Image Viewer
AddPackage tdrop-git        # A WM-Independent dropdown window and terminal creator
AddPackage unclutter        # A small program for hiding the mouse cursor
AddPackage xcape            # Configure modifier keys to act as other keys when pressed and released on their own
AddPackage xclip            # Command line interface to the X11 clipboard
AddPackage xdo              # Utility for performing actions on windows in X
AddPackage xorg-server      # Xorg X server
AddPackage xorg-xbacklight  # RandR-based backlight control application
AddPackage xorg-xhost       # Server access control program for X
AddPackage xorg-xinit       # X.Org initialisation program
AddPackage xorg-xinput      # Small commandline tool to configure devices
AddPackage xorg-xset        # User preference utility for X
AddPackage xss-lock         # Use external locker as X screen saver

AddUser geoclue '!*' 969 969 '!*' 'Geoinformation service' /var/lib/geoclue /usr/bin/nologin '' ''

# Font Conf
CreateLink /etc/fonts/conf.d/10-hinting-slight.conf /usr/share/fontconfig/conf.default/10-hinting-slight.conf
CreateLink /etc/fonts/conf.d/10-scale-bitmap-fonts.conf /usr/share/fontconfig/conf.default/10-scale-bitmap-fonts.conf
CreateLink /etc/fonts/conf.d/10-yes-antialias.conf /usr/share/fontconfig/conf.default/10-yes-antialias.conf
CreateLink /etc/fonts/conf.d/11-lcdfilter-default.conf /usr/share/fontconfig/conf.default/11-lcdfilter-default.conf
CreateLink /etc/fonts/conf.d/20-unhint-small-vera.conf /usr/share/fontconfig/conf.default/20-unhint-small-vera.conf
CreateLink /etc/fonts/conf.d/30-metric-aliases.conf /usr/share/fontconfig/conf.default/30-metric-aliases.conf
CreateLink /etc/fonts/conf.d/40-nonlatin.conf /usr/share/fontconfig/conf.default/40-nonlatin.conf
CreateLink /etc/fonts/conf.d/45-generic.conf /usr/share/fontconfig/conf.default/45-generic.conf
CreateLink /etc/fonts/conf.d/45-latin.conf /usr/share/fontconfig/conf.default/45-latin.conf
CreateLink /etc/fonts/conf.d/46-noto-mono.conf /usr/share/fontconfig/conf.default/46-noto-mono.conf
CreateLink /etc/fonts/conf.d/46-noto-sans.conf /usr/share/fontconfig/conf.default/46-noto-sans.conf
CreateLink /etc/fonts/conf.d/46-noto-serif.conf /usr/share/fontconfig/conf.default/46-noto-serif.conf
CreateLink /etc/fonts/conf.d/48-spacing.conf /usr/share/fontconfig/conf.default/48-spacing.conf
CreateLink /etc/fonts/conf.d/49-sansserif.conf /usr/share/fontconfig/conf.default/49-sansserif.conf
CreateLink /etc/fonts/conf.d/50-user.conf /usr/share/fontconfig/conf.default/50-user.conf
CreateLink /etc/fonts/conf.d/51-local.conf /usr/share/fontconfig/conf.default/51-local.conf
CreateLink /etc/fonts/conf.d/60-generic.conf /usr/share/fontconfig/conf.default/60-generic.conf
CreateLink /etc/fonts/conf.d/60-latin.conf /usr/share/fontconfig/conf.default/60-latin.conf
CreateLink /etc/fonts/conf.d/62-caladea.conf /usr/share/fontconfig/conf.default/62-caladea.conf
CreateLink /etc/fonts/conf.d/62-carlito.conf /usr/share/fontconfig/conf.default/62-carlito.conf
CreateLink /etc/fonts/conf.d/65-fonts-persian.conf /usr/share/fontconfig/conf.default/65-fonts-persian.conf
CreateLink /etc/fonts/conf.d/65-nonlatin.conf /usr/share/fontconfig/conf.default/65-nonlatin.conf
CreateLink /etc/fonts/conf.d/66-noto-mono.conf /usr/share/fontconfig/conf.default/66-noto-mono.conf
CreateLink /etc/fonts/conf.d/66-noto-sans.conf /usr/share/fontconfig/conf.default/66-noto-sans.conf
CreateLink /etc/fonts/conf.d/66-noto-serif.conf /usr/share/fontconfig/conf.default/66-noto-serif.conf
CreateLink /etc/fonts/conf.d/69-unifont.conf /usr/share/fontconfig/conf.default/69-unifont.conf
CreateLink /etc/fonts/conf.d/75-yes-terminus.conf /usr/share/fontconfig/conf.default/75-yes-terminus.conf
CreateLink /etc/fonts/conf.d/80-delicious.conf /usr/share/fontconfig/conf.default/80-delicious.conf
CreateLink /etc/fonts/conf.d/90-synthetic.conf /usr/share/fontconfig/conf.default/90-synthetic.conf
