#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

if [ ! -e ~/Projects ]; then
  # Ensure the target directory exists
  mkdir -p ~/Documents.nosync/Projects/
  ln -s ~/Documents.nosync/Projects/ ~/Projects
else
  # Silent if already exists, as requested for cleaner output
  :
fi
