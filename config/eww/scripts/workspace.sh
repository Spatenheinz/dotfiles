#!/usr/bin/env bash

#define icons for workspaces 1-9
ic=({0..9})

focused() {
  id="$(echo "$2" | jq '.id')"
  monitorID="$(echo "$2" | jq '.monitorID')"
  echo -n "(button :onclick \"scripts/dispatch.sh $id\" :class "
  if [ "$1" == "$id" ]; then
    echo -n '"w-focused"'
  elif [ "$monitorID" == "$3" ]; then
    echo -n '"w-occupied"'
  else
    echo -n '"w"'
  fi
  echo " \"${ic[$id]}\")"
}


workspaces() {

# Get Focused workspace for current monitor ID
arg="$1"
num="$(hyprctl monitors -j | jq --argjson arg "$arg" '.[] | select(.id == $arg).activeWorkspace.id')"
workspaces="$(hyprctl workspaces -j | jq -c '.[] | select(.id > 0) | {id,monitorID}')"
str=""
for ws in $workspaces; do
          str="$str$(focused "$num" "$ws" "$arg")"
done

echo "(eventbox :onscroll \"echo {} | sed -e 's/up/-1/g' -e 's/down/+1/g' | xargs hyprctl dispatch workspace\" \
  (box :class \"workspace\" :orientation \"h\" :space-evenly \"false\" \
  $str \
  ))"
}

workspaces "$1"
socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r; do
workspaces "$1"
done

