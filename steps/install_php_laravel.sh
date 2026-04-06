#!/bin/sh

composer global require laravel/valet
composer global require laravel/installer
valet install
brew install --cask phpmon