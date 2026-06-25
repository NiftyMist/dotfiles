# Shell functions library — must be sourced. Works in both zsh and bash.
(return 0 2>/dev/null) || {
  echo "ERROR: This file must be sourced, not executed"
  exit 1
}

roles() {
  local base_dir=~/git/ansible/roles
  if [[ -z "$1" ]]; then
    cd "$base_dir" || return
  else
    cd "$base_dir/$1" || echo "Role '$1' not found in $base_dir"
  fi
}

plays() {
  local base_dir=~/git/ansible/plays
  if [[ -z "$1" ]]; then
    cd "$base_dir" || return
  else
    cd "$base_dir/$1" || echo "Play '$1' not found in $base_dir"
  fi
}

inv() {
  local base_dir=~/git/ansible/inventories
  if [[ -z "$1" ]]; then
    cd "$base_dir" || return
  else
    cd "$base_dir/$1" || echo "Inventory '$1' not found in $base_dir"
  fi
}

daily_note() {
  local date_str
  date_str=$(date +"%Y-%m-%d")
  local obsidian="$HOME/obsidian/journal"
  cd "$obsidian" && nvim "work-notes/${date_str}.md"
}

todo() {
  local obsidian="$HOME/obsidian/journal"
  cd "$obsidian" && nvim TODO.md
}

# Shell-specific tab completion
if [[ -n "$ZSH_VERSION" ]]; then
  _roles() { _files -W ~/git/ansible/roles -/; }
  _plays() { _files -W ~/git/ansible/plays -/; }
  _inv()   { _files -W ~/git/ansible/inventories -/; }
  compdef _roles roles
  compdef _plays plays
  compdef _inv inv
elif [[ -n "$BASH_VERSION" ]]; then
  _df_ansible_dir_complete() {
    local base_dir="$1"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    if [[ -d "$base_dir" ]]; then
      mapfile -t COMPREPLY < <(cd "$base_dir" && compgen -d -- "$cur")
    fi
  }
  _df_roles_complete() { _df_ansible_dir_complete ~/git/ansible/roles; }
  _df_plays_complete() { _df_ansible_dir_complete ~/git/ansible/plays; }
  _df_inv_complete()   { _df_ansible_dir_complete ~/git/ansible/inventories; }
  complete -F _df_roles_complete roles
  complete -F _df_plays_complete plays
  complete -F _df_inv_complete inv
fi

dotfiles() {
  local dotfiles="$HOME/dotfiles"
  cd "$dotfiles"
}
