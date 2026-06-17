#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

if [ ! -f ~/.ssh/id_ed25519 ]; then
    if [ -n "$GIT_EMAIL" ]; then
        email=$GIT_EMAIL
    else
        ask_for_input "Enter email for SSH key:"
        email=$REPLY
    fi

    # Generating a new SSH key
    # https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
    execute "ssh-keygen -t ed25519 -C $email -f ~/.ssh/id_ed25519 -N ''" "Generating SSH key"

    mkdir -p ~/.ssh
    touch ~/.ssh/config
    if ! grep -q "id_ed25519" ~/.ssh/config; then
        echo "Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config
    fi

    # Adding your SSH key to the ssh-agent
    # https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
    execute "eval \"\$(ssh-agent -s)\" && ssh-add --apple-use-keychain ~/.ssh/id_ed25519" "Adding SSH key to agent"

    # Adding your SSH key to your GitHub account
    # https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
    print_info "Your public SSH key:"
    sed 's/^/  🗝️  /' ~/.ssh/id_ed25519.pub
    
    pbcopy < ~/.ssh/id_ed25519.pub
    print_info "Public key copied to clipboard (using 'pbcopy < ~/.ssh/id_ed25519.pub')."
    print_info "Paste it here: https://github.com/settings/keys"
    
    print_info "Please add the key to your GitHub account to continue."
    print_in_blue "  ⌨️  Press any key to continue…"
    # Using 'read -r -k 1' to wait for a single character in zsh
    read -r -k 1
    print_with_newline
    
    while true; do
        print_in_blue "  🔹 Verifying GitHub authentication... "
        # ssh -T returns 1 on success for GitHub (it greets you but doesn't provide shell access)
        if ssh -T -o ConnectTimeout=5 -o StrictHostKeyChecking=no git@github.com 2>&1 | grep -q "successfully authenticated"; then
            print_in_green "success!\n"
            break
        else
            print_in_red "failed\n"
            print_question "Try again? (y) or wait 10s to retry automatically... "
            # shellcheck disable=SC2162
            read -r -t 10 response < /dev/tty
            if [[ "$response" != "y" ]]; then
                print_with_newline
                # Count down or just wait
                sleep 10
            fi
        fi
    done
else
    print_success "SSH key already exists"
    if ! ssh -T -o ConnectTimeout=5 -o StrictHostKeyChecking=no git@github.com 2>&1 | grep -q "successfully authenticated"; then
        print_warning "Auth failed. Please check your GitHub settings."
        ask_to_continue
    fi
fi

