#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Ensure asdf is available in the current subshell
if [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
    source /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [ -f /usr/local/opt/asdf/libexec/asdf.sh ]; then
    source /usr/local/opt/asdf/libexec/asdf.sh
fi

# Prepare summary table data
summary_data=$(cat <<EOF
Tool | Status | Version
Shell | ✅ | $SHELL
Homebrew | ✅ | $(brew --version | head -n 1)
asdf | ✅ | $(asdf --version)
Node | ✅ | $(node -v)
Ruby | ✅ | $(ruby -v | head -n 1 | awk '{print $1" "$2}')
Python | ✅ | $(python3 --version | awk '{print $2}')
EOF
)

print_info "Installation Summary:"
echo "$summary_data" | print_table

print_success "Installation complete!"