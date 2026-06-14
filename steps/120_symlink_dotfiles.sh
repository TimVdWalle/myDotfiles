#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

# Directory containing the dotfiles
dotfiles_dir="$(cd "$(dirname "$0")/.." && pwd)/dotfiles"

# Your home directory
home_dir=~

# List of dotfiles to potentially symlink
list_of_dotfiles=(".hyper.js" ".zprofile" ".zshrc" ".antigenrc" ".config/starship.toml")

# Special handling for starship.toml fallback
starship_repo_path="$dotfiles_dir/.config/starship.toml"
if [ ! -f "$starship_repo_path" ]; then
    print_info "Starship config not found in repository. Generating default (pure-preset) in repo..."
    mkdir -p "$(dirname "$starship_repo_path")"
    if cmd_exists "starship"; then
        starship preset pure-preset -o "$starship_repo_path"
    else
        print_warning "Starship not installed yet, cannot generate default config in repo."
    fi
fi

# Loop through each file and create a symlink only if the file exists in the dotfiles directory
for file in "${list_of_dotfiles[@]}"; do
  target_file="$dotfiles_dir/$file"
  link_file="$home_dir/$file"

  if [ -f "$target_file" ] || [ -d "$target_file" ]; then
    # Ensure parent directory exists for files like .config/starship.toml
    mkdir -p "$(dirname "$link_file")"

    # Remove existing file in the home directory if it exists
    if [ -L "$link_file" ]; then
      print_info "Removing existing symlink $file in home directory."
      rm "$link_file"
    elif [ -e "$link_file" ]; then
      print_warning "Backing up existing file/directory $file to $file.bak"
      mv "$link_file" "$link_file.bak"
    fi

    # Create a new symlink
    execute "ln -s $target_file $link_file" "Creating symlink for $file"
  else
    # Check if it's .zshrc and if it exists in home dir but not in repo
    if [[ "$file" == ".zshrc" ]] && [[ -f "$link_file" ]] && [[ ! -f "$target_file" ]]; then
       print_info "Found .zshrc in home but not in repo. Moving it to repo to track it."
       mkdir -p "$(dirname "$target_file")"
       mv "$link_file" "$target_file"
       execute "ln -s $target_file $link_file" "Creating symlink for $file"
    else
       print_warning "Skipping $file since it does not exist in $dotfiles_dir."
    fi
  fi
done

print_success "Dotfiles have been symlinked."