# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# ohmyzsh plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-kubectl-prompt
)
if [[ $OSTYPE == 'darwin'* ]]; then
  source /opt/homebrew/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# awx-kit setup
HOSTNAME=`hostname`
if [ "$HOSTNAME" = Dylans-Mac-mini ]; then
  AWX='awx.mitchell.house'
else
  AWX='awx.rinet.io'
fi
export TOWER_HOST=https://$AWX
if [ ! -f ~/.awx_oauth_token ]; then
  echo "No awx oauth_token found"
  echo "Please add awx oauth_token to $HOME/.awx_oauth_token"
else
  export TOWER_OAUTH_TOKEN=$(cat $HOME/.awx_oauth_token)
fi

# molecule enable colors for tmux
export PY_COLORS='1'
export ANSIBLE_FORCE_COLOR='1'

# shortcuts
alias vim="nvim"
# get to ansible dirs quickly
alias plays="cd ~/git/ansible/plays"
alias roles="cd ~/git/ansible/roles"
alias inv="cd ~/git/ansible/inventories"
# molecule shortcuts
alias mc="molecule converge"
alias mp="molecule prepare --force"
alias md="molecule destroy"
alias mlv="molecule verify"
# fzf
# Set up fzf key bindings and fuzzy completion
# source <(fzf --zsh)
# alias search="fzf --tmux 80% --preview 'bat --color=always {}'" 

# oh-my-posh
# ignore default apple terminal
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh)"
fi
eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/tokyonight_storm.omp.json)"

# activate virtual environment
if [ ! -d ~/venvs/latest ]; then
  echo "No venv found"
else
  source ~/venvs/latest/bin/activate
fi
