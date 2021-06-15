# Confirmation #
alias mv='mv --interactive --verbose'
alias cp='cp --interactive --verbose'
alias ln='ln --interactive --verbose'

# Parenting changing perms on / #
alias chown='chown --verbose --preserve-root'
alias chmod='chmod --verbose --preserve-root'
alias chgrp='chgrp --verbose --preserve-root'

# Ls Color
alias ls='ls --color=auto'
alias l='ls -lAh --color=auto'
alias ll='ls -la --color=auto'

# Git powersl
alias gitsearch='git rev-list --all | xargs git grep -F'
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gl1="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

# Microk8s
alias kubectl='microk8s kubectl'
alias helm='microk8s helm3'
alias helm3='microk8s helm3'

export PATH=~/.local/bin:$PATH

