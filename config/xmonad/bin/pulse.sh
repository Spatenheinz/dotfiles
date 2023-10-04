#!/usr/bin/env bash
#   pulsevol.sh
#   PulseAudio Volume Control Script
#   Original 2010-05-20 - Gary Hetzel <garyhetzel@gmail.com>
#
#   Modified 2010-10-18 by Fisslefink <fisslefink@gmail.com>
#    - Added support for multiple sinks and Ubuntu libnotify OSD
#
#   Usage:  pulsevol.sh [sink_index] [up|down|min|max|overmax|toggle|mute|unmute]
#

EXPECTED_ARGS=2
E_BADARGS=65
USECASE="Usage: `basename $0` [sink_index] [up|down|toggle]"

if [ $# -ne $EXPECTED_ARGS ]
then
    echo $USECASE
    exit $E_BADARGS
fi

SINK=$1
STEP=5

getperc(){
    VOLPERC=`pactl get-sink-volume $SINK | head -n1 | cut -d/ -f2 | tr -d "[:space:][%]"`
}

getperc;

up(){
    VOLUME="$(( $VOLPERC+$STEP ))";
    pactl set-sink-volume $SINK $VOLUME% > /dev/null
}

down(){
    VOLUME="$(( $VOLPERC-$STEP ))";
    pactl set-sink-volume $SINK $VOLUME% > /dev/null
}

toggle(){
    pactl set-sink-mute $SINK toggle
}

case $2 in
up)
    up;;
down)
    down;;
toggle)
    toggle;;
*)
    echo $USECASE
    exit 1;;
esac

if [ "$VOLPERC" = "0" ]; then
   icon_name="notification-audio-volume-off.svg"
elif [ "$VOLPERC" -lt "33" ]; then
   icon_name="notification-audio-volume-low.svg"
elif [ "$VOLPERC" -lt "67" ]; then
   icon_name="notification-audio-volume-medium.svg"
else
    echo "wtf"
   icon_name="notification-audio-volume-high.svg"
fi

dunstify -a "changevolume" -u low -r 1337 -i $icon_name -h int:value:$VOLPERC "Volume: $VOLPERC%" -t 2000
