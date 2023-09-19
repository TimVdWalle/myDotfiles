#!/bin/sh

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/usr/local/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/usr/local/bin/brew shellenv)"
else
  echo 'HomeBrew already installed.'
fi

# Update Homebrew recipes
brew update
brew upgrade

brew tap homebrew/bundle

