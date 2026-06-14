#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

if [ ! -e ~/Projects ]; then
  # Ensure the target directory exists
  mkdir -p ~/Documents.nosync/Projects/
  execute "ln -s ~/Documents.nosync/Projects/ ~/" "Creating Projects symlink"
else
  print_success "The directory or symlink '~/Projects' already exists."
fi
