#!/usr/bin/env zsh

# Install the color scheme that goes beautifully with the pure prompt
# Installing hyper theme before hyper was opened for the first time makes it crash
print_info "Open hyper terminal app, and close it again"
ask_to_continue
execute "hyper install hyper-snazzy" "Installing hyper-snazzy theme"

print_after_newline "print_with_newline"

print_after_newline "print_with_newline"
