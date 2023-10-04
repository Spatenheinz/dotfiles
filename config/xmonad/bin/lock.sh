#!/usr/bin/env bash
set -euo pipefail

yad-cancel() {
	kill -SIGUSR1 $YAD_PID
}
export -f yad-cancel

yad --no-buttons --form --width=250 --center --on-top --undecorated --text-align="center" --text="control-panel" \
--field="logout":fbtn "xmonad --exit" \
--field="restart":fbtn "xmonad --recompile && xmonad --restart" \
--field="reboot":fbtn "sudo reboot" \
--field="poweroff":fbtn "sudo poweroff" \
--field="lock":fbtn "slock" \
--field="cancel":fbtn "bash -c yad-cancel"\
