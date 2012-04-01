# ------------------------------------------------------------ #
# VPS Management : Tools
# ------------------------------------------------------------ #

# Fancy messages...

ok() { echo -e '\e[32m'$1'\e[m'; } # Green
info() { echo -e '\e[33m'$1'\e[m'; } # Yellow
debug() { echo -e '\e[35m'$1'\e[m'; } # Purple

die() { echo -e '\e[1;31m'$1'\e[m'; exit 1; }

bashtrap() { echo -e '\e[m'; exit 2; }
trap bashtrap 2

# ... and some generic functions

input() {
  echo -e -n '\e[36m'$1' : \e[1m'
  read
  echo -e -n '\e[m'
}

confirm() {
  echo -e -n '\e[36m'$1' [\e[1m'$2'\e[0;36m]: \e[1m'
  read
  echo -e -n '\e[m'

  return $([ -z "$REPLY" ])
}

yesno() {
  case $2 in
    [Yy]|[Yy][Ee][Ss]) DEFAULT=Y; MSGDEFAULT="[\e[1mY\e[0;36m/n]";;
    [Nn]|[Nn][Oo]) DEFAULT=N; MSGDEFAULT="[y/\e[1mN\e[0;36m]";;
  esac

  while :
  do
    echo -e -n '\e[36m'$1' '$MSGDEFAULT': \e[1m'
    read
    echo -e -n '\e[m'

    case $REPLY in
      [Yy]|[Yy][Ee][Ss]) return $([ $DEFAULT = Y ]);;
      [Nn]|[Nn][Oo]) return $([ $DEFAULT = N ]);;
      "") return 0;;
    esac
  done
}

# APT/aptitude updates and upgrades

apt_remove() {
  info "Removing $1..."
  if ! CONSOLE=noninteractive aptitude -y purge $1; then
    die "Error"
  fi
}

apt_installed() {
  return $([ `aptitude search ~i~n$1 | wc -l` -gt 0 ])
}

apt_install() {
  info "Installing $1..."
  if ! CONSOLE=noninteractive aptitude -y install $1; then
    die "Error"
  fi
}

apt_update() {
  info "APT updating..."
  aptitude update
  ok "Done.\n"
}

apt_fullupgrade() {
  info "APT upgrading..."
  aptitude full-upgrade
  ok "Done.\n"
}

apt_clean() {
  info "APT cleaning..."
  aptitude -y purge ~c
  aptitude clean
  ok "Done.\n"
}

# Detection(s)

if [[ `grep envID /proc/self/status` > 0 ]]; then
  OPENVZ=1
fi
