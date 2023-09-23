#!/bin/sh


ask_for_confirmation "Do you want to setup a new ssh key for github?"
if answer_is_yes; then
    print_after_newline "print_with_newline"
    echo "Generating ssh key for github"

    echo "Please enter your email"
    read email
    echo "SSH key will be created with label: $email"

    # Generating a new SSH key
    # https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
    ssh-keygen -t ed25519 -C $email -f ~/.ssh/id_ed25519

    # Adding your SSH key to the ssh-agent
    # https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
    eval "$(ssh-agent -s)"

    touch ~/.ssh/config
    echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_ed25519" | tee ~/.ssh/config

    ssh-add ~/.ssh/id_ed25519 --apple-use-keychain

    # Adding your SSH key to your GitHub account
    # https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
    echo "run 'pbcopy < ~/.ssh/id_ed25519.pub' and paste that into GitHub"
    echo "Press enter to continue..."
    read waiting
else
    print_after_newline "print_with_newline"
    echo "Skipping creation of ssh key for github"
fi;

print_after_newline "print_with_newline"
