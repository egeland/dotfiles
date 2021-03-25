#!/usr/bin/env bash

[[ "$(command -v dockutil)" ]] || { echo "dockutil is not installed" 1>&2 ; exit 1; }

# Set tilesize (default 40)
defaults write com.apple.dock tilesize -int 70

dockutil --no-restart --remove all

# Default Apps
# List has been kept in default order.
# dockutil --no-restart --section apps --add "/System/Applications/Siri.app"
dockutil --no-restart --section apps --add "/System/Applications/Launchpad.app"
# dockutil --no-restart --section apps --add "/Applications/Safari.app"
# dockutil --no-restart --section apps --add "/System/Applications/Mail.app"
# dockutil --no-restart --section apps --add "/System/Applications/Contacts.app"
# dockutil --no-restart --section apps --add "/System/Applications/Calendar.app"
# dockutil --no-restart --section apps --add "/System/Applications/Notes.app"
# dockutil --no-restart --section apps --add "/System/Applications/Reminders.app"
# dockutil --no-restart --section apps --add "/System/Applications/Maps.app"
# dockutil --no-restart --section apps --add "/System/Applications/Photos.app"
# dockutil --no-restart --section apps --add "/System/Applications/Messages.app"
# dockutil --no-restart --section apps --add "/System/Applications/FaceTime.app"
# dockutil --no-restart --section apps --add "/System/Applications/News.app"
# dockutil --no-restart --section apps --add "/System/Applications/Music.app"
# dockutil --no-restart --section apps --add "/System/Applications/Podcasts.app"
# dockutil --no-restart --section apps --add "/System/Applications/TV.app"
# dockutil --no-restart --section apps --add "/System/Applications/Books.app"
# dockutil --no-restart --section apps --add "/System/Applications/App Store.app"
dockutil --no-restart --section apps --add "/System/Applications/System Preferences.app"

# Custom Apps
dockutil --no-restart --section apps --add "/Applications/Google Chrome.app"
dockutil --no-restart --section apps --add "/Applications/iTerm.app"
dockutil --no-restart --section apps --add "/Applications/Slack.app"
dockutil --no-restart --section apps --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --section apps --add "/Applications/BIG-IP Edge Client.app"

dockutil --add '' --type spacer --section apps --after "System Preferences"
dockutil --add '' --type spacer --section apps --after "iTerm"
dockutil --add '' --type spacer --section apps --after "Visual Studio Code"

# Default Others
dockutil --no-restart --section others --add "${HOME}/Downloads" --view fan --display stack --sort dateadded

killall Dock -QUIT
