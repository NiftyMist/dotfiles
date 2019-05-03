#export PS1="[\h\[\033[32m\]\w]\[\033[32m\]\n\[\033[0;31m\]\u\[\033[0;31m\]\n-> \[\033[0m\]"
source ~/dotfiles/git-prompt.sh
#export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
export PS1='\n[\h\[\033[32m\] \w\[\033[0m\]]\[\033[32m\] \e[47m\e[1;31m$(__git_ps1 "(%s)")\e[49m \n\[\033[0;34m\]\u\[\033[0;31m\]\n\$ \[\033[0m\]'

if [ \u -eq root ]
then
  export PS1='[\h\[\033[32m\]\w]\[\033[32m\] $(__git_ps1 " (%s)") \n\[\033[0;31m\]\u\[\033[0;31m\]\n-> \[\033[0m\]'
fi  
