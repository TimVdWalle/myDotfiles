#!/usr/bin/env bash

echo "Setting up your Mac..."

# Loading helper functions
echo "Loading helper functions..."
source ./resources/utils.sh
source ./resources/utils-macos.sh

# Setting ssh key (for github)
echo "Setting ssh key for github..."
source ./resources/setup_github_ssh_key.sh

# Installing HomeBrew
echo "Installing HomeBrew..."
source ./resources/install_homebrew.sh

# Installing tools + apps
echo "Installing tools + apps..."
brew bundle --file ./resources/brewfile
print_after_newline "print_with_newline"

# Installing Xdebug
echo "Installing Xdebug..."
source ./resources/install_xdebug.sh

# Linking local dotfiles folder with github
echo "Linking local dotfiles folder with github..."
source ./resources/link_github.sh

# Cloning my other repositories to local
echo "Cloning my other repositories to local..."
source ./resources/clone_github_repositories.sh

# Installing zsh etc
echo "Installing zsh etc..."
source ./resources/setup_shell.sh

# Creating symlinks (folders etc, no dotfiles)
echo "Creating symlinks..."
source ./resources/create_folder_symlinks.sh

# Loading macos settings
echo "Loading macos settings..."
source ./resources/load_macos_preferences.sh

# Symlinking dotfiles
echo "Symlinking dotfiles..."
source ./resources/symlink_dotfiles.sh



# Showing installation overview
echo "Showing installation overview..."
source ./resources/overview.sh
