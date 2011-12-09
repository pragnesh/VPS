# ------------------------------------------------------------ #
# VPS Management : Menu
# ------------------------------------------------------------ #
#!/bin/bash

echo -e "\e[1mVPS Management v0.3 (Tiger's Way)\e[m";

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

mainOptions=(
  "minimal (Light Debian server + SSH)"
  "basics (hostname, timezone, APT sources)"
  "lowendbox (LEA style: syslogd, xinetd, dropbear)"
)
tools=()

addModule(){
  tools=("${tools[@]}" "$1")
}

for file in vps/*.sh
do
  source $file
done

# Check if paramater(s), and corresponding function...
if [ ! -z "$1" ]; then
  if [ `declare -F $1` ]; then
	$@
	exit $?
  fi
fi

# if not, show available options
echo 'Usage: '`basename $0`' option'
echo 'Main options:'
for option in "${mainOptions[@]}"
do
  echo " - $option "
done
echo 'Other tools:'
for tool in "${tools[@]}"
do
  echo " - $tool "
done
echo
