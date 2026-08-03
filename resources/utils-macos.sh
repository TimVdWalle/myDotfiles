#!/usr/bin/env zsh

quit_system_preferences() {
    # Check if System Preferences is running before trying to quit it
    if pgrep -x "System Preferences" > /dev/null; then
        osascript -e 'tell application "System Preferences" to quit'
    fi
}