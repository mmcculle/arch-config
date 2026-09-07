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

# Hyprland DMS
AddPackage adw-gtk-theme # Unofficial GTK 3 port of the libadwaita theme
AddPackage brightnessctl # Lightweight brightness control tool
AddPackage cliphist # wayland clipboard manager
AddPackage dankcalendar-bin # Local, Google, Microsoft, and CalDAV calendars for the dank desktop (prebuilt binary)
AddPackage dex # Program to generate and execute DesktopEntry files of type Application
AddPackage dms-shell-hyprland # A Quickshell-based desktop shell with Material 3 design principles (for Hyprland)
AddPackage dolphin # KDE File Manager
AddPackage dsearch-bin # Fast filesystem search service
AddPackage greetd-dms-greeter-bin # DankMaterialShell greeter for greetd (binary release)
AddPackage hyprland # a highly customizable dynamic tiling Wayland compositor
AddPackage hyprpolkitagent # Simple polkit authentication agent for Hyprland, written in QT/QML
AddPackage libappindicator # Allow applications to extend a menu via Ayatana indicators in Unity, KDE or Systray
AddPackage matugen-bin # A material you and base16 color generation tool with templates
AddPackage papirus-icon-theme # Papirus icon theme
AddPackage qt6ct-kde # Qt 6 Configuration Utility, patched to work correctly with KDE applications
AddPackage quickshell # Flexible toolkit for making desktop shells with QtQuick
AddPackage swayimg # A lightweight image viewer for Wayland display servers
AddPackage wl-clipboard # Command-line copy/paste utilities for Wayland
AddPackage wofi # launcher for wlroots-based wayland compositors
AddPackage xdg-desktop-portal-hyprland # xdg-desktop-portal backend for hyprland

AddUser greeter '!*' 963 963 '!*' 'greetd greeter user' / /bin/bash video ''
AddGroup seat '!*' 964

CopyFile /etc/pam.d/dankshell
CopyFile /etc/pam.d/dankshell-u2f

cat >"$(CreateFile /etc/greetd/hypr.lua)" <<'EOF'
hl.env("DMS_RUN_GREETER", "1")

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.config({
  misc = {
    disable_hyprland_logo = true,
  },
})
EOF

sed -i \
  '/^command/c\command = "/usr/bin/dms-greeter --command hyprland --config /etc/greetd/hypr.lua --cache-dir /var/cache/dms-greeter"' \
  "$(GetPackageOriginalFile greetd /etc/greetd/config.toml)"

CreateLink /etc/systemd/system/display-manager.service /usr/lib/systemd/system/greetd.service

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
CreateLink /etc/fonts/conf.d/46-noto-sans.conf /usr/share/fontconfig/conf.default/46-noto-sans.conf
CreateLink /etc/fonts/conf.d/46-noto-serif.conf /usr/share/fontconfig/conf.default/46-noto-serif.conf
CreateLink /etc/fonts/conf.d/48-guessfamily.conf /usr/share/fontconfig/conf.default/48-guessfamily.conf
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
CreateLink /etc/fonts/conf.d/66-noto-sans.conf /usr/share/fontconfig/conf.default/66-noto-sans.conf
CreateLink /etc/fonts/conf.d/66-noto-serif.conf /usr/share/fontconfig/conf.default/66-noto-serif.conf
CreateLink /etc/fonts/conf.d/69-unifont.conf /usr/share/fontconfig/conf.default/69-unifont.conf
CreateLink /etc/fonts/conf.d/69-urw-bookman.conf /usr/share/fontconfig/conf.default/69-urw-bookman.conf
CreateLink /etc/fonts/conf.d/69-urw-c059.conf /usr/share/fontconfig/conf.default/69-urw-c059.conf
CreateLink /etc/fonts/conf.d/69-urw-d050000l.conf /usr/share/fontconfig/conf.default/69-urw-d050000l.conf
CreateLink /etc/fonts/conf.d/69-urw-fallback-backwards.conf /usr/share/fontconfig/conf.default/69-urw-fallback-backwards.conf
CreateLink /etc/fonts/conf.d/69-urw-fallback-generics.conf /usr/share/fontconfig/conf.default/69-urw-fallback-generics.conf
CreateLink /etc/fonts/conf.d/69-urw-fallback-specifics.conf /usr/share/fontconfig/conf.default/69-urw-fallback-specifics.conf
CreateLink /etc/fonts/conf.d/69-urw-gothic.conf /usr/share/fontconfig/conf.default/69-urw-gothic.conf
CreateLink /etc/fonts/conf.d/69-urw-nimbus-mono-ps.conf /usr/share/fontconfig/conf.default/69-urw-nimbus-mono-ps.conf
CreateLink /etc/fonts/conf.d/69-urw-nimbus-roman.conf /usr/share/fontconfig/conf.default/69-urw-nimbus-roman.conf
CreateLink /etc/fonts/conf.d/69-urw-nimbus-sans.conf /usr/share/fontconfig/conf.default/69-urw-nimbus-sans.conf
CreateLink /etc/fonts/conf.d/69-urw-p052.conf /usr/share/fontconfig/conf.default/69-urw-p052.conf
CreateLink /etc/fonts/conf.d/69-urw-standard-symbols-ps.conf /usr/share/fontconfig/conf.default/69-urw-standard-symbols-ps.conf
CreateLink /etc/fonts/conf.d/69-urw-z003.conf /usr/share/fontconfig/conf.default/69-urw-z003.conf
CreateLink /etc/fonts/conf.d/75-yes-terminus.conf /usr/share/fontconfig/conf.default/75-yes-terminus.conf
CreateLink /etc/fonts/conf.d/80-delicious.conf /usr/share/fontconfig/conf.default/80-delicious.conf
CreateLink /etc/fonts/conf.d/90-synthetic.conf /usr/share/fontconfig/conf.default/90-synthetic.conf
