#!/bin/sh

# This script is used to make debian/ubuntu support ap for android and other wireless device
# After it succeed, the command "apstart" is used to start AP
#								"apstop"  is used to stop AP

# config
net_interface=eth0			# the interface used to connect to Internet
ap_interface=wlan0			# the interface used to act as AP
ap_ssid=YOUR_AP_NAME		# the ssid of your ap
ap_passwd=XIANGDONG427		# the password of your ap

# remove older config for "fresh install"
#apt-get purge hostapd isc-dhcp-server

apt-get install hostapd isc-dhcp-server -y || exit 1

# configure hostapd
cat - > /etc/hostapd/hostapd.conf <<EOF
interface=$ap_interface
driver=nl80211
ssid=$ap_ssid
hw_mode=g
channel=10
macaddr_acl=0
auth_algs=3
wpa=2
wpa_passphrase=$ap_passwd
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
rsn_pairwise=TKIP CCMP
EOF

# configure dhcpd
# TODO should I must check if the same subnet have already exist?
cat - >> /etc/dhcp/dhcpd.conf <<EOF
subnet 192.168.0.0 netmask 255.255.255.0
{
range 192.168.0.2 192.168.0.10;
option routers 192.168.0.1;
option domain-name-servers 192.168.0.1,180.76.76.76,8.8.8.8;
}
EOF

# configure apstart command
cat - > /usr/local/bin/apstart <<EOF
# 开启内核IP转发
bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
iptables -t nat -A POSTROUTING -o $net_interface -j MASQUERADE
# 关闭NetworkManager对无线网卡的控制
service network-manager stop
#nmcli wifi off
# 设置并启动无线网卡
ifconfig wlan0 192.168.0.1 netmask 255.255.255.0
# 解锁无线设备,可以用rfkill list查看解锁结果.
rfkill unblock wifi
# 睡眠3秒,待rfkill解锁生效
sleep 3s
# 启动dhcpd和hostapd,如果hostapd无法启动请查看日志hostapd.log,查看这两个进程ps -ef|egrep "dhcpd|hostapd"
dhcpd wlan0 -pf /var/run/dhcpd.pid
ps -ef|head -n1 && ps -ef|egrep "dhcpd|hostapd"
hostapd -d /etc/hostapd/hostapd.conf > /var/log/linux-ap.log 2>&1 &
EOF

chmod +x /usr/local/bin/apstart

# configure apstop command
cat - > /usr/local/bin/apstop <<EOF
killall hostapd dhcpd
bash -c "echo 0 > /proc/sys/net/ipv4/ip_forward"
service network-manager start
EOF

chmod +x /usr/local/bin/apstop

