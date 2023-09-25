#!/bin/sh

# Install zsh with brew, even though zsh is already provided by macos (installing zsh with brew creates the config file in the right place)
# Check if zsh is installed with brew
if ! brew list zsh > /dev/null 2>&1; then
    # Install zsh with brew, even though zsh is already provided by macOS
    # (installing zsh with brew creates the config file in the right place)
    brew install zsh
fi

if [ -d ~/.oh-my-zsh ]; then
	echo "oh-my-zsh is already installed. Skipping."
 else
 	echo "Installing oh-my-zsh"
 	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

brew tap homebrew/cask-fonts
source "./resources/install_fonts.sh"

# Install the pure prompt : https://github.com/sindresorhus/pure
brew install pure

# install antigen : Antigen is a small set of functions that help you easily manage your shell (zsh) plugins, called bundles
brew install antigen
brew install thefuck
brew install chroma
brew install ccat

print_after_newline "print_with_newline"
