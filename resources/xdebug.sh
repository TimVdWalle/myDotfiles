#!/bin/sh

brew install php
pecl install xdebug

echo "Update php.ini: find correct location of php.ini in Herd UI"
echo "see documentation on : https://herd.laravel.com/docs/1/advanced-usage/xdebug"
read waiting
