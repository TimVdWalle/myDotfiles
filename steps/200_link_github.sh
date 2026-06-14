#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

cd "$(dirname "$0")/.."

# Check if git is initialized in the current directory
if ! is_git_repository; then
    print_info "Not a git repository. Initializing..."
    execute "git init" "Initializing git"
else
    print_success "Already a git repository."
fi

# Check if 'origin' remote is already set
if git remote -v | grep -q "origin"; then
    print_success "Origin already set."
else
    print_info "Setting origin..."
    if [ -n "$DOTFILES_REMOTE" ]; then
        url=$DOTFILES_REMOTE
    else
        ask_for_input "Please enter the remote URL for your dotfiles (git@github.com:username/repo.git):"
        url=$REPLY
    fi
    execute "git remote add origin $url" "Adding origin: $url"
fi
