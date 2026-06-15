#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

if [ ! -f ~/.ssh/id_ed25519 ]; then
    print_info "Generating ssh key for github..."

    if [ -n "$GIT_EMAIL" ]; then
        email=$GIT_EMAIL
    else
        ask_for_input "Please enter your email:"
        email=$REPLY
    fi
    print_info "SSH key will be created with label: $email"

    # Generating a new SSH key
    # https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
    execute "ssh-keygen -t ed25519 -C $email -f ~/.ssh/id_ed25519 -N ''" "Generating SSH key"

    # Adding your SSH key to the ssh-agent
    # https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
    mkdir -p ~/.ssh
    touch ~/.ssh/config
    if ! grep -q "id_ed25519" ~/.ssh/config; then
        print_info "Updating SSH config..."
        echo "Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config
    fi
    execute "eval \"\$(ssh-agent -s)\" && ssh-add --apple-use-keychain ~/.ssh/id_ed25519" "Adding SSH key to agent"

    # Adding your SSH key to your GitHub account
    # https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
    print_info "run 'pbcopy < ~/.ssh/id_ed25519.pub' and paste that into GitHub"
    pbcopy < ~/.ssh/id_ed25519.pub
    cat ~/.ssh/id_ed25519.pub
    print_success "Copied to clipboard"

    print_warning "Halt: Please add the SSH key above to your GitHub account (https://github.com/settings/keys) before continuing."
    ask_to_continue
    
    while true; do
        print_info "Checking GitHub connectivity..."
        # ssh -T returns 1 on success for GitHub (it greets you but doesn't provide shell access)
        # We check the exit code and the output.
        # GitHub's successful auth message is on stderr.
        ssh_output=$(ssh -T -o ConnectTimeout=5 -o StrictHostKeyChecking=no git@github.com 2>&1)
        if [[ "$ssh_output" == *"successfully authenticated"* ]]; then
            print_success "GitHub connectivity verified!"
            break
        else
            print_error "Connection failed or key not yet recognized."
            print_info "Output: $ssh_output"
            print_question "Try again? (y) or press any other key to wait 10 seconds and retry automatically... "
            # Use </dev/tty to ensure read works when script is run via source or pipe, 
            # though here it is run via run_script which calls it.
            read -r -t 10 response < /dev/tty
            if [[ "$response" != "y" ]]; then
                print_info "Waiting 10 seconds..."
                sleep 10
            fi
        fi
    done
else
    print_success "SSH key already exists for GitHub."
    # Even if it exists, good to verify connectivity if we are about to clone repos
    if ! ssh -T -o ConnectTimeout=5 -o StrictHostKeyChecking=no git@github.com 2>&1 | grep -q "successfully authenticated"; then
        print_warning "SSH key exists but GitHub connectivity failed. Please check your SSH agent or GitHub settings."
        ask_to_continue
    fi
fi

