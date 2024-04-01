#!/bin/bash

action=$(yad --title "System Actions" --width=500 --height=300  --text-align=center --text "\n" --list --no-headers --dclick-action=none --print-column=1 --column "Choice":HD --column "Action" reboot Reboot shutdown Shutdown restartD "Restart Desktop" restartSK "Restart SignalK")

ret=$?

[[ $ret -eq 1 ]] && exit 0

case $action in
    reboot*) cmd='sh -c "kill $(pidof opencpn); sleep 5; /sbin/reboot"' ;;
    shutdown*) cmd='sh -c "kill $(pidof opencpn); sleep 5; /sbin/poweroff"' ;;
    restartD*) cmd="budgie-panel --replace&" ;;
    restartSK*) cmd="sudo /usr/local/sbin/signalk-restart" ;;
    *) exit 1 ;;
esac

eval exec "$cmd"
