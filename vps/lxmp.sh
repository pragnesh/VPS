# ------------------------------------------------------------ #
# VPS Management : Apache/nginx, MySQL, PHP
# ------------------------------------------------------------ #

apache() {
  # Stop & disable nginx if needed
  if ps -C nginx > /dev/null; then
    service nginx stop
    update-rc.d -f nginx remove
  fi

  if ! apt_installed apache2; then

    apt_install apache2
	cp /etc/apache2/conf.d/security /etc/apache2/conf.d/security.bak
    sed -i 's/^ServerTokens .*/ServerTokens Prod/' /etc/apache2/conf.d/security
    ok 'apache installed and setup.\n'

  else
	update-rc.d apache2 defaults
	service apache2 start
  fi
}

nginx() {
  # Stop & disable apache if needed
  if ps -C apache2 > /dev/null; then
    service apache2 stop
    update-rc.d -f apache2 remove
  fi

  if ! apt_installed nginx; then

    apt_install nginx
	cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
    sed -i 's/worker_processes [0-9]*/worker_processes 2/' /etc/nginx/nginx.conf
    sed -i 's/\#\s*server_tokens off;/server_tokens off;/' /etc/nginx/nginx.conf
    sed -i 's/worker_connections [0-9]*/worker_connections 1024/' /etc/nginx/nginx.conf

	service nginx start
    ok 'nginx installed and setup.\n'

  else
	update-rc.d nginx defaults
    service nginx start
  fi
}


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

  else
    service mysql start
  fi
}

lamp() {
  apache
#  mysql
}

lemp() {
  nginx
#  mysql
}

options=("${options[@]}" "lamp (Apache/MySQL/PHP)" "lemp (nginx/MySQL/PHP)")
