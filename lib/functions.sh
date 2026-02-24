
roles() {
  local base_dir=~/git/ansible/roles
  if [[ -z "$1" ]]; then
    cd "$base_dir" || return
  else
    cd "$base_dir/$1" || echo "Role '$1' not found in $base_dir"
  fi
}

# Completion for roles()
_roles() {
  local base_dir=~/git/ansible/roles
  _files -W "$base_dir" -/
}
compdef _roles roles

plays() {
  local base_dir=~/git/ansible/plays
  if [[ -z "$1" ]]; then
    cd "$base_dir" || return
  else
    cd "$base_dir/$1" || echo "Play '$1' not found in $base_dir"
  fi
}

# Completion for plays()
_plays() {
  local base_dir=~/git/ansible/plays
  _files -W "$base_dir" -/
}
compdef _plays plays

inv() {
  local base_dir=~/git/ansible/inventories
  if [[ -z "$1" ]]; then
    cd "$base_dir" || return
  else
    cd "$base_dir/$1" || echo "Inventory '$1' not found in $base_dir"
  fi
}

# Completion for inv()
_inv() {
  local base_dir=~/git/ansible/inventories
  _files -W "$base_dir" -/
}
compdef _inv inv

daily_note() {
  DATE=`date +"%Y-%m-%d"`
  OBSIDIAN="$HOME/obsidian/journal"
  DAILY_NOTE="work-notes/$DATE.md"
  cd $OBSIDIAN
  nvim $DAILY_NOTE
}
