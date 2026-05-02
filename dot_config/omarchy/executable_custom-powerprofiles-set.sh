#!/bin/bash

# Custom script to override omarchy's default power profiles logic
# Usage: custom-powerprofiles-set.sh <ac|battery>

mapfile -t profiles < <(powerprofilesctl list | awk '/^\s*[* ]\s*[a-zA-Z0-9\-]+:$/ { gsub(/^[*[:space:]]+|:$/,""); print }')

case "$1" in
  ac)
    # Prefer performance, fall back to balanced
    if [[ " ${profiles[*]} " == *" performance "* ]]; then
      powerprofilesctl set performance
    else
      powerprofilesctl set balanced
    fi
    ;;
  battery)
    # Fallback to power-saver instead of balanced
    powerprofilesctl set power-saver
    ;;
esac