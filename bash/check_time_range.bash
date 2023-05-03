#!/bin/bash

# Get the current time in Unix timestamp format
current_timestamp=$(date +%s)

# Parse the command line arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --start-time)
    start_time="$2"
    shift
    shift
    ;;
    --end-time)
    end_time="$2"
    shift
    shift
    ;;
    *)
    echo "Invalid argument: $1"
    exit 1
    ;;
esac
done

# Check if start time and end time are set
if [ -z "$start_time" ] || [ -z "$end_time" ]
then
    echo "Start time and end time are required parameters"
    exit 1
fi

# Convert start time and end time to Unix timestamp format
today=$(date +%Y-%m-%d)
start_timestamp=$(date -d "$today $start_time" +%s)

if [[ "$start_time" > "$end_time" ]]
then
    yesterday=$(date -d "yesterday" +%Y-%m-%d)
    start_timestamp=$(date -d "$yesterday $start_time" +%s)
fi

end_timestamp=$(date -d "$today $end_time" +%s)

if [[ "$end_time" < "$start_time" ]]
then
    tomorrow=$(date -d "tomorrow" +%Y-%m-%d)
    end_timestamp=$(date -d "$tomorrow $end_time" +%s)
fi

# Check if current time is within the specified range
if [[ "$current_timestamp" -ge "$start_timestamp" && "$current_timestamp" -lt "$end_timestamp" ]]
then
    echo "Current time is within the specified range"
else
    echo "Current time is outside the specified range"
fi
