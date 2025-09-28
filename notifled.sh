#!/usr/bin/env bash
#
# notify-heartbeat.sh
# Blink the Scroll Lock LED in a "heartbeat" pattern whenever a desktop
# notification is received over D-Bus.
#
# Requirements:
#   - Access to /sys/class/leds/.../brightness
#   - dbus-monitor
#
# Author: Squary
# License: MIT

# Path to Scroll Lock LED device
LED_DEVICE="/sys/class/leds/input*::scrolllock/brightness"

# Function: heartbeat blink (approx. 3 seconds total)
heartbeat() {
    local duration=3
    local end=$((SECONDS + duration))

    while [ $SECONDS -lt $end ]; do
        echo 1 | sudo tee $LED_DEVICE >/dev/null
        sleep 0.1
        echo 0 | sudo tee $LED_DEVICE >/dev/null
        sleep 0.1
        echo 1 | sudo tee $LED_DEVICE >/dev/null
        sleep 0.1
        echo 0 | sudo tee $LED_DEVICE >/dev/null
        sleep 0.7
    done
}

# Main loop: listen for notifications
dbus-monitor "interface='org.freedesktop.Notifications'" |
while read -r line; do
    if [[ "$line" == *"member=Notify"* ]]; then
        heartbeat &
    fi
done
