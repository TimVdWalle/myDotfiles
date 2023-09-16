#!/bin/sh

brew install php
pecl install xdebug

echo "Update php.ini: find correct location of php.ini in Herd UI"
echo "See documentation on : https://herd.laravel.com/docs/1/advanced-usage/xdebug"
echo "Press enter to continue"
read waiting

print_after_newline "print_with_newline"
