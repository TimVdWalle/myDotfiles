#!/bin/sh

echo "Loading utils..."
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Check os
check_os

# Confirm user intent before proceeding.
confirm_install

# Create symbolic links for specified folders.
run_script "Creating symlinks..." "./steps/symlink_folders.sh"

# Set SSH key for GitHub integration.
run_script "Setting ssh key for github..." "./steps/setup_github_ssh_key.sh"

# Install HomeBrew
run_script "Installing HomeBrew..." "./steps/install_homebrew.sh"

# Install tools and applications specified in the brewfile.
run_command "Installing tools + apps..." "brew bundle --file ./resources/brewfile"
composer global require laravel/valet
composer global require laravel/installer
valet install
#brew install --cask phpmon

echo "Tools + apps are installed."
print_after_newline "print_with_newline"

# Install Xdebug for PHP debugging.
run_script "Installing Xdebug..." "./steps/install_xdebug.sh"

# Link local dotfiles folder to GitHub.
run_script "Linking local dotfiles folder with github..." "./steps/link_github.sh"

# Clone other repositories.
run_script "Cloning my repositories to local..." "./steps/clone_github_repositories.sh"

# Set up the shell environment.
run_script "Installing zsh etc..." "./steps/setup_shell.sh"

# Load macOS-specific settings/preferences.
run_script "Loading macos settings..." "./steps/load_macos_preferences.sh"

# Create symbolic links for dotfiles.
run_script "Symlinking dotfiles..." "./steps/symlink_dotfiles.sh"

# Install snazzy theme.
run_script "Installing snazzy theme ..." "./steps/install_shell_theme.sh"

# Display installation summary or overview.
run_script "Showing installation overview:" "./steps/show_overview.sh"
