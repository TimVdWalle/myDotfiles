#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

if [ ! -e ~/Projects ]; then
  # Ensure the target directory exists
  mkdir -p ~/Documents.nosync/Projects/
  ln -s ~/Documents.nosync/Projects/ ~/Projects
  print_success "Created Projects symlink"
else
  print_success "The directory or symlink '~/Projects' already exists."
fi
