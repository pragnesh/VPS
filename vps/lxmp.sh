# ------------------------------------------------------------ #
# VPS Management : Apache/nginx, MySQL, PHP
# ------------------------------------------------------------ #

mysql() {
  if ! apt_installed mysql; then

    cat > /usr/sbin/policy-rc.d <<EOF
#!/bin/sh
exit 101
EOF
    chmod +x /usr/sbin/policy-rc.d

    apt_install 'mysql-server mysql-client'

    rm /usr/sbin/policy-rc.d
    rm -f /var/lib/mysql/ib*
    cat > /etc/mysql/conf.d/$HOSTNAME.cnf <<EOF
[mysqld]
skip-innodb
EOF

    service mysql start
    ok 'MySQL installed and setup.\n'
  fi
}

lamp() {
  mysql
}

options=("${options[@]}" "lamp (Apache/MySQL/PHP)")

