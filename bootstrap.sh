#!/usr/bin/env zsh

echo "Loading helper files..."
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Check os
check_os

# Confirm user intent before proceeding.
confirm_install

# Set SSH key for GitHub integration.
run_script "Setting ssh key for github..." "./resources/setup_github_ssh_key.sh"

# Install HomeBrew
run_script "Installing HomeBrew..." "./resources/install_homebrew.sh"

# Install tools and applications specified in the brewfile.
run_script "Installing tools + apps..." "brew bundle --file ./resources/brewfile"

# Install Xdebug for PHP debugging.
run_script "Installing Xdebug..." "./resources/install_xdebug.sh"

# Link local dotfiles folder to GitHub.
run_script "Linking local dotfiles folder with github..." "./resources/link_github.sh"

# Clone other required repositories.
run_script "Cloning my other repositories to local..." "./resources/clone_github_repositories.sh"

# Set up the shell environment.
run_script "Installing zsh etc..." "./resources/setup_shell.sh"

# Create symbolic links for specified folders.
run_script "Creating symlinks..." "./resources/create_folder_symlinks.sh"

# Load macOS-specific settings/preferences.
run_script "Loading macos settings..." "./resources/load_macos_preferences.sh"

# Create symbolic links for dotfiles.
run_script "Symlinking dotfiles..." "./resources/symlink_dotfiles.sh"

# Display installation summary or overview.
run_script "Showing installation overview..." "./resources/overview.sh"
