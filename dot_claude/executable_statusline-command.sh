#!/usr/bin/env bash
# Claude Code status line: model | 5h% [projection] | 7d% [projection]

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"' | awk '{print $1}')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_resets_at=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

bar() {
  local pct=$1
  local width=10
  local filled=0
  if [ -n "$pct" ] && [ "$pct" != "null" ]; then
    filled=$(printf '%.0f' "$(echo "$pct $width" | awk '{printf "%.0f", $1 * $2 / 100}')")
  fi
  local empty=$((width - filled))
  local color
  if [ "${pct%.*}" -ge 80 ] 2>/dev/null; then
    color='\033[31m' # red
  elif [ "${pct%.*}" -ge 50 ] 2>/dev/null; then
    color='\033[33m' # yellow
  else
    color='\033[32m' # green
  fi
  local reset='\033[0m'
  local bar=""
  for ((i = 0; i < filled; i++)); do bar="${bar}█"; done
  printf "%b%s%b" "$color" "$bar" "$reset"
  for ((i = 0; i < empty; i++)); do printf "░"; done
}

# project_indicator <used_pct> <resets_at_epoch> <window_seconds>
# Prints a colored indicator showing projected usage at end of window:
#   "~NNN%" in yellow/red if projected to exceed 100%, nothing if fine.
project_indicator() {
  local used_pct=$1
  local resets_at=$2
  local window_secs=$3

  if [ -z "$used_pct" ] || [ -z "$resets_at" ] || [ -z "$window_secs" ]; then
    return
  fi

  local now
  now=$(date +%s)

  local window_start=$((resets_at - window_secs))
  local elapsed=$((now - window_start))

  # Need at least 60 seconds of elapsed time for a meaningful rate
  if [ "$elapsed" -lt 60 ]; then
    return
  fi

  local remaining=$((resets_at - now))
  if [ "$remaining" -le 0 ]; then
    return
  fi

  # projected = used + (used / elapsed) * remaining
  # Use awk for floating point
  local projected
  projected=$(awk -v used="$used_pct" -v elapsed="$elapsed" -v remaining="$remaining" \
    'BEGIN { rate = used / elapsed; printf "%.0f", used + rate * remaining }')

  if [ "$projected" -gt 100 ]; then
    if [ "$projected" -gt 150 ]; then
      printf '\033[31m~%d%%\033[0m' "$projected" # red: well over
    else
      printf '\033[33m~%d%%\033[0m' "$projected" # yellow: moderately over
    fi
  fi
}

# Build reset label from the 5-hour window
reset_label5=""
if [ -n "$five_resets_at" ] && [ "$five_resets_at" != "null" ]; then
  now=$(date +%s)
  remaining_mins=$(((five_resets_at - now) / 60))
  if [ "$remaining_mins" -gt 60 ]; then
    reset_label5="$((remaining_mins / 60))h$((remaining_mins % 60))m"
  else
    reset_label5="${remaining_mins}m"
  fi
fi
reset_label7=""
if [ -n "$seven_resets_at" ] && [ "$seven_resets_at" != "null" ]; then
  now=$(date +%s)
  remaining_mins=$(((seven_resets_at - now) / 60))
  if [ "$remaining_mins" -gt 1440 ]; then
    reset_label7="$((remaining_mins / 1440))d$(((remaining_mins % 1440) / 60))h$((remaining_mins % 60))m"
  elif [ "$remaining_mins" -gt 60 ]; then
    reset_label7="$((remaining_mins / 60))h$((remaining_mins % 60))m"
  else
    reset_label7="${remaining_mins}m"
  fi
fi

out="${model}"
if [ -n "$five_hour" ] && [ "$five_hour" != "null" ]; then
  proj5=$(project_indicator "$five_hour" "$five_resets_at" 18000)
  label5="$(bar "$five_hour")$(printf '%.0f%%' "$five_hour")"
  if [ -n "$proj5" ]; then
    label5="${label5}${proj5}"
  fi
  out="${out}  5h:${label5} ↻${reset_label5}"
fi
if [ -n "$seven_day" ] && [ "$seven_day" != "null" ]; then
  proj7=$(project_indicator "$seven_day" "$seven_resets_at" 604800)
  label7="$(bar "$seven_day")$(printf '%.0f%%' "$seven_day")"
  if [ -n "$proj7" ]; then
    label7="${label7}${proj7}"
  fi
  out="${out}  7d:${label7} ↻${reset_label7}"
fi

printf "%s" "$out"
