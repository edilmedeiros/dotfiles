# Bash Aliases - by Edil Medeiros

# Emacs ########################################################################

# Functions to open Emacs detached from the terminal and allow passing filenames:
# e <filename> opens emacs on the GUI
#e () { emacsclient $1 & }
# ee <filename> opens emacs on the terminal
#ee () { emacs -nw $1 }

# Check if emacs GUI is open. If so, connect to it. If not, start the gui.
e () { pgrep -xiq emacs && emacsclient -n $1 || emacs $1 &; }

# Sometimes I want to edit "in place".
ee () { emacs -nw $1 }


alias aliases='emacs ~/dotfiles/bash_aliases &'
alias profile='emacs ~/dotfiles/profile &'


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
