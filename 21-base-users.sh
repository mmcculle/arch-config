#!/usr/bin/env bash

#Stores Base Users
AddUser root '!' 0 0 '' '' /root /usr/bin/zsh root ''
AddUser bin '!*' 1 1 '!*' '' / /usr/bin/nologin sys,daemon ''
AddUser daemon '!*' 2 2 '!*' '' / /usr/bin/nologin adm,bin ''
AddUser mail '!*' 8 12 '!*' '' /var/spool/mail /usr/bin/nologin '' ''
AddUser ftp '!*' 14 11 '!*' '' /srv/ftp /usr/bin/nologin '' ''
AddUser http '!*' 33 33 '!*' '' /srv/http /usr/bin/nologin '' ''
AddUser uuidd '!*' 68 68 '!*' '' / /usr/bin/nologin '' 1
AddUser dbus '!*' 81 81 '!*' 'System Message Bus' / /usr/bin/nologin '' ''
AddUser polkitd '!*' 102 102 '!*' 'User for polkitd' / /usr/bin/nologin '' ''
AddUser alpm '!*' 968 968 '!*' 'Arch Linux Package Management' / /usr/bin/nologin '' ''
AddUser git '!*' 970 970 '!*' 'git daemon user' / /usr/bin/git-shell '' ''
AddUser tss '!*' 974 974 '!*' 'tss user for tpm2' / /usr/bin/nologin '' ''
AddUser systemd-timesync '!*' 975 975 '!*' 'systemd Time Synchronization' / /usr/bin/nologin '' 1
AddUser systemd-resolve '!*' 976 976 '!*' 'systemd Resolver' / /usr/bin/nologin '' 1
AddUser systemd-journal-remote '!*' 977 977 '!*' 'systemd Journal Remote' / /usr/bin/nologin '' 1
AddUser systemd-oom '!*' 978 978 '!*' 'systemd Userspace OOM Killer' / /usr/bin/nologin '' 1
AddUser systemd-network '!*' 979 979 '!*' 'systemd Network Management' / /usr/bin/nologin '' 1
AddUser systemd-coredump '!*' 980 980 '!*' 'systemd Core Dumper' / /usr/bin/nologin '' 1
AddUser nobody '!*' 65534 65534 '!*' 'Kernel Overflow User' / /usr/bin/nologin '' 1

# DNS service used by several programs
AddUser avahi '!*' 971 971 '!*' 'Avahi mDNS/DNS-SD daemon' / /usr/bin/nologin '' ''

# Normal users
if [[ "$_system_id" == "$_swordfish2_ID" ]]; then
	AddUser mmcculle "$(getpassword mmcculle)" 1000 1000 '!' '' /home/mmcculle /usr/bin/zsh wheel ''
	cat >"$(CreateFile /etc/subgid)" <<EOF
mmcculle:100000:65536
EOF
	cat >"$(CreateFile /etc/subuid)" <<EOF
mmcculle:100000:65536
EOF
fi

# Base Groups
AddGroup sys '!*' 3
AddGroup tty '!*' 5
AddGroup mem '!*' 8
AddGroup log '!*' 19
AddGroup smmsp '!*' 25
AddGroup proc '!*' 26
AddGroup games '!*' 50
AddGroup lock '!*' 54
AddGroup network '!*' 90
AddGroup floppy '!*' 94
AddGroup scanner '!*' 96
AddGroup power '!*' 98
AddGroup adm '!*' 999
AddGroup wheel '!*' 998
AddGroup utmp '!*' 997
AddGroup audio '!*' 996
AddGroup disk '!*' 995
AddGroup input '!*' 994
AddGroup kmem '!*' 993
AddGroup kvm '!*' 992
AddGroup lp '!*' 991
AddGroup optical '!*' 990
AddGroup render '!*' 989
AddGroup sgx '!*' 988
AddGroup storage '!*' 987
AddGroup uucp '!*' 986
AddGroup video '!*' 985
AddGroup users '!*' 984
AddGroup groups '!*' 983
AddGroup systemd-journal '!*' 982
AddGroup rfkill '!*' 981
AddGroup adbusers '!*' 973
AddGroup clock '!*' 967

CreateFile /etc/subgid- >/dev/null
CreateFile /etc/subuid- >/dev/null
