#!/bin/sh

# Set up SSH authentication via GPG smartcard (e.g. YubiKey).
#
# Redirects SSH_AUTH_SOCK to gpg-agent's SSH socket so that SSH uses the
# GPG authentication subkey on the inserted smartcard.
#
# This script is designed to be used with eval:
#
#   eval $(my-ssh-gpg-sc.sh)
#
# It prints the export command to stdout (for eval to pick up) and all
# other output goes to stderr.  Running the script directly without eval
# will show usage instructions instead.

usage() {
  cat <<'EOF'
Usage: eval $(my-ssh-gpg-sc.sh)

Set up SSH authentication via GPG smartcard (e.g. YubiKey).

This script redirects SSH_AUTH_SOCK to gpg-agent so that SSH uses the
GPG authentication subkey on the inserted smartcard.

You must use eval so the export takes effect in your current shell:

  eval $(my-ssh-gpg-sc.sh)

Running the script directly (without eval) has no effect on your shell
environment.
EOF
  exit "${1:-1}"
}

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  usage 0
fi

# Detect if stdout is a terminal — if so, the user ran the script directly
# instead of wrapping it in eval $(...).  Show usage and exit.
if [ -t 1 ]; then
  echo "Error: run this script with eval, not directly." >&2
  echo >&2
  usage
fi

# Wake up the smartcard (output to stderr so eval ignores it)
gpg --card-status >&2

# Tell gpg-agent which terminal to use for PIN prompts
gpg-connect-agent updatestartuptty /bye >&2

# Print the export for eval to capture
echo "export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)"
