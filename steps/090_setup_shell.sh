#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Oh-my-zsh (using curl directly if you prefer it outside antigen)
if [ -d ~/.oh-my-zsh ]; then
    print_success "oh-my-zsh is already installed."
else
    print_info "Installing oh-my-zsh..."
    # We set CHSH=no and RUNZSH=no to prevent the installer from changing the shell or launching zsh immediately
    sh -c "CHSH=no RUNZSH=no $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Ensure .zshrc exists (at least an empty one) so it can be used for oh-my-zsh/antigen
if [ ! -f ~/.zshrc ]; then
    touch ~/.zshrc
fi

source "./resources/install_fonts.sh"

# install starship prompt
if ! cmd_exists "starship"; then
    print_warning "Starship not found, but it should have been installed via brew bundle."
fi

# Note: starship.toml configuration is handled in step 400 (symlinked from repo)

# antigen and other tools should already be installed via Brewfile
# We check if antigen exists in common brew paths if not in PATH
if ! cmd_exists "antigen" && [ ! -f "/opt/homebrew/bin/antigen" ] && [ ! -f "/usr/local/bin/antigen" ] && [ ! -f "/opt/homebrew/share/antigen/antigen.zsh" ] && [ ! -f "/usr/local/share/antigen/antigen.zsh" ]; then
    print_warning "Antigen not found. Check your Brewfile installation."
fi



# Initial setup for asdf if installed via homebrew
if [ -f "$HOME/.asdf/asdf.sh" ]; then
    source "$HOME/.asdf/asdf.sh"
elif [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
    source /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [ -f /usr/local/opt/asdf/libexec/asdf.sh ]; then
    source /usr/local/opt/asdf/libexec/asdf.sh
fi

if cmd_exists "asdf"; then
    # Add asdf to .zshrc if not present
    if ! grep -q "asdf.sh" "$HOME/.zshrc"; then
        print_info "Adding asdf to .zshrc"
        echo "\n# asdf version manager" >> "$HOME/.zshrc"
        if [ -f "$HOME/.asdf/asdf.sh" ]; then
             echo "source $HOME/.asdf/asdf.sh" >> "$HOME/.zshrc"
        elif [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
             echo "source /opt/homebrew/opt/asdf/libexec/asdf.sh" >> "$HOME/.zshrc"
        elif [ -f /usr/local/opt/asdf/libexec/asdf.sh ]; then
             echo "source /usr/local/opt/asdf/libexec/asdf.sh" >> "$HOME/.zshrc"
        fi
    fi
fi