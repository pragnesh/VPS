# ------------------------------------------------------------ #
# VPS Management : Domain
# ------------------------------------------------------------ #

domain() {
  if [ -z "$1" ]; then
    die "Check usage!"
  fi

  if [ -d "/var/www/$1" ]; then
    die "Site $1 already exists!"
  fi

  mkdir -p /var/www/$1/{logs,public_html}

  cat > /var/www/$1/public_html/default.html <<EOF
<p>Welcome to <strong>$1</strong>'s default placeholder!</p>
EOF
  cat > /var/www/$1/public_html/phpInfo.php <<EOF
<?php phpinfo();
EOF

  chown root:root -R /var/www/$1

  if [ -e /etc/apache2 ]; then

    cat > /etc/apache2/sites-available/$1 <<EOF
<VirtualHost *:80>
  ServerName $1
  ServerAlias www.$1
  DocumentRoot /var/www/$1/public_html
  DirectoryIndex index.html index.php default.html
  ErrorLog /var/www/$1/logs/error.log
  CustomLog /var/www/$1/logs/access.log combined

  FastCgiServer /var/www/php5.external -host 127.0.0.1:9000
  AddHandler php5-fcgi .php
  Action php5-fcgi /user/lib/cgi-bin/php5.external
  Alias /user/lib/cgi-bin /var/www/

</VirtualHost>
EOF
    a2ensite $1

  fi

  if [ -e /etc/nginx ]; then

    cat > /etc/nginx/sites-available/$1 <<EOF
server {
  server_name $1;
  listen 80;

  root /var/www/$1/public_html;

  access_log /var/www/$1/logs/access.log;
  error_log /var/www/$1/logs/error.log;

  index index.html index.php default.html;

  location / {
    try_files $uri $uri/ @rewrites;
  }

  location @rewrites {
    rewrite ^ /index.php last;
  }

  location ~ \.php$ {
    include /etc/nginx/fastcgi_params;
    fastcgi_pass 127.0.0.1:9000;
  }
}
EOF
    ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/$1

  fi

  if ps -C apache2 > /dev/null; then
    service apache2 restart
  fi

  if ps -C nginx > /dev/null; then
    service nginx restart
  fi
}

options=("${options[@]}" "domain <[subdomain.]domain.tld>")
