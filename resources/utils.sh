#!/usr/bin/env zsh

check_os() {
  if [[ "$(uname)" != "Darwin" ]]; then
      print_error "This script is intended for MacOS only!"
      exit 1
  fi
}

confirm_install(){
  ask_for_confirmation "This script will set up your Mac. Continue?"
  if ! answer_is_yes; then
      exit 1
  else
    log "Setting up your Mac..."
  fi
}

log() {
    # Logging function to timestamp each action.
    #echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1"
    print_info "$1"
}

run_script() {
    # Helper function to display a message and then run a script in a subshell.
    local message="$1"
    local script_path="$2"
    log "$message"
    # shellcheck disable=SC2039
    source "$script_path"
}

run_execute_script() {
    # Helper function to display a message and then run a script through execute
    local message="$1"
    local script_path="$2"
    if file_exists "$script_path"; then
        execute "source $script_path" "$message"
    else
        execute "$script_path" "$message"
    fi
}

run_command() {
    local message="$1"
    local cmd="$2"
    log "$message"
    eval "$cmd"
}

answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
        && return 0 \
        || return 1
}

answer_is_no() {
    [[ "$REPLY" =~ ^[Nn]$ ]] \
        && return 0 \
        || return 1
}

ask_for_input() {
    print_question "$1"
    read -r
}

ask_for_confirmation() {
    print_question "$1 (y/n) "
    #read -r -n 1
    read -r
}

ask_for_sudo() {
    msg="Since this script will be altering your computer settings, "
    msg+="it's gonna need sudo privileges. Please enter your password…"

    print_after_newline "$msg" "print_in_purple"
    print_with_newline

    # Update sudo timestamp until the script has finished
    sudo -v
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &
    SUDO_PID=$!
    trap 'kill $SUDO_PID &> /dev/null' EXIT
}

ask_for_reboot() {
    print_after_newline "Do you want to restart?" "ask_for_confirmation"

    if answer_is_yes; then
        sudo shutdown -r now &> /dev/null
    fi

    print_with_newline
}

ask_to_continue() {
    print_after_newline "Press any key to continue…" "print"
    print_with_newline
    # Using 'read -r -k 1' to wait for a single character in zsh
    # or fallback to 'read -r -n 1' for bash compatibility if needed, 
    # but we aim for zsh.
    if [ -n "$ZSH_VERSION" ]; then
        read -r -k 1
    else
        read -r -n 1
    fi
	# Delete the visual inputted key to continue and perform an extra new line
	print_with_newline "\r         "
}

directory_exists() {
    [ -d "$1" ]
}

file_exists() {
    [ -f "$1" ]
}

cmd_exists() {
    command -v "$1" &> /dev/null
}

kill_all_subprocesses() {
    local i=""

    for i in $(jobs -p); do
        kill "$i"
        wait "$i" &> /dev/null
    done
}

execute() {
    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r ERR_FILE="$(mktemp /tmp/XXXXX)"
    local -r OUT_FILE="$(mktemp /tmp/XXXXX)"

    local exitCode=0
    local cmdsPID=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If the current process is ended,
    # also end all its subprocesses.

    set_trap "EXIT" "kill_all_subprocesses"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Execute commands in background
    # We use a subshell to ensure it handles the command correctly
    (
        eval "$CMDS"
    ) &> "$OUT_FILE" 2> "$ERR_FILE" &

    cmdsPID=$!

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Show a spinner if the commands
    # require more time to complete.

    show_spinner "$cmdsPID" "$CMDS" "$MSG"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait for the commands to no longer be executing
    # in the background, and then get their exit code.

    wait "$cmdsPID" &> /dev/null
    exitCode=$?

    # If the background process asks for sudo, it might fail in execute
    # so we check if the exit code is 1 and if the error log contains sudo related errors
    if [ $exitCode -ne 0 ] && grep -q "sudo: a password is required" "$ERR_FILE" 2>/dev/null; then
        print_warning "Sudo password required for: $MSG"
        eval "$CMDS"
        exitCode=$?
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Print output based on what happened.

    print_result $exitCode "$MSG"

    if [ $exitCode -ne 0 ]; then
        if [ -s $ERR_FILE ]; then
            print_error_stream < "$ERR_FILE"
        else
            print_warning_stream < "$OUT_FILE"
        fi
    fi

    rm -rf "$ERR_FILE"
    rm -rf "$OUT_FILE"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    return $exitCode

}

get_answer() {
    printf "%s" "$REPLY"
}

is_git_repository() {
    git rev-parse &> /dev/null
}

mkd() {
    if [ -n "$1" ]; then
        if [ -e "$1" ]; then
            if [ ! -d "$1" ]; then
                print_error "$1 - a file with the same name already exists!"
            else
                print_success "$1"
            fi
        else
            execute "mkdir -p $1" "$1"
        fi
    fi
}

print_in_color() {
    printf "%b" \
        "$(tput setaf "$2" 2> /dev/null)" \
        "$1" \
        "$(tput sgr0 2> /dev/null)"
}

print_in_green() {
    print_in_color "$1" 2
}

print_in_purple() {
    print_in_color "$1" 5
}

print_in_red() {
    print_in_color "$1" 1
}

print_in_yellow() {
    print_in_color "$1" 3
}

print_in_blue() {
    print_in_color "$1" 4
}

print_in_cyan() {
    print_in_color "$1" 6
}

print_result() {

    if [ "$1" -eq 0 ]; then
        print_success "$2"
    else
        print_error "$2"
    fi

    return "$1"

}

print() {
    printf "%b" "$1"
}

print_with_newline() {
    print "$1\n"
}

print_success() {
    print_in_green "✅ $1\n"
}

print_warning() {
    print_in_yellow "⚠️  $1\n"
}

print_info() {
    print_in_cyan "ℹ️  $1\n"
}

print_error() {
    print_in_red "❌ $1\n"
}

print_error_stream() {
    while read -r line; do
        print_in_red "↳ ERROR: $line\n"
    done
    print_with_newline
}

print_warning_stream() {
    while read -r line; do
        print_in_yellow "↳ $line\n"
    done
    print_with_newline
}

print_question() {
    print_in_purple "❓ $1 "
}

print_step() {
    print_with_newline
    local step_num="$1"
    local step_name="$2"
    # Using a blue background with bold white text for steps
    printf "%b" \
        "$(tput bold 2> /dev/null)" \
        "$(tput setaf 7 2> /dev/null)" \
        "$(tput setab 4 2> /dev/null)" \
        " 🚀 Step $step_num: $step_name " \
        "$(tput sgr0 2> /dev/null)"
    print_with_newline
}

print_after_newline() {
    $2 "$1"
}

set_trap() {
    trap "$2" "$1"
}

skip_questions() {
     while :; do
        case $1 in
            -y|--yes) return 0;;
                   *) break;;
        esac
        shift 1
    done

    return 1
}

show_spinner() {
    local -r FRAMES='/-\|'

    # shellcheck disable=SC2034
    local -r NUMBER_OR_FRAMES=${#FRAMES}

    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"

    local i=0
    local frameText=""

    # Display spinner while the commands are being executed.
    while kill -0 "$PID" &>/dev/null; do
        tput sc
        # In Zsh, strings are 1-indexed.
        # Use (( ... )) for arithmetic and calculate the index.
        local idx=$(( (i % NUMBER_OR_FRAMES) + 1 ))
        frameText="[${FRAMES[$idx]}] $MSG"
        # Print frame text.
        printf "%s" "$frameText"
        (( i++ ))
        sleep 0.2
        tput rc
        tput el
    done
}