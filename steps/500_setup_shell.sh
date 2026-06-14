#!/usr/bin/env zsh

# Install zsh with brew
if ! brew list zsh &> /dev/null; then
    execute "brew install zsh" "Installing zsh with brew"
else
    print_success "zsh is already installed via brew."
fi

# Install oh-my-zsh
if [ -d ~/.oh-my-zsh ]; then
	print_success "oh-my-zsh is already installed."
else
 	print_info "Installing oh-my-zsh..."
 	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

source "./resources/install_fonts.sh"

# install starship prompt
if ! cmd_exists "starship"; then
    execute "brew install starship" "Installing starship"
fi

if [ -f ~/.config/starship.toml ]; then
  print_success "starship prompt already configured."
else
  print_info "Setting up pure prompt with starship..."
  mkdir -p ~/.config
  starship preset pure-preset -o ~/.config/starship.toml
fi

# install antigen and other shell tools
execute "brew install antigen chroma ccat" "Installing shell tools (antigen, chroma, ccat)"

print_after_newline "print_with_newline"

print_after_newline "print_with_newline"
