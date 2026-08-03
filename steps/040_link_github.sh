#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Store original directory to return back after execution
pushd "$(dirname "$0")/.." > /dev/null

# Check if git is initialized in the current directory
if ! is_git_repository; then
    # Suppress the advice about default branch name by setting it explicitly
    git config --global init.defaultBranch main
    git init &>/dev/null
    print_success "Initialized git"
fi

# Check for 'origin' remote is already set
if git remote -v | grep -q "origin"; then
    :
else
    print_info "Setting origin..."
    if [ -n "$DOTFILES_REMOTE" ]; then
        url=$DOTFILES_REMOTE
    else
        ask_for_input "Please enter the remote URL for your dotfiles (git@github.com:username/repo.git):"
        url=$REPLY
    fi
    git remote add origin "$url" &>/dev/null
fi

popd > /dev/null
