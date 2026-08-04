#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Homebrew exits immediately when another brew process has locked a shared
# dependency. A fresh Mac setup can briefly overlap with another installer, so
# retry only that transient failure instead of aborting the entire bootstrap.
brew_bundle_with_lock_retry() {
  local -a bundle_args=(--file ./resources/brewfile)
  local attempt=1
  local max_attempts=12
  local output_file
  local brew_exit

  if [ "$IS_TESTING" = "true" ]; then
    bundle_args=(--no-upgrade "${bundle_args[@]}")
  fi

  output_file=$(mktemp "${TMPDIR:-/tmp}/mydotfiles-brew.XXXXXX") || return 1

  while true; do
    HOMEBREW_NO_REQUIRE_TAP_TRUST=1 brew bundle "${bundle_args[@]}" 2>&1 | tee "$output_file"
    brew_exit=${pipestatus[1]}

    if [ "$brew_exit" -eq 0 ]; then
      rm -f "$output_file"
      return 0
    fi

    if ! grep -Eq "has already locked|Another active Homebrew process" "$output_file" || [ "$attempt" -ge "$max_attempts" ]; then
      rm -f "$output_file"
      return "$brew_exit"
    fi

    print_warning "Another Homebrew process holds a lock. Retrying in 10 seconds (${attempt}/${max_attempts})..."
    attempt=$((attempt + 1))
    sleep 10
    : > "$output_file"
  done
}

if [ "$IS_TESTING" = "true" ]; then
  execute "brew_bundle_with_lock_retry" "Installing/Checking tools + apps from brewfile (no-upgrade mode)"
else
  execute "brew_bundle_with_lock_retry" "Installing tools + apps from brewfile"
fi
