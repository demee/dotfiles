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
if [ -f ~/.bash_completion ]; then
  . ~/.bash_completion
fi
if [ -f ~/.git-bash-prompt ]; then
  . ~/.git-bash-prompt
fi
echo 'Profile loaded.'

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
  echo "Initializing new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null
  #ps ${SSH_AGENT_PID} doesn't work under cywgin
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi
