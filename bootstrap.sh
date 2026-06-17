#!/usr/bin/env zsh

echo "Loading utils..."
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Check os
check_os


# Collect configuration details upfront
print_step 1 5 "Collecting configuration"
# Confirm user intent before proceeding.
confirm_install

# Ask for sudo early to avoid multiple prompts
ask_for_sudo

source "./steps/005_collect_config.sh"

# System & GitHub Setup
print_step 2 5 "System & GitHub Setup"
run_execute_script "Creating symlinks..." "./steps/010_symlink_folders.sh"
run_script "Setting up SSH key for GitHub..." "./steps/020_setup_github_ssh_key.sh"
run_execute_script "Installing HomeBrew..." "./steps/030_install_homebrew.sh"
run_execute_script "Linking local dotfiles folder with github..." "./steps/040_link_github.sh"

# Applications & Tools
print_step 3 5 "Installing Applications & Tools"
run_execute_script "Installing tools + apps from brewfile..." "brew bundle --file ./resources/brewfile"
run_execute_script "Cloning my repositories to local..." "./steps/080_clone_github_repositories.sh"
run_execute_script "Installing asdf plugins node, ruby, python..." "./steps/110_install_asdf_plugins.sh"

# Shell & Preferences
print_step 4 5 "Configuring Shell & Preferences"
run_execute_script "Installing zsh etc..." "./steps/090_setup_shell.sh"
run_execute_script "Loading macos settings..." "./steps/100_load_macos_preferences.sh"
run_execute_script "Symlinking dotfiles..." "./steps/120_symlink_dotfiles.sh"

# Finish
print_step 5 5 "Overview"
source "./steps/900_show_overview.sh"
