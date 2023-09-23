#!/bin/sh

# Check if xdebug is installed
if ! pecl list | grep -q xdebug; then
  brew install php
  pecl install xdebug

  echo "Xdebug setup needs brew install php as long as xdebug is not included in herd"
  echo "Update php.ini: find correct location of php.ini in Herd UI"
  echo "See documentation on : https://herd.laravel.com/docs/1/advanced-usage/xdebug"
  echo "Press enter to continue"
  read waiting
else
    echo "Xdebug is already installed"
fi;

print_after_newline "print_with_newline"
