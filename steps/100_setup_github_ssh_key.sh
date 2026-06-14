#!/usr/bin/env zsh

if [ ! -f ~/.ssh/id_ed25519 ]; then
    print_info "Generating ssh key for github..."

    ask_for_input "Please enter your email:"
    email=$REPLY
    print_info "SSH key will be created with label: $email"

    # Generating a new SSH key
    # https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
    execute "ssh-keygen -t ed25519 -C $email -f ~/.ssh/id_ed25519 -N ''" "Generating SSH key"

    # Adding your SSH key to the ssh-agent
    # https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
    eval "$(ssh-agent -s)"

    touch ~/.ssh/config
    echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_ed25519" | tee ~/.ssh/config

    ssh-add ~/.ssh/id_ed25519 --apple-use-keychain

    # Adding your SSH key to your GitHub account
    # https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
    print_info "run 'pbcopy < ~/.ssh/id_ed25519.pub' and paste that into GitHub"
    pbcopy < ~/.ssh/id_ed25519.pub
    cat ~/.ssh/id_ed25519.pub
    print_success "Copied to clipboard"
    ask_to_continue
else
    print_success "SSH key already exists for GitHub."
fi

