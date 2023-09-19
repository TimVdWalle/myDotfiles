#!/bin/sh

# Install zsh with brew, even though zsh is already provided by macos (installing zsh with brew creates the config file in the right place)
brew install zsh

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

brew tap homebrew/cask-fonts
brew install font-hack-nerd-font

# Install powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
#rm -rf fonts/

# Install the pure prompt : https://github.com/sindresorhus/pure
brew install pure

# Install the color scheme that goes beautifully with the pure prompt
# installing hyper theme before hyper was opened for the first time makes it crash
echo "Open hyper terminal app, and close it again"
echo "Press enter to continue..."
read waiting
hyper install hyper-snazzy

# install antigen : Antigen is a small set of functions that help you easily manage your shell (zsh) plugins, called bundles
brew install antigen
brew install thefuck
brew install chroma
brew install ccat

# write settings to .zshrc


#brew install spaceship

#brew tap homebrew/cask-fonts
#brew install font-hack-nerd-font
#brew install --cask font-nerd-fonts
#brew install --cask font-fira-code




##https://timonbimon.medium.com/yet-another-step-by-step-guide-for-a-better-terminal-setup-6c5e879d4c8c



#print_after_newline "print_with_newline"#
