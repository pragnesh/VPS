# ------------------------------------------------------------ #
# VPS Management : Proxy
# ------------------------------------------------------------ #

polipo() {
  if ! apt_installed polipo; then
    apt_install polipo

    IPS=`who | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'`
    if ! confirm 'Confirm your IP only can access polipo.\n Or set which one(s)' $IPS; then
      IPS=$REPLY
    fi

    cp /etc/polipo/config /etc/polipo/config.bak
    cat > /etc/polipo/config <<EOF
proxyAddress = "0.0.0.0"    # IPv4 only
allowedClients = $IPS
EOF

    service polipo restart
    ok 'polipo installed and setup.\n'
  else
    service polipo restart
  fi
}

tinyproxy() {
  if ! apt_installed tinyproxy; then
    apt_install tinyproxy
    cp /etc/tinyproxy.conf /etc/tinyproxy.conf.bak
    cat > /etc/tinyproxy.conf <<EOF
User nobody
Group nogroup

#Listen 192.168.0.1
#Bind 192.168.0.1
Port 8888

DefaultErrorFile "/usr/share/tinyproxy/default.html"
StatFile "/usr/share/tinyproxy/stats.html"
Logfile "/var/log/tinyproxy/tinyproxy.log"
PidFile "/var/run/tinyproxy/tinyproxy.pid"

MaxClients 100
MinSpareServers 5
MaxSpareServers 20
StartServers 10
MaxRequestsPerChild 0
Timeout 600

Allow 192.168.0.0/16

DisableViaHeader Yes
ConnectPort 443
ConnectPort 563
EOF

    service tinyproxy restart
    ok 'tinyproxy installed and setup.\n'
  else
    service tinyproxy restart
  fi
}

addModule "polipo (Light-weight SOCKS & HTTP proxy)"
addModule "tinyproxy (DEPRECATED Light-weight HTTP/HTTPS proxy)"
