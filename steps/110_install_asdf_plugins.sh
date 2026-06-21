#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Ensure asdf is available in the current subshell
if [ -f "$HOME/.asdf/asdf.sh" ]; then
    source "$HOME/.asdf/asdf.sh"
elif [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
    source /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [ -f /usr/local/opt/asdf/libexec/asdf.sh ]; then
    source /usr/local/opt/asdf/libexec/asdf.sh
fi

# Ensure asdf shims are in PATH
export PATH="$HOME/.asdf/shims:$PATH"

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
    if [ "$plugin" = "ruby" ]; then
        # Ensure libyaml and other dependencies from homebrew are used
        export RUBY_CONFIGURE_OPTS="--with-libyaml-dir=$(brew --prefix libyaml) --with-openssl-dir=$(brew --prefix openssl) --with-readline-dir=$(brew --prefix readline) --with-gmp-dir=$(brew --prefix gmp)"
    fi
    execute "asdf install $plugin latest" "Installing latest $plugin"
    execute "asdf global $plugin latest" "Setting global $plugin to latest"
    asdf reshim
done

