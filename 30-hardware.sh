#!/usr/bin/env bash

AddPackage android-udev # Udev rules to connect Android devices to your linux box
AddPackage blueman      # GTK+ Bluetooth Manager
AddPackage bluez        # Daemons for the bluetooth protocol stack
AddPackage bluez-utils  # Development and debugging utilities for the bluetooth protocol stack
AddPackage cups         # OpenPrinting CUPS - daemon package
# Printer driver for cups
AddPackage brother-hl2270dw      # Brother HL-2270DW CUPS Driver
AddPackage system-config-printer # A CUPS printer configuration tool and status applet

AddPackage exfat-utils # Utilities for exFAT file system
AddPackage fwupd # Simple daemon to allow session software to update firmware
AddPackage hwdetect # Hardware detection script with loading modules and mkinitcpio.conf
AddPackage intel-media-driver # Intel Media Driver for VAAPI — Broadwell+ iGPUs
AddPackage libva-utils # Intel VA-API Media Applications and Scripts for libva
AddPackage power-profiles-daemon # Makes power profiles handling available over D-Bus
AddPackage sshfs # FUSE client based on the SSH File Transfer Protocol
AddPackage usbutils # A collection of USB tools to query connected USB devices

AddPackage ethtool # Utility for controlling network drivers and hardware
AddPackage impala # TUI for managing wifi
AddPackage iwd # Internet Wireless Daemon
AddPackage piavpn-bin             # Private Internet Access client
AddPackage wireguard-tools # next generation secure network tunnel - tools for configuration
AddPackage wireless-regdb # Central Regulatory Domain Database

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
AddPackage wiremix        # A simple TUI audio mixer for PipeWire

AddPackage powertop # A tool to diagnose issues with power consumption and power management

AddUser cups '!*' 209 209 '!*' 'cups helper user' / /usr/bin/nologin lp 1
AddUser fwupd '!*' 961 961 '!*' 'Firmware update daemon' /var/lib/fwupd /usr/bin/nologin '' 1
AddUser passim '!*' 960 960 '!*' 'Local Caching Server' /usr/share/empty /usr/bin/nologin '' ''

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

sed -i '/^HOOKS/s/\bsystemd\b/& plymouth/' "$f_mkinitcipo_conf"

if IsLaptop && IsIntelGPU; then
	AppendArrayInFile "$f_mkinitcipo_conf" MODULES i915
fi

if [[ $(GetNvidiaModel) -gt 0 ]]; then
	_nvidia_modules=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
	AppendArrayInFile "$f_mkinitcipo_conf" MODULES "${_nvidia_modules[@]}"
	unset _nvidia_modules
fi

cat >>"$(GetPackageOriginalFile fwupd /etc/fwupd/fwupd.conf)" <<'EOF'
[uefi_capsule]
DisableShimForSecureBoot=true
EOF

cat >"$(CreateFile /etc/iwd/main.conf)" <<'EOF'
[General]
EnableNetworkConfiguration=true
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

sed -i '/="US"/s/^#//' "$(GetPackageOriginalFile wireless-regdb /etc/conf.d/wireless-regdom)"

cat >"$(CreateFile /etc/systemd/network/25-wireless.network)" <<'EOF'
[Match]
Type=wlan
WLANInterfaceType=station
SSID=*

[Link]
RequiredForOnline=routable
Multicast=true

[Network]
DHCP=yes
IgnoreCarrierLoss=3s
MulticastDNS=true

[DHCPv4]
RouteMetric=600

[IPv6AcceptRA]
RouteMetric=600
EOF

sed -i -f - "$(GetPackageOriginalFile systemd /etc/systemd/resolved.conf)" <<'EOF'
/#MulticastDNS/ s/^#//
/LLMNR/ {
s/^#//
s/yes/no/
}
EOF

CopyFile /etc/udev/rules.d/10-intel-igpu-dev-path.rules
CopyFile /etc/udev/rules.d/11-nvidia-dgpu-dev-path.rules
CopyFile /etc/udev/rules.d/42-logitech-unify-permissions.rules

CreateLink /etc/systemd/system/multi-user.target.wants/cups.path /usr/lib/systemd/system/cups.path
CreateLink /etc/systemd/system/multi-user.target.wants/cups.service /usr/lib/systemd/system/cups.service
CreateLink /etc/systemd/system/printer.target.wants/cups.service /usr/lib/systemd/system/cups.service
CreateLink /etc/systemd/system/sockets.target.wants/cups.socket /usr/lib/systemd/system/cups.socket

CreateLink /etc/systemd/system/multi-user.target.wants/piavpn.service /usr/lib/systemd/system/piavpn.service

CreateLink /etc/systemd/user/sockets.target.wants/pipewire.socket /usr/lib/systemd/user/pipewire.socket
CreateLink /etc/systemd/user/sockets.target.wants/pipewire-pulse.socket /usr/lib/systemd/user/pipewire-pulse.socket
CreateLink /etc/systemd/user/pipewire-session-manager.service /usr/lib/systemd/user/wireplumber.service
CreateLink /etc/systemd/user/pipewire.service.wants/wireplumber.service /usr/lib/systemd/user/wireplumber.service
CreateLink /etc/systemd/system/graphical.target.wants/power-profiles-daemon.service /usr/lib/systemd/system/power-profiles-daemon.service
CreateLink /etc/systemd/system/graphical.target.wants/upower.service /usr/lib/systemd/system/upower.service
CreateLink /etc/systemd/system/multi-user.target.wants/iwd.service /usr/lib/systemd/system/iwd.service
