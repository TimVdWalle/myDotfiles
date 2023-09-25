#!/bin/sh

LARAVEL=~/Projects/Laravel/

if [ ! -e $LARAVEL ]; then
  mkdir $LARAVEL

  git clone git@github.com:TimVdWalle/perfume-picker.git $LARAVEL/perfume-picker
  #git clone git@github.com:laravel/blog.laravel.com.git $SITES/blog.laravel.com

  echo "GitHub repositories cloned to local."
else
  echo "GitHub repositories already cloned to local."
  echo "Skipping."
fi

print_after_newline "print_with_newline"