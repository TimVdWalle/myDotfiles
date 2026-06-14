#!/usr/bin/env zsh

source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Check for Homebrew and install if we don't have it
if ! cmd_exists "brew"; then
  print_info "HomeBrew not installed yet. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ "$(uname -m)" == "arm64" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
  else
      eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  print_success "HomeBrew already installed."
fi

# Update Homebrew recipes
execute "brew update" "Updating Homebrew recipes"

# 'brew upgrade' checks all your installed packages for updates.
# It can take a long time if you have many packages, even if they are up to date,
# because it has to verify each one against the latest version online.
if [ "$IS_TESTING" = "true" ]; then
  print_info "Skipping 'brew upgrade' because you are in testing mode."
else
  execute "brew upgrade" "Upgrading Homebrew"
fi

