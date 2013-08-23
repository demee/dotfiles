echo 'Loading bash aliases...'

# find public IP of native OS
alias copyip='ifconfig en1 | grep '\''inet '\'' | cut -f 2 -d\ | pbcopy'

# override default ls to have more verbose directory listing
alias ls='ls -laFG'

# reload your shell profile
alias reload='. ~/.bash_profile'