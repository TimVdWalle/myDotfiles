#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Ensure asdf is available in the current subshell
if [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
    source /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [ -f /usr/local/opt/asdf/libexec/asdf.sh ]; then
    source /usr/local/opt/asdf/libexec/asdf.sh
fi

print_step 900 "Installation Overview"

print_info "Shell: $SHELL"
print_info "Homebrew: $(brew --version | head -n 1)"
print_info "asdf: $(asdf --version)"
print_info "Node: $(node -v)"
print_info "Ruby: $(ruby -v | head -n 1)"
print_info "Python: $(python3 --version)"

print_success "Installation complete!"