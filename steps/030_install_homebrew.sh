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
fi

# Update Homebrew recipes
if [ "$IS_TESTING" = "true" ]; then
  # In testing mode, brew update is often redundant if brew was just checked
  # but let's just make it quieter if it's already up to date.
  brew update &>/dev/null
  # We should probably still print something so the user knows this step finished.
  # But the requirement was to clean up. The execute call in bootstrap will print something.
  # Wait, bootstrap calls run_execute_script "Installing HomeBrew..." "./steps/030_install_homebrew.sh"
  # So "Installing HomeBrew..." will be printed by execute in bootstrap.sh
else
  execute "brew update" "Updating Homebrew recipes"
fi

# 'brew upgrade' checks all your installed packages for updates.
# It can take a long time if you have many packages, even if they are up to date,
# because it has to verify each one against the latest version online.
if [ "$IS_TESTING" != "true" ]; then
  execute "brew upgrade" "Upgrading Homebrew"
fi

