#!/bin/sh

apt-get purge libsunpinyin* fcitx-sunpinyin sunpinyin-data -y
apt-get install fcitx-googlepinyin -y
