#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

execute "composer global require laravel/valet" "Installing Laravel Valet"
execute "composer global require laravel/installer" "Installing Laravel Installer"
execute "valet install" "Setting up Valet"
execute "brew install --cask phpmon" "Installing PHP Monitor"