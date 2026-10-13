#!/usr/bin/env bash

echo "Script triggered at $(date)" >> /tmp/kmonad.log 2>&1

# Kill existing kmonad instance if running
if pgrep -f "kmonad.*qwerty_swe.kbd" > /dev/null; then
    echo "Restarting kmonad..." >> /tmp/kmonad.log 2>&1
    pkill -f "kmonad.*qwerty_swe.kbd"
    sleep 0.5
fi

# extract user and display from `who`, since this is running as root
read -r USER_NAME DISPLAY_NAME \
     < <(who | awk '$NF ~ /^\(:[0-9]+\)$/ {gsub(/[()]/, "", $NF); print $1, $NF; exit}')

if [ -z "$USER_NAME" ]; then
    echo "No user available" >> /tmp/kmonad.log 2>&1
    exit 1
fi

echo "Starting kmonad..." >> /tmp/kmonad.log 2>&1

# Allow user to write (since starting in user space) and read the log.
touch /tmp/kmonad.log
chown "$USER_NAME" /tmp/kmonad.log

# DISPLAY not set when running from udev rule
su "$USER_NAME" -c "DISPLAY=$DISPLAY_NAME /home/$USER_NAME/src/kmonad/kmonad /home/$USER_NAME/keyboard_configs/qwerty_swe.kbd --log-level debug >> /tmp/kmonad.log 2>&1 &"
