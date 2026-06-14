#!/usr/bin/env zsh

print_info "Loading utils..."
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Ask for sudo early to avoid multiple prompts
ask_for_sudo

# Check os
check_os

# Install Xcode Command Line Tools early to avoid popups later
install_xcode_command_line_tools

# Confirm user intent before proceeding.
confirm_install

# Collect configuration details upfront
print_info "Collecting configuration..."
ask_for_input "Please enter your email (for SSH key and Git):"
export GIT_EMAIL=$REPLY

# Try to detect the remote origin URL if it's already a git repo
if is_git_repository; then
    DETECTED_URL=$(git remote get-url origin 2>/dev/null)
fi

if [ -n "$DETECTED_URL" ]; then
    print_question "Detected remote origin: $DETECTED_URL. Use this? (y/n)"
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

# Install HomeBrew
print_step "000" "HomeBrew"
run_script "Installing HomeBrew..." "./steps/000_install_homebrew.sh"

# Install tools and applications specified in the brewfile.
print_step "010" "Brew Packages"
run_script "Installing tools + apps from Brewfile..." "./steps/010_install_brew_packages.sh"

# Set SSH key for GitHub integration.
print_step "100" "GitHub SSH Key"
run_script "Setting ssh key for github..." "./steps/100_setup_github_ssh_key.sh"

# Link local `dotfiles` folder to GitHub.
print_step "200" "Link GitHub"
run_script "Linking local dotfiles folder with github..." "./steps/200_link_github.sh"

# Create symbolic links for `Projects` folders.
print_step "300" "Symlink Folders"
run_script "Creating symlinks for Projects..." "./steps/300_symlink_folders.sh"

# Set up the shell environment.
print_step "500" "Shell Environment"
run_script "Installing zsh etc..." "./steps/500_setup_shell.sh"

# Install snazzy theme.
print_step "510" "Shell Theme"
run_script "Installing snazzy theme ..." "./steps/510_install_shell_theme.sh"

# Create symbolic links for dotfiles.
print_step "400" "Symlink Dotfiles"
run_script "Symlinking dotfiles..." "./steps/400_symlink_dotfiles.sh"

# Install asdf plugins such as node, ruby, python
print_step "620" "ASDF Plugins"
run_script "Installing asdf plugins node, ruby, python" "./steps/620_install_asdf_plugins.sh"

# Clone other repositories.
print_step "700" "GitHub Repositories"
run_script "Cloning my repositories to local..." "./steps/700_clone_github_repositories.sh"

# Install php/laravel.
#print_step "710" "PHP & Laravel"
#run_script "Installing php / laravel..." "./steps/710_install_php_laravel.sh"

# Install Xdebug for PHP debugging.
#print_step "720" "Xdebug"
#run_script "Installing Xdebug..." "./steps/720_install_xdebug.sh"

# Load macOS-specific settings/preferences.
print_step "800" "macOS Preferences"
run_script "Loading macos settings..." "./steps/800_load_macos_preferences.sh"

# Display installation summary or overview.
run_script "Showing installation overview:" "./steps/900_show_overview.sh"
