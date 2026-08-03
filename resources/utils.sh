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

    local exitCode=0

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If the current process is ended,
    # also end all its subprocesses.

    set_trap "EXIT" "kill_all_subprocesses"
    set_trap "INT" "kill_all_subprocesses; exit 1"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Print the message
    print_info "$MSG"

    # Execute commands in foreground so output is visible
    local START_TIME=$(date +%s)
    eval "$CMDS"
    exitCode=$?
    local END_TIME=$(date +%s)

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Calculate elapsed time
    local elapsed=$(( END_TIME - START_TIME ))
    local time_str=$(printf "%02d:%02d" $(( elapsed / 60 )) $(( elapsed % 60 )))

    # Print output based on what happened.
    print_result $exitCode "$MSG" "$time_str"

    return $exitCode

}

get_answer() {
    printf "%s" "$REPLY"
}

is_git_repository() {
    git rev-parse --is-inside-work-tree &> /dev/null
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
