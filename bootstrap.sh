#!/bin/sh

echo "Loading utils..."
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Check os
check_os

# Confirm user intent before proceeding.
confirm_install

# Collect configuration details upfront
source "./steps/005_collect_config.sh"

# Create symbolic links for specified folders.
run_script "Creating symlinks..." "./steps/010_symlink_folders.sh"

# Set SSH key for GitHub integration.
run_script "Setting ssh key for github..." "./steps/020_setup_github_ssh_key.sh"

# Install HomeBrew
run_script "Installing HomeBrew..." "./steps/030_install_homebrew.sh"

# Link local dotfiles folder to GitHub.
run_script "Linking local dotfiles folder with github..." "./steps/040_link_github.sh"

# Ask for sudo early to avoid multiple prompts
ask_for_sudo

# Install tools and applications specified in the brewfile.
run_command "Installing tools + apps..." "brew bundle --file ./resources/brewfile"
run_script "Installing PHP + Laravel..." "./steps/060_install_php_laravel.sh"

echo "Tools + apps are installed."
print_after_newline "print_with_newline"

# Install Xdebug for PHP debugging.
run_script "Installing Xdebug..." "./steps/070_install_xdebug.sh"


# Clone other repositories.
run_script "Cloning my repositories to local..." "./steps/080_clone_github_repositories.sh"

# Set up the shell environment.
run_script "Installing zsh etc..." "./steps/090_setup_shell.sh"

# Load macOS-specific settings/preferences.
run_script "Loading macos settings..." "./steps/100_load_macos_preferences.sh"

# Install asdf plugins such as node, ruby, python
run_script "Installing asdf plugins node, ruby, python" "./steps/110_install_asdf_plugins.sh"

# Create symbolic links for dotfiles.
run_script "Symlinking dotfiles..." "./steps/120_symlink_dotfiles.sh"

# Install snazzy theme.
run_script "Installing snazzy theme ..." "./steps/130_install_shell_theme.sh"

# Display installation summary or overview.
run_script "Showing installation overview:" "./steps/900_show_overview.sh"
