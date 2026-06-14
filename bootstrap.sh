#!/usr/bin/env zsh

echo "Loading utils..."
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Check os
check_os

# Confirm user intent before proceeding.
confirm_install

# Ask for sudo early to avoid multiple prompts
ask_for_sudo

# Collect configuration details upfront
source "./steps/005_collect_config.sh"

# Create symbolic links for specified folders.
run_execute_script "Creating symlinks..." "./steps/010_symlink_folders.sh"

# Set SSH key for GitHub integration.
run_execute_script "Setting ssh key for github..." "./steps/020_setup_github_ssh_key.sh"

# Install HomeBrew
run_execute_script "Installing HomeBrew..." "./steps/030_install_homebrew.sh"

# Link local dotfiles folder to GitHub.
run_execute_script "Linking local dotfiles folder with github..." "./steps/040_link_github.sh"

# Install tools and applications specified in the brewfile.
run_execute_script "Installing tools + apps..." "brew bundle --file ./resources/brewfile"

# Clone other repositories.
run_execute_script "Cloning my repositories to local..." "./steps/080_clone_github_repositories.sh"

# Set up the shell environment.
run_execute_script "Installing zsh etc..." "./steps/090_setup_shell.sh"

# Load macOS-specific settings/preferences.
run_execute_script "Loading macos settings..." "./steps/100_load_macos_preferences.sh"

# Install asdf plugins such as node, ruby, python
run_execute_script "Installing asdf plugins node, ruby, python" "./steps/110_install_asdf_plugins.sh"

# Create symbolic links for dotfiles.
run_execute_script "Symlinking dotfiles..." "./steps/120_symlink_dotfiles.sh"

# Install snazzy theme.
run_execute_script "Installing snazzy theme ..." "./steps/130_install_shell_theme.sh"

# Display installation summary or overview.
run_execute_script "Showing installation overview:" "./steps/900_show_overview.sh"
