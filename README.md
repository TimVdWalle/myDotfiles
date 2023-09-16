***
chmod +x bootstrap.sh

***
./bootstrap.sh
# myDotfiles

***

mkdir 'Documents.nosync' && mkdir Documents.nosync/Projects && mkdir Documents.nosync/Projects/scripts && cd Documents.nosync/Projects/scripts && curl -#L https://github.com/TimVdWalle/myDotfiles/archive/master.zip | tar -xzv --strip-components 1 && chmod +x bootstrap.sh && ./bootstrap.sh
