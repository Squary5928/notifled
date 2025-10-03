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

# Enable unofficial bash strict mode (minus -u, to avoid unbound var issues with $line)
set -euo pipefail
IFS=$'\n\t'

# Path to Scroll Lock LED device
declare -r LED_DEVICE="/sys/class/leds/input*::scrolllock/brightness"

# Global: store PID of currently running heartbeat
heartbeat_pid=0

# Function: heartbeat blink (approx. 3 seconds total)
heartbeat() {
    local duration=3
    local end=$((SECONDS + duration))

    while ((SECONDS < end)); do
        for val in 1 0 1 0; do
            echo "$val"
            sleep 0.1
        done
        sleep 0.6
    done | tee "$LED_DEVICE" > /dev/null
}

# Function: start heartbeat safely (PID lock)
start_heartbeat() {
    # If a heartbeat is still running, kill it
    if (( heartbeat_pid > 0 )) && kill -0 "$heartbeat_pid" 2>/dev/null; then
        kill "$heartbeat_pid" 2>/dev/null || true
    fi

    heartbeat &        # Start a new heartbeat in the background
    heartbeat_pid=$!   # Save its PID
}

# Main loop: listen for notifications
dbus-monitor "interface='org.freedesktop.Notifications'" |
while read -r line; do
    if [[ "$line" == *"member=Notify"* ]]; then
        start_heartbeat
    fi
done
