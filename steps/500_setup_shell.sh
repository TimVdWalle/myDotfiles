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

source "./resources/install_fonts.sh"

# install starship prompt
if ! cmd_exists "starship"; then
    print_warning "Starship not found, but it should have been installed via brew bundle."
fi

# Note: starship.toml configuration is handled in step 400 (symlinked from repo)

# antigen and other tools should already be installed via Brewfile
if ! cmd_exists "antigen"; then
    print_warning "Antigen not found. Check your Brewfile installation."
fi


