#!/bin/sh

# Displays have separate Spaces
# == dont make dock switch displays
defaults write com.apple.spaces "spans-displays" -bool "false" && killall SystemUIServer

# Show recent applications in Dock
#defaults write com.apple.dock "show-recents"  -bool false

# Show hidden files:
defaults write com.apple.finder AppleShowAllFiles YES;

echo "MacOS settings preferences are loaded."

print_after_newline "print_with_newline"