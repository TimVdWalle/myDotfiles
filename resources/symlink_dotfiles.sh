#!/bin/sh

# Directory containing the dotfiles
dotfiles_dir=~/Projects/scripts/myDotfiles/dotfiles/

# Your home directory
home_dir=~

# List of dotfiles to potentially symlink
list_of_dotfiles=".hyper.js .zprofile .zshrc"

# Loop through each file and create a symlink only if the file exists in the dotfiles directory
for file in $list_of_dotfiles; do
  if [ -f "$dotfiles_dir/$file" ]; then
    # Remove existing file in the home directory if it exists
    if [ -f "$home_dir/$file" ] || [ -L "$home_dir/$file" ]; then
      echo "Removing existing $file in home directory."
      rm "$home_dir/$file"
    fi

    # Create a new symlink
    echo "Creating symlink for $file."
    ln -s "$dotfiles_dir/$file" "$home_dir/$file"
  else
    echo "Skipping $file since it does not exist in $dotfiles_dir."
  fi
done

echo "Dotfiles have been symlinked."
print_after_newline "print_with_newline"