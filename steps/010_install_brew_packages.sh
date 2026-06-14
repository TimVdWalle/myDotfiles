#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Install tools and applications specified in the brewfile.
execute "brew bundle --file ./resources/Brewfile" "Installing tools + apps from Brewfile"
