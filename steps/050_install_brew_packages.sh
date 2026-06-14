#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Install tools and applications specified in the brewfile.
# We set HOMEBREW_NO_REQUIRE_TAP_TRUST=1 to avoid issues with untrusted taps
# but only for the bundle command.
if [ "$IS_TESTING" = "true" ]; then
  # In testing mode, we use --no-upgrade to speed things up
  execute "HOMEBREW_NO_REQUIRE_TAP_TRUST=1 brew bundle --no-upgrade --file ./resources/Brewfile" "Installing/Checking tools + apps from Brewfile (no-upgrade mode)"
else
  execute "HOMEBREW_NO_REQUIRE_TAP_TRUST=1 brew bundle --file ./resources/Brewfile" "Installing tools + apps from Brewfile"
fi
