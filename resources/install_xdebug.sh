#!/bin/sh

ask_for_confirmation "Do you want to setup xdebug?"
if answer_is_yes; then
  brew install php
  pecl install xdebug

  echo "Xdebug setup needs brew install php as long as xdebug is not included in herd"
  echo "Update php.ini: find correct location of php.ini in Herd UI"
  echo "See documentation on : https://herd.laravel.com/docs/1/advanced-usage/xdebug"
  echo "Press enter to continue"
  read waiting

  print_after_newline "print_with_newline"
else
    print_after_newline "print_with_newline"
    echo "Skipping xdebug setup"
fi;

print_after_newline "print_with_newline"





