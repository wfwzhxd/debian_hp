#!/bin/sh

# Iceweasel is confilict with firefox
# so make a little "hack"
[ -e /usr/bin/firefox ] && mv /usr/bin/firefox /usr/bin/firefox.iceweasel
config=/etc/apt/sources.list
url="deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main"
grep "$url" $config > /dev/null 2>&1
if [ $? -ne 0 ]
then
	echo >> $config
	echo "# firefox" >> $config
	echo "$url" >> $config
fi
apt-get update && apt-get install firefox-mozilla-build -y --force-yes
