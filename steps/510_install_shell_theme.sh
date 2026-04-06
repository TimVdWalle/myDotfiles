#!/bin/sh

# Install the color scheme that goes beautifully with the pure prompt
# Installing hyper theme before hyper was opened for the first time makes it crash
echo "Open hyper terminal app, and close it again"
echo "Press enter to continue..."
read waiting
hyper install hyper-snazzy

print_after_newline "print_with_newline"
