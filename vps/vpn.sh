# ------------------------------------------------------------ #
# VPS Management : VPN / PPTP
# ------------------------------------------------------------ #

pptp() {

  if ! apt_installed pptpd; then

    if [ `cat /dev/ppp 2>&1 | grep -c 'No such device or address'` == 0 ]; then
      die "Module PPP is not installed/correctly setup."
    fi

    apt_install 'pptpd iptables-persistent'

    IP=`ifconfig venet0:0 | awk '/inet addr/ {gsub("[^0-9.]","",$2); print $2}'`
    cat >> /etc/pptpd.conf <<EOF

localeip $IP
remoteip 192.168.100.1-100
EOF

    sed -i '/#ms-dns/,/^$/ s/^$/ms-dns 8.8.8.8\nms-dns 8.8.4.4\n/' /etc/ppp/pptpd-options

    input 'Choose and input your pptp login and password\nLogin'
    USER=$REPLY
    input 'Password'
    PASSWORD=$REPLY
    cat >> /etc/ppp/chap-secrets <<EOF
$USER	pptpd	$PASSWORD	*
EOF

    ok 'pptpd installed and setup.\n'
  else
    service pptpd restart
  fi
}

addModule "pptp (Tunneling)"
