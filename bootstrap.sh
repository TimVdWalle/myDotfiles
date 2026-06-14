#!/usr/bin/env zsh

echo "Loading utils..."
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Ask for sudo early to avoid multiple prompts
ask_for_sudo

# Check os
check_os

# Install Xcode Command Line Tools early to avoid popups later
install_xcode_command_line_tools

# Confirm user intent before proceeding.
confirm_install

# Install HomeBrew
run_script "Installing HomeBrew..." "./steps/000_install_homebrew.sh"

# Set SSH key for GitHub integration.
run_script "Setting ssh key for github..." "./steps/100_setup_github_ssh_key.sh"

# Link local `dotfiles` folder to GitHub.
run_script "Linking local dotfiles folder with github..." "./steps/200_link_github.sh"

# Create symbolic links for `Projects` folders.
run_script "Creating symlinks for Projects..." "./steps/300_symlink_folders.sh"

# Create symbolic links for dotfiles.
run_script "Symlinking dotfiles..." "./steps/400_symlink_dotfiles.sh"

# Install tools and applications specified in the brewfile.
run_command "Installing tools + apps..." "brew bundle --file ./resources/Brewfile"

# Set up the shell environment.
run_script "Installing zsh etc..." "./steps/500_setup_shell.sh"

# Install snazzy theme.
run_script "Installing snazzy theme ..." "./steps/510_install_shell_theme.sh"

# Install asdf plugins such as node, ruby, python
run_script "Installing asdf plugins node, ruby, python" "./steps/620_install_asdf_plugins.sh"

# Clone other repositories.
run_script "Cloning my repositories to local..." "./steps/700_clone_github_repositories.sh"

# Install php/laravel.
#run_script "Installing php / laravel..." "./steps/710_install_php_laravel.sh"

# Install Xdebug for PHP debugging.
#run_script "Installing Xdebug..." "./steps/720_install_xdebug.sh"

# Load macOS-specific settings/preferences.
run_script "Loading macos settings..." "./steps/800_load_macos_preferences.sh"

# Display installation summary or overview.
run_script "Showing installation overview:" "./steps/900_show_overview.sh"
