# ------------------------------------------------------------ #
# VPS Management : Minimal
#  - OpenVZ
#  - aptitude automatic method
# ------------------------------------------------------------ #

minimal() {
  if yesno 'We are going to try to setup a minimal SSH server (still very experimental).\nAre you ok to proceed' 'Y'; then

    aptitude update
    aptitude --safe-resolver --without-recommends -y install '?or(~prequired,~pimportant)' '~i !~prequired !~pimportant'_ ssh

    debug 'You should probably now reboot your system and check everything!\n'
  fi
}
