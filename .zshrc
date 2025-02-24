# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
source $ZSH/oh-my-zsh.sh

# ohmyzsh plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-kubectl-prompt
)

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# export path for neovim intsalled from release package
# https://github.com/neovim/neovim/releases
# Current is 0.9.5
export PATH="$PATH:/opt/nvim-linux64/bin"
alias vim="nvim"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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

if [[ $OSTYPE == 'darwin'* ]]; then
  source /opt/homebrew/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# shortcuts
alias plays="cd ~/git/ansible/plays"
alias roles="cd ~/git/ansible/roles"
alias inv="cd ~/git/ansible/inventories"

