#!/bin/sh

echo "Loading utils..."
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Check os
check_os

# Confirm user intent before proceeding.
confirm_install

# Set SSH key for GitHub integration.
run_script "Setting ssh key for github..." "./steps/000_setup_github_ssh_key.sh"

# Create symbolic links for `Projects` folders.
run_script "Creating symlinks..." "./steps/100_symlink_folders.sh"

# Link local `dotfiles` folder to GitHub.
run_script "Linking local dotfiles folder with github..." "./steps/110_link_github.sh"

# Create symbolic links for dotfiles.
run_script "Symlinking dotfiles..." "./steps/200_symlink_dotfiles.sh"

# Install HomeBrew
run_script "Installing HomeBrew..." "./steps/300_install_homebrew.sh"

# Install tools and applications specified in the brewfile.
run_command "Installing tools + apps..." "brew bundle --file ./resources/brewfile"

# Install asdf plugins such as node, ruby, python
run_script "Installing asdf plugins node, ruby, python" "./steps/400_install_asdf_plugins.sh"

# Set up the shell environment.
run_script "Installing zsh etc..." "./steps/500_setup_shell.sh"

# Install snazzy theme.
run_script "Installing snazzy theme ..." "./steps/510_install_shell_theme.sh"

# Clone other repositories.
run_script "Cloning my repositories to local..." "./steps/600_clone_github_repositories.sh"

# Load macOS-specific settings/preferences.
run_script "Loading macos settings..." "./steps/700_load_macos_preferences.sh"

# Install php/laravel.
#run_script "Installing php / laravel..." "./steps/install_php_laravel.sh"

# Install Xdebug for PHP debugging.
#run_script "Installing Xdebug..." "./steps/install_xdebug.sh"

# Display installation summary or overview.
run_script "Showing installation overview:" "./steps/9999_show_overview.sh"
