#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Ensure asdf is available in the current subshell
if [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
    source /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [ -f /usr/local/opt/asdf/libexec/asdf.sh ]; then
    source /usr/local/opt/asdf/libexec/asdf.sh
fi

if ! cmd_exists "asdf"; then
    print_error "asdf command not found. Please ensure it is installed via Homebrew."
    exit 1
fi

plugins=("nodejs" "ruby" "python")

for plugin in "${plugins[@]}"; do
    if ! asdf plugin list | grep -q "$plugin"; then
        execute "asdf plugin add $plugin" "Adding asdf plugin: $plugin"
    else
        print_success "asdf plugin $plugin already added."
    fi
    execute "asdf install $plugin latest" "Installing latest $plugin"
    execute "asdf global $plugin latest" "Setting global $plugin to latest"
done

