#!/usr/bin/env zsh

check_os() {
  if [[ "$(uname)" != "Darwin" ]]; then
      print_error "This script is intended for MacOS only!"
      exit 1
  fi
}

confirm_install(){
  ask_for_confirmation "Ready to set up your Mac?"
  if ! answer_is_yes; then
      exit 1
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

    # Log results to a file if LOG_FILE is defined
    if [ -n "$LOG_FILE" ]; then
        echo "------------------------------------------------------------" >> "$LOG_FILE"
        echo "Source Script: $script_path" >> "$LOG_FILE"
        echo "Timestamp: $(date +%Y-%m-%d\ %H:%M:%S)" >> "$LOG_FILE"
        echo "------------------------------------------------------------" >> "$LOG_FILE"
    fi

    # shellcheck disable=SC2039
    source "$script_path"
    local exit_code=$?
    return $exit_code
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
  print_question "$1 "
  read -r
}

ask_for_confirmation() {
  print_question "$1 (y/n) "
  read -r
}

ask_for_sudo() {
    print_in_blue "  🔐 Enter password for sudo privileges…"
    print_with_newline

    # Update sudo timestamp until the script has finished
    # We use -p to set a custom prompt that includes indentation
    sudo -p "  🔐 Password: " -v
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &
    SUDO_PID=$!
    set_trap "EXIT" "kill $SUDO_PID &> /dev/null; kill_all_subprocesses"
    set_trap "INT" "kill $SUDO_PID &> /dev/null; kill_all_subprocesses; exit 1"
}

ask_for_reboot() {
    print_after_newline "  Do you want to restart?" "ask_for_confirmation"

    if answer_is_yes; then
        sudo shutdown -r now &> /dev/null
    fi
}

ask_to_continue() {
    print_after_newline "  ⌨️  Press any key to continue…" "print_in_blue"
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
        kill -TERM -"$i" &> /dev/null || kill -TERM "$i" &> /dev/null
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
    set_trap "INT" "kill_all_subprocesses; exit 1"

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

    local elapsed_time=""
    elapsed_time=$(show_spinner "$cmdsPID" "$CMDS" "$MSG")

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait for the commands to no longer be executing
    # in the background, and then get their exit code.

    wait "$cmdsPID" &> /dev/null
    exitCode=$?

    # Log results to a file if LOG_FILE is defined
    if [ -n "$LOG_FILE" ]; then
        {
            echo "------------------------------------------------------------"
            echo "Step: $MSG"
            echo "Command: $CMDS"
            echo "Exit Code: $exitCode"
            echo "Timestamp: $(date +%Y-%m-%d\ %H:%M:%S)"
            echo "------------------------------------------------------------"
            echo "STDOUT:"
            cat "$OUT_FILE"
            echo ""
            echo "STDERR:"
            cat "$ERR_FILE"
            echo ""
        } >> "$LOG_FILE"
    fi

    # If the background process asks for sudo, it might fail in execute
    # so we check if the exit code is 1 and if the error log contains sudo related errors
    if [ $exitCode -ne 0 ] && (grep -qi "sudo" "$ERR_FILE" 2>/dev/null || grep -qi "password" "$ERR_FILE" 2>/dev/null || grep -q "Sorry, try again." "$ERR_FILE" 2>/dev/null); then
        # Use tput to ensure we are at the beginning of the line
        printf "\r" >&2
        tput el >&2
        print_warning "Interactive input or sudo password required for: $MSG"
        # We try to run it in the foreground now.
        eval "$CMDS"
        exitCode=$?
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Print output based on what happened.

    print_result $exitCode "$MSG" "$elapsed_time"

    if [ $exitCode -ne 0 ]; then
        if [ -s $ERR_FILE ]; then
            print_error "Command failed. Recent error output:"
            print_error_stream < "$ERR_FILE"
        else
            print_warning "Command finished with warnings. Recent output:"
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
        print_success "$2" "$3"
    else
        print_error "$2" "$3"
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
  if [ -n "$2" ]; then
    print_in_green "  ✅ $1 ($2)\n"
  else
    print_success_no_time "$1"
  fi
}

print_success_no_time() {
  print_in_green "  ✅ $1\n"
}

print_warning() {
  print_in_yellow "  ⚠️  $1\n"
}

print_info() {
  print_in_blue "  🔹 $1\n"
}

print_error() {
  if [ -n "$2" ]; then
    print_in_red "  ❌ $1 ($2)\n"
  else
    print_error_no_time "$1"
  fi
}

print_error_no_time() {
  print_in_red "  ❌ $1\n"
}

print_error_stream() {
    while read -r line; do
        print_in_red "  ↳ ERROR: $line\n"
    done
    print_with_newline
}

print_warning_stream() {
    while read -r line; do
        print_in_yellow "  ↳ $line\n"
    done
    print_with_newline
}

print_question() {
  print_in_blue "  ❓ $1"
}

print_step() {
    print_with_newline
    local step_num="$1"
    local total_steps="$2"
    local step_name="$3"
    # Using a blue background with bold white text for steps
    printf "%b" \
        "$(tput bold 2> /dev/null)" \
        "$(tput setaf 7 2> /dev/null)" \
        "$(tput setab 4 2> /dev/null)" \
        " STEP $step_num/$total_steps: $step_name " \
        "$(tput sgr0 2> /dev/null)"
    print_with_newline
}

print_after_newline() {
    print_with_newline
    $2 "$1"
}

print_table() {
    local -r separator="|"
    local -r padding=2

    # Collect input lines into an array
    local lines=()
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        lines+=("$line")
    done

    # Find max width for each column
    local col1_max=0
    local col2_max=0
    local col3_max=0

    local formatted_lines=()
    for line in "${lines[@]}"; do
        local c1=$(echo "$line" | cut -d'|' -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
        local c2=$(echo "$line" | cut -d'|' -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
        local c3=$(echo "$line" | cut -d'|' -f3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
        
        formatted_lines+=("$c1|$c2|$c3")
        
        (( ${#c1} > col1_max )) && col1_max=${#c1}
        (( ${#c2} > col2_max )) && col2_max=${#c2}
        (( ${#c3} > col3_max )) && col3_max=${#c3}
    done

    local total_width=$(( col1_max + col2_max + col3_max + 8 ))
    local line_border=$(printf "%${total_width}s" | tr " " "-")

    print_with_newline "  $line_border"
    for line in "${formatted_lines[@]}"; do
        local c1=$(echo "$line" | cut -d'|' -f1)
        local c2=$(echo "$line" | cut -d'|' -f2)
        local c3=$(echo "$line" | cut -d'|' -f3)
        
        # We use simple printf with padding
        printf "  %s %-${col1_max}s %s %-${col2_max}s %s %-${col3_max}s %s\n" \
            "$separator" "$c1" "$separator" "$c2" "$separator" "$c3" "$separator"
        
        # Add a separator after header
        if [[ "$c1" == "Tool" ]]; then
             print_with_newline "  $line_border"
        fi
    done
    print_with_newline "  $line_border"
    print_with_newline
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
    local -r START_TIME=$(date +%s)

    local i=0
    local frameText=""

    # Display spinner while the commands are being executed.
    while kill -0 "$PID" &>/dev/null; do
        # In Zsh, strings are 1-indexed.
        # Use (( ... )) for arithmetic and calculate the index.
        local idx=$(( (i % NUMBER_OR_FRAMES) + 1 ))
        local current_time=$(date +%s)
        local elapsed=$(( current_time - START_TIME ))
        local time_str=$(printf "%02d:%02d" $(( elapsed / 60 )) $(( elapsed % 60 )))
        
        frameText="   [${FRAMES[$idx]}] $MSG ($time_str) "
        # Print frame text to stderr so it's not captured by variable assignment
        printf "\r%s" "$frameText" >&2
        (( i++ ))
        sleep 0.2
        tput el >&2
    done
    
    # Calculate final time
    local final_time=$(date +%s)
    local total_elapsed=$(( final_time - START_TIME ))
    local final_time_str=$(printf "%02d:%02d" $(( total_elapsed / 60 )) $(( total_elapsed % 60 )))

    # Print one last time to ensure it finishes clean or is cleared (to stderr)
    # Use printf "\r" and tput el to clear the line before return
    printf "\r" >&2
    tput el >&2
    
    # Return the final time string so execute() can use it (to stdout)
    printf "%s" "$final_time_str"
}