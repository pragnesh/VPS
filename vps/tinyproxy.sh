# ------------------------------------------------------------ #
# VPS Management : TinyProxy
# ------------------------------------------------------------ #

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
  fi
}

options=("${options[@]}" "tinyproxy (Light-weight HTTP/HTTPS proxy)")

