#!/bin/sh

export PATH="$PATH:$HOME/Library/Application Support/Herd/bin/"
php --version
print_after_newline "print_with_newline"
laravel --version
print_after_newline "print_with_newline"
composer --version
print_after_newline "print_with_newline"
echo $SHELL
print_after_newline "print_with_newline"
#eval "$(starship init zsh)"

#echo "Testing fonts..."
#source ./resources/test-fonts.sh



print_after_newline "print_with_newline"