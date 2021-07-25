
#souce this file, don't execute it! or you don't have PATH set
gpg --card-status
gpg-connect-agent updatestartuptty /bye

export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# normally shouldn't need this
ssh-add
