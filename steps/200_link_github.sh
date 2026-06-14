#!/usr/bin/env zsh

print_info "Checking git installation..."
if ! cmd_exists "git"; then
    execute "brew install git" "Installing git"
fi

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
    execute "git remote add origin git@github.com:TimVdWalle/myDotfiles.git" "Adding origin"
fi

print_after_newline "print_with_newline"