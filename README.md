***
chmod +x bootstrap.sh

***
./bootstrap.sh
# myDotfiles

***
How to install:
***
cd ~ && mkdir 'Documents.nosync' && mkdir Documents.nosync/Projects && mkdir Documents.nosync/Projects/scripts && mkdir Documents.nosync/Projects/scripts/myDotfiles && cd Documents.nosync/Projects/scripts/myDotfiles && curl -#L https://github.com/TimVdWalle/myDotfiles/archive/master.zip | tar -xzv --strip-components 1 && chmod +x bootstrap.sh && ./bootstrap.sh



***

***

***

to check after install:
snazzy theme ook installeren voor iterm2 + terminal (zodat kleuren ook werken indien niet in hyper)
color syntax highlighting for vi/vim

***

logioptions:
login in my account ('more' button / 'meer' button, and restore backup)

after installation of ohmyzsh:
type exit to make install script continue

start herd: open php.ini
add this to php.ini (for intel):
# Absolute path to the xdebug.so file
zend_extension=/usr/local/lib/php/pecl/20220829/xdebug.so

# Enable Xdebug
xdebug.mode=debug



drag Projects folder into finder ; from Documents.nosync folder
