#!/usr/bin/env zsh

if [ ! -e ~/Projects ]; then
  execute "ln -s ~/Documents.nosync/Projects/ ~/" "Creating Projects symlink"
else
  print_success "The directory or symlink '~/Projects' already exists."
fi
