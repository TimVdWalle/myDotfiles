#!/bin/sh

# Displays have separate Spaces
# == dont make dock switch displays
defaults write com.apple.spaces "spans-displays" -bool "false" && killall SystemUIServer

print_after_newline "print_with_newline"