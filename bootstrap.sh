#!/usr/bin/env bash

# bootstrap.sh: A script to set up a macOS machine for development.

# Source the progress bar functions
# This provides the show_progress and increment_step_and_show_progress functions
source ./resources/progress_bar.sh

# Display an initial message
echo "Setting up your Mac..."

# Initialize variables to manage the progress bar
# total_steps: The total number of setup actions
# current_step: The current setup action being executed
total_steps=11
current_step=0

# Start each major setup action

# Load helper functions
increment_step_and_show_progress
echo "Loading helper functions..."
source ./resources/utils.sh
source ./resources/utils-macos.sh

# Set SSH key for GitHub
increment_step_and_show_progress
echo "Setting ssh key for github..."
source ./resources/setup_github_ssh_key.sh

# Install HomeBrew (Package Manager)
increment_step_and_show_progress
echo "Installing HomeBrew..."
source ./resources/install_homebrew.sh

# Install various tools and apps via HomeBrew
increment_step_and_show_progress
echo "Installing tools + apps..."
brew bundle --file ./resources/brewfile
print_after_newline "print_with_newline"

# Install Xdebug (Debugging tool for PHP)
increment_step_and_show_progress
echo "Installing Xdebug..."
source ./resources/install_xdebug.sh

# Link local dotfiles folder with GitHub
increment_step_and_show_progress
echo "Linking local dotfiles folder with github..."
source ./resources/link_github.sh

# Clone other personal GitHub repositories
increment_step_and_show_progress
echo "Cloning my other repositories to local..."
source ./resources/clone_github_repositories.sh

# Set up ZSH shell
increment_step_and_show_progress
echo "Installing zsh etc..."
source ./resources/setup_shell.sh

# Create symbolic links for various folders
increment_step_and_show_progress
echo "Creating symlinks..."
source ./resources/create_folder_symlinks.sh

# Load macOS specific preferences/settings
increment_step_and_show_progress
echo "Loading macOS settings..."
source ./resources/load_macos_preferences.sh

# Create symbolic links for dotfiles
increment_step_and_show_progress
echo "Symlinking dotfiles..."
source ./resources/symlink_dotfiles.sh

# Show an installation overview
increment_step_and_show_progress
echo "Showing installation overview..."
source ./resources/overview.sh

# Move to the next line after the progress bar reaches 100%
echo ""
