#!/bin/bash
# changeVolume

# Arbitrary but unique message id
msgId="991049"

# Change the volume using alsa(might differ if you use pulseaudio)
case $1 in
    toggle) amixer -D pulse set Master 1+ toggle > /dev/null;;
    *)      amixer -c 0 set Master "$@" > /dev/null;;
esac
# Query amixer for the current volume and whether or not the speaker is muted
volume="$(amixer -c 0 get Master | tail -1 | awk '{print $4}' | sed 's/[^0-9]*//g')"
mute="$(amixer -c 0 get Master | tail -1 | awk '{print $6}' | sed 's/[^a-z]*//g')"

mute() {
    message="Volume: muted"
}
zero() {
    icon_name="/usr/share/icons/gruvbox-dark-icons-gtk/48x48/status/notification-audio-volume-muted.svg";
}
low() {
    icon_name="/usr/share/icons/gruvbox-dark-icons-gtk/48x48/status/notification-audio-volume-low.svg";
}
med() {
    icon_name="/usr/share/icons/gruvbox-dark-icons-gtk/48x48/status/notification-audio-volume-medium.svg";
}
high() {
    icon_name="/usr/share/icons/gruvbox-dark-icons-gtk/48x48/status/notification-audio-volume-high.svg";
}
[[ "$volume" -ge "70" ]] && high
[[ "$volume" -lt "70" ]] && med
[[ "$volume" -le "30" ]] && low
[[ "$volume" == "0" ]] && zero
[[ "$mute" == "off" ]] && zero && mute
[[ -z "$message" ]] && message="Volume: ${volume}"

dunstify -a "changeVolume" -u low -i "$icon_name" -r "$msgId" \
    -h int:value:"$volume" "${message}"

canberra-gtk-play -i audio-volume-change -d "changeVolume"
