# myDotfiles


## How to install
cd ~ && mkdir 'Documents.nosync' && mkdir Documents.nosync/Projects && mkdir Documents.nosync/Projects/scripts && mkdir Documents.nosync/Projects/scripts/myDotfiles && cd Documents.nosync/Projects/scripts/myDotfiles && curl -#L https://github.com/TimVdWalle/myDotfiles/archive/master.zip | tar -xzv --strip-components 1 && chmod +x bootstrap.sh && ./bootstrap.sh


## To do's during install

### After installation of ohmyzsh
+ Type exit to make the install script continue

### Logi options
+ Open app
+ Login to my account
+ Restore backup

## Todo's after install
+ Drag projects folder into finder favourites from the Documents.nosync
+ Dual screen setup
+ Install snazzy theme also for iterm2 + terminal
  (https://github.com/sindresorhus/iterm2-snazzy)
+ To check: color syntax highlighting for vi/vim
+ Check if ZWSP is correct in starship pure prompt : does it show <200b> or correct ZWSP ?  
  ( ~/.config/starship.toml )
+ Start raycast and finnish setup
+ Do git init in every project where automatic conversion to emoji commit messages is wanted 

+ Open fork; drag myDotfiles folder into it; discard all changes; checkout master branch from origin; fetch and pull
+ When Laravel folder is empty: delete laravel folder and run script again