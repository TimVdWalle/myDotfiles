
#export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH


# Homebrew path detection
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# asdf configuration
if [ -f "$HOME/.asdf/asdf.sh" ]; then
    source "$HOME/.asdf/asdf.sh"
elif [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh" ]; then
    source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"
elif [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/opt/asdf/asdf.sh" ]; then
    source "$HOMEBREW_PREFIX/opt/asdf/asdf.sh"
fi

# Fallback for asdf shims if asdf.sh is not found or didn't add them
if [ -d "$HOME/.asdf/shims" ]; then
    export PATH="$HOME/.asdf/shims:$PATH"
fi

# Ensure /usr/local/bin and /opt/homebrew/bin are in PATH for asdf and brew
export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="avit"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
ZSH_COLORIZE_TOOL=chroma

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

#. $(brew --prefix asdf)/libexec/asdf.sh

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


##########
# ruby
##########
#eval "$(rbenv init -)"



#############################################
#
#   Setup for pure prompt
#
#############################################
#autoload -U promptinit; promptinit

# optionally define some options
#PURE_CMD_MAX_EXEC_TIME=10

# change the path color
#zstyle :prompt:pure:path color white

# change the color for both `prompt:success` and `prompt:error`
#zstyle ':prompt:pure:prompt:success' color blue

# turn on git stash status
#zstyle :prompt:pure:git:stash show yes

#prompt pure


#############################################
#
#   starship / pure prompt
#
#############################################
eval "$(starship init zsh)"
#SPACESHIP_DIR_TRUNC_REPO=false


# Antigen configuration
if [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/share/antigen/antigen.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/antigen/antigen.zsh"
elif [ -f "/usr/local/share/antigen/antigen.zsh" ]; then
    source "/usr/local/share/antigen/antigen.zsh"
fi

#antigen init $HOME/.antigenrc


#############################################
#
#   the fuck
#   https://github.com/nvbn/thefuck#installation
#
#############################################
#eval $(thefuck --alias FUCK)
#eval $(thefuck --alias)



#############################################
#
#   my terminal preferences
#
#############################################
set history=500000


#############################################
#
#   load aliases
#
#############################################
alias week='date +%V'
alias h="history"
alias cat="ccat"
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'
alias vizshrc='vi ~/.zshrc'
#unalias grep
#unalias hg

hg() {
  local out
  out=$(history)
  for arg in "$@"; do
    out=$(printf '%s\n' "$out" | grep --color=auto  -- "$arg")
  done
  printf '%s\n' "$out"
}

alias grep='grep --color=auto'

# Herd injected PHP binary.
#export PATH="/Users/timvandewalle/Library/Application Support/Herd/bin/":$PATH
#export PATH=$PATH:$HOME/.composer/vendor/bin


# Herd injected PHP 8.2 configuration.
#export HERD_PHP_82_INI_SCAN_DIR="/Users/timvandewalle/Library/Application Support/Herd/config/php/82/"
#export PATH="$PATH:."

#source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# pnpm
# export PNPM_HOME="/Users/timvandewalle/Library/pnpm"
# case ":$PATH:" in
#   *":$PNPM_HOME:"*) ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac
# pnpm end


# Zsh syntax highlighting
if [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [ -f "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
