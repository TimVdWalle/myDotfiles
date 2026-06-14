#!/usr/bin/env zsh

# Directory containing the dotfiles
dotfiles_dir="$(cd "$(dirname "$0")/.." && pwd)/dotfiles"

# Your home directory
home_dir=~

# List of dotfiles to potentially symlink
list_of_dotfiles=(".hyper.js" ".zprofile" ".zshrc" ".antigenrc" ".config/starship.toml")

# Loop through each file and create a symlink only if the file exists in the dotfiles directory
for file in "${list_of_dotfiles[@]}"; do
  target_file="$dotfiles_dir/$file"
  link_file="$home_dir/$file"

  if [ -f "$target_file" ]; then
    # Ensure parent directory exists for files like .config/starship.toml
    mkdir -p "$(dirname "$link_file")"

    # Remove existing file in the home directory if it exists
    if [ -f "$link_file" ] || [ -L "$link_file" ]; then
      print_info "Removing existing $file in home directory."
      rm "$link_file"
    fi

    # Create a new symlink
    execute "ln -s $target_file $link_file" "Creating symlink for $file"
  else
    print_warning "Skipping $file since it does not exist in $dotfiles_dir."
  fi
done

print_success "Dotfiles have been symlinked."