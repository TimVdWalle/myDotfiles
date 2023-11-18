#!/bin/sh

LARAVEL=~/Projects/Laravel/
OTHER=~/Projects/Other/
JS=~/Projects/JavaScript/

if [ ! -e $LARAVEL ]; then
  mkdir $LARAVEL
  mkdir $OTHER
  mkdir JS

  git clone git@github.com:TimVdWalle/perfume-picker.git $LARAVEL/perfume-picker
  git clone git@github.com:TimVdWalle/text2playlist.git $LARAVEL/text2playlist
  git clone git@github.com:TimVdWalle/dart-score.git $LARAVEL/dart-score

  git clone git@github.com:TimVdWalle/commit-verbs.git $OTHER/commit-verbs

  git clone git@github.com:TimVdWalle/phpstan-watcher.git $JS/phpstan-watcher

  # setup git hook script(s)
  chmod +x $OTHER/commit-verbs/git-templates/hooks/prepare-commit-msg
  git config --global init.templateDir $OTHER/commit-verbs/git-templates

  echo "GitHub repositories cloned to local."
else
  echo "GitHub repositories already cloned to local."
  echo "Skipping."
fi

print_after_newline "print_with_newline"