#!/usr/bin/env zsh

fonts=(
    "font-fira-code-nerd-font"
    "font-fira-mono-nerd-font"
    "font-hack-nerd-font"
    "font-inconsolata-go-nerd-font"
    "font-inconsolata-lgc-nerd-font"
    "font-inconsolata-nerd-font"
    "font-jetbrains-mono-nerd-font"
)

# Get list of installed formulae and casks once to avoid multiple calls
installed_list=$(brew list --cask)

for font in "${fonts[@]}"; do
    if ! echo "$installed_list" | grep -q "^$font$"; then
        brew install "$font"
    fi
done
