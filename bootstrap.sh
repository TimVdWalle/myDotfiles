#!/usr/bin/env bash

echo "Setting up your Mac..."

# Loading helper functions
echo "Loading helper functions..."
source ./resources/utils.sh
source ./resources/utils-macos.sh

# Setting ssh key (for github)
echo "Setting ssh key for github..."
#source ./resources/github_ssh_key.sh

# Installing HomeBrew
echo "Installing HomeBrew..."
#source ./resources/install_homebrew.sh

# Installing tools + apps
echo "Installing tools + apps..."
#brew bundle --file ./resources/brewfile
print_after_newline "print_with_newline"

# Installing Xdebug
echo "Installing Xdebug..."
#source ./resources/xdebug.sh

# Linking local dotfiles folder with github
echo "Linking local dotfiles folder with github..."
#source ./resources/link_github.sh

# Cloning my other repositories to local
echo "Cloning my other repositories to local..."
#source ./resources/github_repositories.sh

# Installing zsh etc
echo "Installing zsh etc..."
#source ./resources/shell.sh

# Creating symlinks
echo "Creating symlinks..."
#source ./resources/symlinks.sh

# Loading macos settings
echo "Loading macos settings..."
#source ./resources/macos.sh



# Showing installation overview
echo "Showing installation overview..."
source ./resources/overview.sh






#
## Check for Homebrew and install if we don't have it
#if test ! $(which brew); then
#  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#
#  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
#  eval "$(/opt/homebrew/bin/brew shellenv)"
#fi
#
## Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
#rm -rf $HOME/.zshrc
#ln -s .zshrc $HOME/.zshrc
#
## Update Homebrew recipes
#brew update
#
## Install all our dependencies with bundle (See Brewfile)
#brew tap homebrew/bundle
#brew bundle --file ./Brewfile
#
## Set default MySQL root password and auth type
#mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;"
#
## Create a projects directories
#mkdir $HOME/Code
#mkdir $HOME/Herd
#
## Create Code subdirectories
#mkdir $HOME/Code/blade-ui-kit
#mkdir $HOME/Code/laravel
#
## Clone Github repositories
#./clone.sh
#
## Symlink the Mackup config file to the home directory
#ln -s ./.mackup.cfg $HOME/.mackup.cfg
#
## Set macOS preferences - we will run this last because this will reload the shell
#source ./.macos