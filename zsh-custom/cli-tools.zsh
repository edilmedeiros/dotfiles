# Setup fzf keybindings and fuzzy completion
eval "$(fzf --zsh)"

# Use fd instead of fzf
#unalias fd
export FZF_DEFAULT_COMMAND="fd --hidden --follow --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --follow --strip-cwd-prefix --exclude .git"

# look for fzf-git

# Use bat and eza to preview stuff
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color-always {} | head -200'"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --follow --exclude ".git" . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} |head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$' {}" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}
