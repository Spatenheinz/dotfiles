#!/usr/bin/env bash

to_sec() {
    echo $(($1 * 60))
}

swayidle -w \
    timeout "$(to_sec 10)" 'swaylock -f -c 000000' \
    timeout "$(to_sec 15)" 'systemctl suspend' \
    resume "hyprctl dispatch dpms on && eww reload" \
    before-sleep 'swaylock -f -c 000000'
