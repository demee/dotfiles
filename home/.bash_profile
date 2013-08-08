#set -x
echo 'Loading bash profile...'
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi
if [ -f ~/.bash_paths ]; then
  . ~/.bash_paths
fi
if [ -f ~/.bash_env ]; then
  . ~/.bash_env
fi
if [ -f ~/.bash_sublime ]; then
  . ~/.bash_sublime
fi

# homebrew bash completion extension
# brew info bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  echo 'Loading homebrew bash tweaks...'
  . $(brew --prefix)/etc/bash_completion
fi

# homebrew git bash completion extensions
# brew info git
if [ -d /usr/local/etc/bash_completion.d ]; then
  for f in /usr/local/etc/bash_completion.d/*.*; do
    echo "Loading ${f}..."
    source $f;
  done
  # configure console display
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWUPSTREAM="auto"
  PS1='\u@\h \W$(__git_ps1 " (%s)")\$ '
fi

echo 'Profile loaded.'