#!/bin/sh

# Only show active apps
#defaults write com.apple.dock "static-only" -bool "true" && killall Dock

# Do not display recent apps in the Dock
#defaults write com.apple.dock "show-recents" -bool "false" && killall Dock

#defaults write com.apple.dock persistent-apps -array

#for dockItem in {/System/Applications/{"Mail","Notes","System Preferences","App Store","Preview"},/Applications/{"iTerm","Visual Studio Code"}.app; do
#  defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>'$dockItem'</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
#done


echo "MacOS settings preferences are loaded."

print_after_newline "print_with_newline"