#!/bin/sh
# Outputs a catppuccin-styled SSH indicator for tmux status bar.
# Args: pane_pid thm_red thm_crust thm_fg thm_surface_0
# Outputs nothing if no SSH session is running in the pane.
pane_pid="$1"
color="$2"
crust="$3"
fg="$4"
surface="$5"

ssh_pid=$(pgrep -P "$pane_pid" ssh 2>/dev/null)
[ -z "$ssh_pid" ] && exit 0

host=$(ps -o args= -p "$ssh_pid" 2>/dev/null | awk '{for(i=NF;i>=1;i--) if($i !~ /^-/) {print $i; exit}}')
[ -z "$host" ] && exit 0

printf "#[fg=%s]#[fg=%s,bg=%s]  #[fg=%s,bg=%s] %s #[fg=%s,bg=default] " \
  "$color" "$crust" "$color" "$fg" "$surface" "$host" "$surface"
