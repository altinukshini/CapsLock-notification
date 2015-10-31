#!/bin/bash

notify() {
  USER=$(who | sed -n '/ (:0[\.0]*)$\| :0 /{s/ .*//p;q}')
  USERCNT=$(who | wc -l)
  if [ ! "$(whoami)" = "$USER" ]; then
    if [ ! "$USERCNT" -lt 1 ]; then
        su $USER -l -c "DISPLAY=:0.0 -t 1000 --hint int:transient:1 -i /usr/share/icons/gnome/scalable/devices/input-keyboard-symbolic.svg \"$1\">/dev/null"
    fi
  else
    if [ ! "$USERCNT" -lt 1 ]; then
        /usr/bin/notify-send -t 1000 --hint int:transient:1 -i /usr/share/icons/gnome/scalable/devices/input-keyboard-symbolic.svg "$1" > /dev/null
    fi
  fi
}

NOTIFICATION_STATE=$(xset q | grep "Caps Lock:" | awk '{print $4}' | grep -c on)

while [ true ]; do

    CAPS_STATE=$(xset q | grep "Caps Lock:" | awk '{print $4}' | grep -c on)

    if [ $NOTIFICATION_STATE -eq 0 ]; then
        if  [ "$CAPS_STATE" -eq 0 ]; then
            notify "Caps Lock OFF"
            NOTIFICATION_STATE=1
        fi
    elif [ $NOTIFICATION_STATE -eq 1 ]; then
        if [ "$CAPS_STATE" -eq 1 ]; then
            notify "Caps Lock ON"
            NOTIFICATION_STATE=0
            paplay /usr/share/sounds/gnome/default/alerts/glass.ogg
        fi
    fi

    sleep 0.5

done
