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
elif [ -f "/opt/homebrew/opt/asdf/asdf.sh" ]; then
    source "/opt/homebrew/opt/asdf/asdf.sh"
elif [ -f "/usr/local/opt/asdf/asdf.sh" ]; then
    source "/usr/local/opt/asdf/asdf.sh"
fi

# Ensure Homebrew and asdf are in PATH
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Ensure asdf shims are in PATH
export PATH="$HOME/.asdf/shims:$PATH"

# Trigger asdf to use the installed versions in this shell
if cmd_exists "asdf"; then
    asdf reshim
fi

# Prepare summary table data
check_tool() {
    local cmd="$1"
    local name="$2"
    local version_cmd="$3"
    local tool_status="❌"
    local tool_version="not installed"

    if command -v "$cmd" &> /dev/null; then
        tool_status="✅"
        # Combine stdout and stderr, then take the first non-empty line
        tool_version=$(eval "$version_cmd" 2>&1 | grep -v "No version is set" | head -n 1 | xargs)
        if [ -z "$tool_version" ]; then
            tool_version="installed"
        fi
    fi
    echo "$name | $tool_status | $tool_version"
}

summary_data="Tool | Status | Version
$(check_tool "zsh" "Shell" "echo $SHELL")
$(check_tool "brew" "Homebrew" "brew --version | head -n 1")
$(check_tool "asdf" "asdf" "asdf --version")
$(check_tool "node" "Node" "node -v")
$(check_tool "ruby" "Ruby" "ruby -v")
$(check_tool "python3" "Python" "python3 --version")"

echo "$summary_data" | print_table

if [ -n "$LOG_FILE" ]; then
    print_with_newline
    print_info "Detailed logs are available at: $LOG_FILE"
fi

print_success "Installation complete!"