#!/bin/sh

config=/etc/apt/sources.list
url="deb http://httpredir.debian.org/debian/ jessie main contrib non-free"
grep "$url" $config > /dev/null 2>&1
if [ $? -ne 0 ]
then
	echo >> $config
	echo "# wifi" >> $config
	echo "$url" >> $config
fi

# Do we really need "firmware-iwlwifi" ?
apt-get update && apt-get install firmware-iwlwifi firmware-ralink -y
modprobe -r iwlwifi ; modprobe iwlwifi
