#!/usr/bin/env zsh

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
quit_system_preferences

# Add your preferred macOS settings here
# Example:
# execute "defaults write com.apple.dock \"show-recents\" -bool \"false\" && killall Dock" "Hide recent apps in Dock"

print_success "MacOS settings preferences are loaded."
