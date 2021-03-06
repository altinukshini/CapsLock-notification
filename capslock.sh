#!/bin/bash

CAPS_STATE=$(xset q | grep "Caps Lock:" | awk '{print $4}' | grep -c on)

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

if  [ "$CAPS_STATE" -eq 0 ]; then
    notify "Caps Lock OFF"
elif [ "$CAPS_STATE" -eq 1 ]; then
    notify "Caps Lock ON"
    paplay /usr/share/sounds/gnome/default/alerts/glass.ogg
fi
