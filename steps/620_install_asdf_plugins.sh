#!/usr/bin/env zsh

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

print_after_newline "print_with_newline"
