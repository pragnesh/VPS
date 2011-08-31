# ------------------------------------------------------------ #
# VPS Management : Setup
#  - hostname
#  - timezone
#  - apt sources (+DotDeb)
#  - apt update
# ------------------------------------------------------------ #

setup() {
  HOSTNAME=`cat /etc/hostname`
  if ! confirm "Confirm or input new hostname" $HOSTNAME; then
    echo $REPLY > /etc/hostname
    hostname -F /etc/hostname
  fi

  TIMEZONE=`cat /etc/timezone`
  if ! confirm "Confirm or input new timezone" $TIMEZONE; then
    echo $REPLY > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
  fi

  if ! grep -q "^# Tiger's Way" ~/.profile; then
    cat >> ~/.profile <<EOF

# Tiger's Way
alias ls='ls --color=auto'
PS1='\e[33m[\A]\u@\h:\w\\$\e[m '

EOF
  fi

  if ! grep -q "^# Tiger's Way" /etc/apt/sources.list; then

    if confirm 'Confirm or input new country mirror' 'us'; then
      REPLY='us'
    fi
    cat > /etc/apt/sources.list <<EOF
# Tiger's Way
deb http://ftp.$REPLY.debian.org/debian/ squeeze main
deb http://security.debian.org/ squeeze/updates main
deb http://ftp.$REPLY.debian.org/debian/ squeeze-proposed-updates main
EOF
  fi

  if [ ! -e /etc/apt/sources.list.d/dotdeb.list ]; then
    if yesno 'Would you like to add DotDeb as a source' 'Y'; then
      cat > /etc/apt/sources.list.d/dotdeb.list <<EOF
deb http://packages.dotdeb.org/ squeeze all
EOF
      wget -q -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -
    fi
  fi

  apt_update
}
