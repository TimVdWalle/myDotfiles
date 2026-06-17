#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Ensure asdf is available in the current subshell
if [ -f "$HOME/.asdf/asdf.sh" ]; then
    source "$HOME/.asdf/asdf.sh"
elif [ -f "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]; then
    source "/opt/homebrew/opt/asdf/libexec/asdf.sh"
elif [ -f "/usr/local/opt/asdf/libexec/asdf.sh" ]; then
    source "/usr/local/opt/asdf/libexec/asdf.sh"
fi

# Ensure asdf shims are in PATH
export PATH="$HOME/.asdf/shims:$PATH"

# Prepare summary table data
check_tool() {
    local cmd="$1"
    local name="$2"
    local version_cmd="$3"
    local tool_status="❌"
    local tool_version="not installed"

    if command -v "$cmd" &> /dev/null; then
        tool_status="✅"
        tool_version=$(eval "$version_cmd" 2>/dev/null)
    fi
    echo "$name | $tool_status | $tool_version"
}

summary_data="Tool | Status | Version
$(check_tool "zsh" "Shell" "echo $SHELL")
$(check_tool "brew" "Homebrew" "brew --version | head -n 1")
$(check_tool "asdf" "asdf" "asdf --version")
$(check_tool "node" "Node" "node -v")
$(check_tool "ruby" "Ruby" "ruby -v | head -n 1 | awk '{print \$1\" \"\$2}'")
$(check_tool "python3" "Python" "python3 --version | awk '{print \$2}'")"

echo "$summary_data" | print_table

print_success "Installation complete!"