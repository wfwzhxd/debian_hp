#/bin/sh
binary=/usr/local/bin/hibernate

cat - > $binary << EOF
#!/bin/bash
apstop
xscreensaver-command -lock
sync && cd /sys/power && /bin/echo shutdown > disk && /bin/echo disk > state
EOF

chmod +x $binary

exit
# TODO
# config grub
swap=`cat /etc/fstab | grep swap | grep -v "#" | cut -d" " -f1`
[ "$swap" = "" ] && echo "Error: Swap partation not found in /etc/fstab" && exit 1

