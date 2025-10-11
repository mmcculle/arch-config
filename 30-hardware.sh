#!/usr/bin/env bash

AddPackage android-udev # Udev rules to connect Android devices to your linux box
AddPackage blueman      # GTK+ Bluetooth Manager
AddPackage bluez        # Daemons for the bluetooth protocol stack
AddPackage bluez-utils  # Development and debugging utilities for the bluetooth protocol stack
AddPackage cups         # OpenPrinting CUPS - daemon package
# Printer driver for cups
AddPackage brother-hl2270dw      # Brother HL-2270DW CUPS Driver
AddPackage system-config-printer # A CUPS printer configuration tool and status applet

AddPackage hwdetect # Hardware detection script with loading modules and mkinitcpio.conf

AddPackage network-manager-applet # Applet for managing network connections
AddPackage networkmanager         # Network connection manager and user applications
AddPackage piavpn-bin             # Private Internet Access client

AddPackage mesa       # Open-source OpenGL drivers
AddPackage mesa-utils # Essential Mesa utilities

if [[ $(GetNvidiaModel) -ge 1650 ]]; then
	AddPackage nvidia-open-dkms # NVIDIA open kernel modules - module sources (Requires dkms and headers)
elif [[ $(GetNvidiaModel) -gt 0 ]]; then
	AddPackage nvidia-dkms # NVIDIA kernel modules - module sources (Requires dkms and headers)
fi

if [[ $(GetNvidiaModel) -gt 0 ]]; then
	AddPackage nvidia-prime # NVIDIA Prime Render Offload configuration and utilities
	AddUser nvidia-persistenced '!*' 143 143 '!*' 'NVIDIA Persistence Daemon' / /usr/bin/nologin '' 1
fi

AddPackage helvum         # GTK patchbay for PipeWire
AddPackage pipewire-alsa  # Low-latency audio/video router and processor - ALSA configuration
AddPackage pipewire-pulse # Low-latency audio/video router and processor - PulseAudio replacement
AddPackage pavucontrol    # PulseAudio Volume Control

AddPackage powertop # A tool to diagnose issues with power consumption and power management

AddUser cups '!*' 209 209 '!*' 'cups helper user' / /usr/bin/nologin lp 1

AddGroup piavpn '!' 1001
AddGroup piahnsd '!' 1002

AconfNeedProgram hwdetect hwdetect N

f_mkinitcipo_conf="$(GetPackageOriginalFile mkinitcpio /etc/mkinitcpio.conf)"

_tmpfile="$(mktemp)"
awk -v modules="$(hwdetect --filesystem --hostcontroller)" \
	-v hooks="$(hwdetect --rootdevice="$(findmnt --noheadings --output SOURCE /)" --systemd)" \
	'/^HOOKS=/ {print hooks; next} /^MODULES=/ {print modules; next} 1' \
	"$f_mkinitcipo_conf" >"$_tmpfile" && mv "$_tmpfile" "$f_mkinitcipo_conf"
unset _tmpfile

if IsLaptop; then
	sed -i '/^HOOKS/ s/\(^HOOKS.* \)\(autodetect.* \)\(keyboard \)\(.*\)/\1\3\2\4/' "$f_mkinitcipo_conf"
fi

if IsLaptop && IsIntelGPU; then
	AppendArrayInFile "$f_mkinitcipo_conf" MODULES i915
fi

if [[ $(GetNvidiaModel) -gt 0 ]]; then
	_nvidia_modules=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
	AppendArrayInFile "$f_mkinitcipo_conf" MODULES "${_nvidia_modules[@]}"
	unset _nvidia_modules
	CreateLink /etc/systemd/system/systemd-hibernate.service.wants/nvidia-hibernate.service /usr/lib/systemd/system/nvidia-hibernate.service
	CreateLink /etc/systemd/system/systemd-hibernate.service.wants/nvidia-resume.service /usr/lib/systemd/system/nvidia-resume.service
	CreateLink /etc/systemd/system/systemd-suspend.service.wants/nvidia-resume.service /usr/lib/systemd/system/nvidia-resume.service
	CreateLink /etc/systemd/system/systemd-suspend.service.wants/nvidia-suspend.service /usr/lib/systemd/system/nvidia-suspend.service
fi

cat >"$(CreateFile /etc/mkinitcpio.d/linux.preset)" <<"EOF"
# mkinitcpio preset file for the 'linux' package

#ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
default_image="/boot/initramfs-linux.img"
#default_uki="/efi/EFI/Linux/arch-linux.efi"
#default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
fallback_image="/boot/initramfs-linux-fallback.img"
#fallback_uki="/efi/EFI/Linux/arch-linux-fallback.efi"
fallback_options="-S autodetect"
EOF

cat >"$(CreateFile /etc/iproute2/rt_tables)" <<"EOF"
#
# reserved values
#
255	local
254	main
253	default
0	unspec
#
# local
#
#1	inr.ruhep
256	piavpnrt
257	piavpnOnlyrt
258	piavpnWgrt
259	piavpnFwdrt
EOF

CreateLink /etc/systemd/system/multi-user.target.wants/cups.path /usr/lib/systemd/system/cups.path
CreateLink /etc/systemd/system/multi-user.target.wants/cups.service /usr/lib/systemd/system/cups.service
CreateLink /etc/systemd/system/printer.target.wants/cups.service /usr/lib/systemd/system/cups.service
CreateLink /etc/systemd/system/sockets.target.wants/cups.socket /usr/lib/systemd/system/cups.socket

CreateLink /etc/systemd/system/multi-user.target.wants/NetworkManager.service /usr/lib/systemd/system/NetworkManager.service
CreateLink /etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service /usr/lib/systemd/system/NetworkManager-dispatcher.service
CreateLink /etc/systemd/system/network-online.target.wants/NetworkManager-wait-online.service /usr/lib/systemd/system/NetworkManager-wait-online.service

CreateLink /etc/systemd/system/multi-user.target.wants/piavpn.service /usr/lib/systemd/system/piavpn.service

CreateLink /etc/systemd/user/sockets.target.wants/pipewire.socket /usr/lib/systemd/user/pipewire.socket
CreateLink /etc/systemd/user/sockets.target.wants/pipewire-pulse.socket /usr/lib/systemd/user/pipewire-pulse.socket
CreateLink /etc/systemd/user/pipewire-session-manager.service /usr/lib/systemd/user/wireplumber.service
CreateLink /etc/systemd/user/pipewire.service.wants/wireplumber.service /usr/lib/systemd/user/wireplumber.service
