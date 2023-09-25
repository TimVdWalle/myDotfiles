#!/bin/sh

if [ ! -e ~/Projects ]; then
  ln -s ~/Documents.nosync/Projects/ ~/
else
  echo "The directory or symlink '~/Projects' already exists."
  echo "Skipping."
fi

print_after_newline "print_with_newline"