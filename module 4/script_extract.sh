#!/bin/bash

input_file="$1"
output_file="output.txt"

# Clear output file if it exists
> "$output_file"

frame_time=""
wlan_type=""
wlan_subtype=""

line_count=0

while IFS= read -r line; do
    echo "line: $line_count"
    ((line_count++))

    # Extract frame.time
    if echo "$line" | grep -q '"frame.time"'; then
        frame_time=$(echo "$line" | sed -n 's/.*"frame.time": "\(.*\)".*/\1/p')
        echo "\"frame.time\": \"$frame_time\","
        echo "\"frame.time\": \"$frame_time\"," >> "$output_file"
        frame_time=""
    fi

    # Extract wlan.fc.type
    if echo "$line" | grep -q '"wlan.fc.type"'; then
        wlan_type=$(echo "$line" | sed -n 's/.*"wlan.fc.type": "\(.*\)".*/\1/p')
        echo "\"wlan.fc.type\": \"$wlan_type\","
        echo "\"wlan.fc.type\": \"$wlan_type\"," >> "$output_file"
        wlan_type=""
    fi

    # Extract wlan.fc.subtype
    if echo "$line" | grep -q '"wlan.fc.subtype"'; then
        wlan_subtype=$(echo "$line" | sed -n 's/.*"wlan.fc.subtype": "\(.*\)".*/\1/p')
        echo "\"wlan.fc.subtype\": \"$wlan_subtype\""
        echo "\"wlan.fc.subtype\": \"$wlan_subtype\"" >> "$output_file"
        wlan_subtype=""
    fi

done < "$input_file"
