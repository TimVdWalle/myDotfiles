# progress_bar.sh

# Function to display a progress bar
show_progress() {
  local current_step="$1"
  local total_steps="$2"
  local percentage=$(echo "scale=2; ($current_step/$total_steps) * 100" | bc)
  local progress_bar_length=50
  local progress_char="#"
  local num_progress_chars=$(echo "scale=0; ($percentage / 100) * $progress_bar_length" | bc)
  local progress_bar=""

  for ((i=0; i<$num_progress_chars; i++)); do
    progress_bar+="$progress_char"
  done

  for ((i=num_progress_chars; i<$progress_bar_length; i++)); do
    progress_bar+=" "
  done

  printf "\rProgress: [%s] %0.2f%%" "$progress_bar" "$percentage"
}

# Function to increment the step and update the progress bar
increment_step_and_show_progress() {
  ((current_step++))
  show_progress "$current_step" "$total_steps"
}
