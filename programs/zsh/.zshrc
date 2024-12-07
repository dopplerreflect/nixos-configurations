
# The following lines were added by compinstall
zstyle :compinstall filename '/home/doppler/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
# End of lines configured by zsh-newuser-install

eval "$(oh-my-posh init zsh)"
eval "$(zoxide init --cmd cd zsh)"
