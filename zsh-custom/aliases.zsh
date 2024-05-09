# Bash Aliases - by Edil Medeiros

# Emacs ########################################################################

# Check if emacs GUI is open. If so, connect to it. If not, start the gui.
e () { pgrep -xiq emacs && emacsclient -nw $1 || emacs -nw $1 &; }
egui () { pgrep -xiq emacs && emacsclient -n $1 || emacs $1 &; }


# Sometimes I want to edit "in place".
eee () { emacs -nw $1 }
ee () { emacsclient -nw $1 }
ec () { emacsclient $1 & }

alias aliases='ec ~/.dotfiles/zsh-custom/aliases.zsh'
alias profile='ec ~/.dotfiles/profile'


# Bash #########################################################################

# !!   Repeat last command
# !x   Repeat last command that started with x
# !?x  Repeat last command that has the substring x
# !10  Repeat 10th command in the history file
# !-10 Repeat 10th from last command in the history file

alias sudo='sudo ' # Enable aliases to be sudo’ed
alias path='echo $PATH'
# alias prompt='ps1_set --prompt λ' # ∴


# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

#alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

# Bitcoin ######################################################################

alias bcli='bitcoin-cli'
alias bclih='bitcoin-cli help '

# Bat ##########################################################################

# Use bat to colorize man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_THEME=Dracula
