#!/usr/bin/env bash

# kill any running instances if they exist
eww kill
eww daemon

# start a bar for each monitor
monitors=$(hyprctl monitors -j | jq '.[] | .id')
for monitor in ${monitors}; do
    eww open bar --id "bar${monitor}" --arg "monitor=${monitor}"
done

export EWW_UPDATE=1
# updates to do to the bar
"$(dirname "${BASH_SOURCE[0]}")/scripts/volume" > /dev/null
"$(dirname "${BASH_SOURCE[0]}")/scripts/microphone" > /dev/null
"$(dirname "${BASH_SOURCE[0]}")/scripts/light" > /dev/null
