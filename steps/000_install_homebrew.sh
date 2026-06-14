#!/usr/bin/env zsh

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
execute "brew upgrade" "Upgrading Homebrew"

