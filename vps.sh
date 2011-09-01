# ------------------------------------------------------------ #
# VPS Management : Menu
# ------------------------------------------------------------ #
#!/bin/bash

echo -e "\e[1mVPS Management v0.1 (Tiger's Way)\e[m";

# Sanity checks

if [ -f /etc/debian_version ]; then
  VERSION=`cat /etc/debian_version`
  if [ ${VERSION:0:1} -lt 5 ]; then
    die "Debian $VERSION is not supported anymore"
  fi
else
  die "Unknown distribution. Only Debian is supported."
fi

[ $(id -g) != "0" ] && die "Must be run by a root allowed user"


# Load `Modules`

options=("setup (hostname, timezome, apt sources)" "system (LowEndBox style)")

for file in vps/*.sh
do
  source $file
done

if [ ! -z "$1" ]; then
  if [ `declare -F $1` ]; then
	$1
	exit 0
  fi
fi

echo 'Usage: '`basename $0`' option'
echo 'Available options:'
for option in "${options[@]}"
do
  echo " - $option "
done
