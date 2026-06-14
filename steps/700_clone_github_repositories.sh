#!/usr/bin/env zsh
source "./resources/utils.sh"
source "./resources/utils-macos.sh"

LARAVEL=~/Projects/Laravel/
OTHER=~/Projects/Other/
JS=~/Projects/JavaScript/
RUBY=~/Projects/Ruby/

mkd "$LARAVEL"
mkd "$OTHER"
mkd "$JS"
mkd "$RUBY"

clone_repo() {
    local url="$1"
    local dest="$2"
    local msg="$3"
    if [ ! -d "$dest" ]; then
        execute "git clone $url $dest" "$msg"
    else
        print_success "$msg (already cloned)"
    fi
}

clone_repo "git@github.com:TimVdWalle/dart-score.git" "$LARAVEL/dart-score" "Cloning dart-score"
clone_repo "git@github.com:TimVdWalle/commit-verbs.git" "$OTHER/commit-verbs" "Cloning commit-verbs"
clone_repo "git@github.com:TimVdWalle/phpstan-watcher.git" "$JS/phpstan-watcher" "Cloning phpstan-watcher"
clone_repo "git@github.com:TimVdWalle/request_viewer.git" "$RUBY/request-viewer" "Cloning request-viewer"

# setup git hook script(s)
if [ -f "$OTHER/commit-verbs/git-templates/hooks/prepare-commit-msg" ]; then
  chmod +x "$OTHER/commit-verbs/git-templates/hooks/prepare-commit-msg"
  execute "git config --global init.templateDir $OTHER/commit-verbs/git-templates" "Setting up git init template"
fi

print_success "GitHub repositories check complete."
