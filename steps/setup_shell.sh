#!/bin/sh

# Install zsh with brew, even though zsh is already provided by macos (installing zsh with brew creates the config file in the right place)
# Check if zsh is installed with brew
if ! brew list zsh > /dev/null 2>&1; then
    # Install zsh with brew, even though zsh is already provided by macOS
    # (installing zsh with brew creates the config file in the right place)
    echo "zsh is not installed."
    echo "Installing zsh with brew..."
    brew install zsh
fi

# Install oh-my-zsh
if [ -d ~/.oh-my-zsh ]; then
	echo "oh-my-zsh is already installed. Skipping."
 else
 	echo "Installing oh-my-zsh"
 	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

brew tap homebrew/cask-fonts
source "./resources/install_fonts.sh"

# install starship prompt
brew install starship
if [ -d ~/.config ]; then
  echo "starship pure prompt preset already set."
  echo "Skipping..."
else
  echo "Setting up pure prompt with starship..."
  mkdir ~/.config
  starship preset pure-preset -o ~/.config/starship.toml
fi

# install antigen : Antigen is a small set of functions that help you easily manage your shell (zsh) plugins, called bundles
brew install antigen
brew install thefuck
brew install chroma
brew install ccat

print_after_newline "print_with_newline"
