#!/bin/sh

# https://docs.devsense.com/en/vscode/debug/xdebug-mac
ARCHITECTURE=$(uname -m)

# Check if xdebug is installed
if ! php -m | grep -q xdebug; then
  # Check architecture and execute appropriate commands
  if [ "$ARCHITECTURE" = "x86_64" ]; then
    # Commands for Intel
    echo "Detected Intel architecture. Running Intel-specific commands."
    brew install php
    pecl install xdebug
  elif [ "$ARCHITECTURE" = "arm64" ]; then
    # Commands for M1/M2/Mx
    echo "Detected M1/M2/Mx architecture. Running M1/M2/Mx-specific commands."
    # Currently, the same commands as for Intel are used. Adjust if necessary.
    brew install php
    arch -arm64 sudo pecl install xdebug
  else
    echo "Unknown architecture detected."
    brew install php
    pecl install xdebug
    # maybe this works here ? :
    # arch -x86_64 sudo pecl install xdebug   # https://xdebug.org/docs/install
  fi

  echo "Xdebug setup needs brew install php as long as xdebug is not included in herd"
  echo "Update php.ini: find correct location of php.ini in Herd UI"
  echo "See documentation on : https://herd.laravel.com/docs/1/advanced-usage/xdebug"
  echo "Press enter to continue"
  read waiting
else
    echo "Xdebug is already installed."
    echo "Skipping."
fi;

print_after_newline "print_with_newline"
