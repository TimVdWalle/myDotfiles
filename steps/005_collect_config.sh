#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Collect configuration details upfront
print_info "Collecting configuration..."

if [ -z "$GIT_EMAIL" ]; then
    ask_for_input "Please enter your email (for SSH key and Git):"
    export GIT_EMAIL=$REPLY
fi

# Try to detect the remote origin URL if it's already a git repo
DETECTED_URL=""
if is_git_repository; then
    DETECTED_URL=$(git remote get-url origin 2>/dev/null)
fi

if [ -n "$DETECTED_URL" ]; then
    print_info "We detected that this folder is already linked to a GitHub repository:"
    print_info "  $DETECTED_URL"
    print_question "Should we use this as the primary remote for your dotfiles? (y/n)"
    print_info "(This will be used to link your local configuration to your online GitHub repository)"
    read -r
    if answer_is_yes; then
        export DOTFILES_REMOTE=$DETECTED_URL
    fi
fi

if [ -z "$DOTFILES_REMOTE" ]; then
    while true; do
        ask_for_input "Please enter the remote URL for your dotfiles repository (e.g. git@github.com:username/repo.git):"
        url=$REPLY
        # Simple regex for git@github.com:user/repo.git or https://github.com/user/repo.git
        if [[ "$url" =~ ^(git@github\.com:|https://github\.com/)[a-zA-Z0-9._-]+/[a-zA-Z0-9._-]+\.git$ ]]; then
            export DOTFILES_REMOTE=$url
            break
        else
            print_error "Invalid format. Please use 'git@github.com:user/repo.git' or 'https://github.com/user/repo.git'"
        fi
    done
fi
