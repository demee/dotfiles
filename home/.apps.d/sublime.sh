########################
# sublime text 2 config
########################
if [ -d "/Applications/Sublime Text 2.app" ]; then
  echo "Configuring Sublime Text 2"

  # enable repeat key press
  defaults write com.sublimetext.2 ApplePressAndHoldEnabled -bool false

  # setup subl for CLI
  ln -fs "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl

  # use custom preferences
  ln -fs ~/.sublime/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User/Preferences.sublime-settings
fi


########################
# sublime text 3 config
########################
if [ -d "/Applications/Sublime Text.app" ]; then
  echo "Configuring Sublime Text 3"

  # enable repeat key press
  defaults write com.sublimetext.3 ApplePressAndHoldEnabled -bool false

  # create subl for CLI
  ln -fs "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl

  # use custom preferences
  ln -fs ~/.sublime/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text/Packages/User/Preferences.sublime-settings
fi