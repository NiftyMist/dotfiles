# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# catppuccin zsh theme
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

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

if [ ! -f ~/.gitlab_access_token ]; then
  echo "No gitlab access token found"
  echo "Please add gitlab access token to $HOME/.gitlab_access_token"
else
  export GITLAB_ACCESS_TOKEN=$(cat $HOME/.gitlab_access_token)
fi

# molecule enable colors for tmux
export PY_COLORS='1'
export ANSIBLE_FORCE_COLOR='1'

# shortcuts
alias vim="nvim"
# get to ansible dirs quickly
# Replace your alias with this function
# Enable completion system 
autoload -Uz compinit
compinit

# molecule shortcuts
alias mc="molecule converge"
alias mp="molecule prepare --force"
alias md="molecule destroy"
alias ml="molecule login"
alias mlv="molecule verify"

# activate virtual environment
if [ ! -d ~/venvs/latest ]; then
  echo "No venv found"
else
  source ~/venvs/latest/bin/activate
fi

# set editor to yazi opens fils in neovim
export EDITOR=nvim

# bat theme
export BAT_THEME="Catppuccin Macchiato"
alias cat="bat"

# gitlab commit signing
export GPG_TTY=$(tty)

eval "$(starship init zsh)"

# include my bash libraries
source ~/dotfiles/lib/functions.sh
