# ------------------------------------------------------------ #
# VPS Management : Minimal (OpenVZ)
# ------------------------------------------------------------ #

minimal() {
  if yesno 'We are going to try to setup a minimal SSH server (still very experimental).\nAre you ok to proceed' 'Y'; then
    aptitude search '~i!~prequired!?automatic' -F '%p' | grep -o '[0-9a-zA-Z.+-]*' > installed

    sort installed vps/minimal vps/minimal | uniq -u | while read pkg; do
      info 'Purge: '$pkg
#    aptitude -y purge $pkg
    done

    sort installed installed vps/minimal | uniq -u | while read pkg; do
      info 'Install: '$pkg
#    aptitude -y install $pkg
    done

    debug 'You should probably now reboot your system and check everything!\n'
  fi
}

# aptitude -R install '?or(~prequired,~pimportant)' '~i !~prequired !~pimportant'_
# aptitude install ssh

options=("${options[@]}" "minimal (Light Debian server + SSH)")
