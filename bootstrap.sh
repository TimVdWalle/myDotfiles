#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

print_info "Loading utils..."

# Check os
check_os

# Ask for sudo early to avoid multiple prompts
ask_for_sudo

# Confirm user intent before proceeding.
confirm_install

# Install Xcode Command Line Tools early to avoid popups later
install_xcode_command_line_tools

# Collect configuration details upfront
source "./steps/005_collect_config.sh"

# Create symbolic links for `Projects` folders.
print_step "100" "Symlink Folders"
run_script "Creating symlinks for Projects..." "./steps/100_symlink_folders.sh"

# Set SSH key for GitHub integration.
print_step "110" "GitHub SSH Key"
run_script "Setting ssh key for github..." "./steps/110_setup_github_ssh_key.sh"

# Install HomeBrew
print_step "120" "HomeBrew"
run_script "Installing HomeBrew..." "./steps/120_install_homebrew.sh"

# Link local `dotfiles` folder to GitHub.
print_step "130" "Link GitHub"
run_script "Linking local dotfiles folder with github..." "./steps/130_link_github.sh"

# Install tools and applications specified in the brewfile.
print_step "140" "Brew Packages"
run_script "Installing tools + apps from Brewfile..." "./steps/140_install_brew_packages.sh"

# Install asdf plugins such as node, ruby, python
print_step "150" "ASDF Plugins"
run_script "Installing asdf plugins node, ruby, python" "./steps/150_install_asdf_plugins.sh"

# Clone other repositories.
print_step "160" "GitHub Repositories"
run_script "Cloning my repositories to local..." "./steps/160_clone_github_repositories.sh"

# Set up the shell environment.
print_step "170" "Shell Environment"
run_script "Installing zsh etc..." "./steps/170_setup_shell.sh"

# Load macOS-specific settings/preferences.
print_step "180" "macOS Preferences"
run_script "Loading macos settings..." "./steps/180_load_macos_preferences.sh"

# Create symbolic links for dotfiles.
print_step "190" "Symlink Dotfiles"
run_script "Symlinking dotfiles..." "./steps/190_symlink_dotfiles.sh"

# Install snazzy theme.
print_step "200" "Shell Theme"
run_script "Installing snazzy theme ..." "./steps/200_install_shell_theme.sh"

# Display installation summary or overview.
run_script "Showing installation overview:" "./steps/900_show_overview.sh"
