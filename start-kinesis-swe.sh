#!/usr/bin/env bash

echo "Script triggered at $(date)" >> /tmp/kmonad.log 2>&1

# Kill existing kmonad instance if running
if pgrep -f "kmonad.*qwerty_swe.kbd" > /dev/null; then
    echo "Restarting kmonad..." >> /tmp/kmonad.log 2>&1
    pkill -f "kmonad.*qwerty_swe.kbd"
    sleep 0.5
fi

USER=$(who | grep -o '^\w*' | head -n1)

if [ -z "$USER" ]; then
    echo "No user available" >> /tmp/kmonad.log 2>&1
    exit 1
fi

su "$USER" -c "echo 'Starting kmonad...' >> /tmp/kmonad.log 2>&1 &"
su "$USER" -c "/home/$USER/src/kmonad/kmonad /home/$USER/keyboard_configs/qwerty_swe.kbd --log-level debug >> /tmp/kmonad.log 2>&1 &"
