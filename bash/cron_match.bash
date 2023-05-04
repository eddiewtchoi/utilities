#!/bin/bash

function field_matches() {
    local field="$1"
    local value="$2"

    echo $field
    if [[ "$field" == '*' ]]; then
        return 0
    fi
    if [[ "$field" == '@'* ]]; then
        local timestamp="$(date -d "${field:1}" '+%M %H %d %m %u')"
        if [[ "$timestamp" == "$value" ]]; then
            return 0
        else
            return 1
        fi
    fi

    # Check for range values
    local start_range=0
    local end_range=0
    if [[ "$field" =~ ^([0-9]+)-([0-9]+)$ ]]; then
        start_range="${BASH_REMATCH[1]}"
        end_range="${BASH_REMATCH[2]}"
        if (( value >= start_range && value <= end_range )); then
            return 0
        else
            return 1
        fi
    fi

    # Check for CSV values
    local csv=""
    #if [[ "$field" =~ ^([0-9]+)(,[0-9]+)+$ ]]; then
    if [[ "$field" =~ ([^,\n]*)(,|$) ]]; then
      csv="${field//,/ }"
      for i in ${csv[@]};do 
        if [[ "$i" =~ ^([0-9]+)-([0-9]+)$ ]]; then
          start_range="${BASH_REMATCH[1]}"
          end_range="${BASH_REMATCH[2]}"
          if (( value >= start_range && value <= end_range )); then
            return 0
          fi
        else
          if [[ "$i" == "$value" ]]; then
            return 0
           fi
        fi
      done
    fi
    return 1
}

function cron_matches() {

    #disable * expansion from bash
    set -f 
    local cron="$1"
    local timestamp="$2"

    # Split cron expression into fields
    local fields=($cron)

    # Check if current time matches cron expression
    for i in 0 1 2 3 4; do
        if ! field_matches "${fields[i]}" "$(echo "$timestamp" | cut -d' ' -f$((i+1)))"; then
          return 1
        fi
    done

    return 0
}

# Example usage: check if current time matches cron expression
if cron_matches "* 0-4,23 * * *" "$(date +'%-M %-H %-d %-m %-u')"; then
    echo "Current time matches cron expression"
else
    echo "Current time does not match cron expression"
fi
