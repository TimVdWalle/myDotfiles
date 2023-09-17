#!/bin/sh

# Switch to zsh shell
# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi
#brew install spaceship

brew tap homebrew/cask-fonts
brew install font-hack-nerd-font
brew install --cask font-nerd-fonts
brew install --cask font-fira-code

brew install starship

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


#https://timonbimon.medium.com/yet-another-step-by-step-guide-for-a-better-terminal-setup-6c5e879d4c8c

# Install powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..

print_after_newline "print_with_newline"
