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

    apt_install 'apache2 libapache2-mod-fastcgi'
    a2dissite default
    a2enmod rewrite

    cp /etc/apache2/conf.d/{security,security.bak}
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

    cp /etc/nginx/{nginx.conf,nginx.conf.bak}
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

phpfpm() {
  if ! apt_installed php5-fpm; then

    apt_install 'php5-fpm php5-mysql php5-sqlite php5-apc php5-gd php5-mcrypt'

    sed -i 's/^pm.max_children.*/pm.max_children = 8/' /etc/php5/fpm/pool.d/www.conf
    sed -i 's/^pm.start_servers.*/pm.start_servers = 2/' /etc/php5/fpm/pool.d/www.conf
    sed -i 's/^pm.min_spare_servers.*/pm.min_spare_servers = 2/' /etc/php5/fpm/pool.d/www.conf
    sed -i 's/^pm.max_spare_servers.*/pm.max_spare_servers = 4/' /etc/php5/fpm/pool.d/www.conf
    sed -i 's/\;pm.max_requests.*/pm.max_requests = 1000/' /etc/php5/fpm/pool.d/www.conf

    service php5-fpm restart
    ok 'php5-fpm installed and setup.\n'

  else
    service php5-fpm restart
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
  phpfpm
}

lemp() {
  nginx
#  mysql
  phpfpm
}

options=("${options[@]}" "lamp (Apache/MySQL/PHP)" "lemp (nginx/MySQL/PHP)")
