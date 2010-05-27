if [ -f /opt/local/etc/bash_completion ]; then
  . /opt/local/etc/bash_completion
fi
if [ -f ~/.git-bash-prompt ]; then
  . ~/.git-bash-prompt
fi

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

export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/opt/ruby-enterprise-1.8.7-2010.01/bin:$PATH
export PATH=/opt/nginx/sbin:$PATH

#find public IP of native OS
alias copyip='ifconfig en1 | grep '\''inet '\'' | cut -f 2 -d\ | pbcopy'
