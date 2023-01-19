#!/bin/bash
# Playing with ansible output, the linux binaries and in particular sed and jq

line=$(cat -)

echo "$line" 
# Omit the censored lines... (no_log: true)
if [[ "$line" =~ censored ]]; then 
    echo "Hello";
else
    echo "$line";
fi

#sed 's/^.* | \(.*\) => \(.*}\).*$/{"status": "\1", "data": \2}/'
