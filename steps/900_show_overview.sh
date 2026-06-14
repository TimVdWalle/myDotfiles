#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

print_step 900 "Installation Overview"

print_info "Shell: $SHELL"
print_info "Homebrew: $(brew --version | head -n 1)"
print_info "asdf: $(asdf --version)"
print_info "Node: $(node -v)"
print_info "Ruby: $(ruby -v | head -n 1)"
print_info "Python: $(python3 --version)"

print_success "Installation complete!"