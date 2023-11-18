#!/bin/sh

brew install git
cd ~/Projects/scripts/myDotfiles

# Check if git is initialized in the current directory
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "Not a git repository. Initializing..."
    git init
else
    echo "Already a git repository."
fi

# Check if 'origin' remote is already set
if git remote -v | grep -q "origin"; then
    echo "Origin already set."
    echo "Skipping."
else
    echo "Setting origin..."
    git remote add origin git@github.com:TimVdWalle/myDotfiles.git
    git init
fi

print_after_newline "print_with_newline"