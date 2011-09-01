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
<p>Welcome to the default placeholder for <strong>$1</strong></p>
EOF
  chown www-data:www-data -R /var/www/$1


  cat > /etc/nginx/sites-available/$1 <<EOF
server {
  server_name $1;
  listen 80;

  root /var/www/$1/public_html;

  access_log /var/www/$1/logs/access.log;
  error_log /var/www/$1/logs/error.log;

  index index.html default.html;
}
EOF
  ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/$1

  service nginx restart
}

options=("${options[@]}" "domain <[subdomain.]domain.tld>")
