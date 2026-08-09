#!/bin/sh

# OneCloud LED Control Script
# Controls front panel LED via sysfs

LED_BASE="/sys/class/leds"

# Find the first controllable LED (skip mmc/usb)
find_led() {
    for led in $(ls "$LED_BASE" 2>/dev/null); do
        case "$led" in
            *mmc*|*usb*|*tower*) continue ;;
        esac
        if [ -w "$LED_BASE/$led/brightness" ]; then
            echo "$led"
            return 0
        fi
    done
    return 1
}

# Get current state from uci
get_state() {
    local val
    val=$(uci -q get onecloud-led.main.state 2>/dev/null)
    echo "${val:-1}"
}

# Apply LED state
apply_state() {
    local state=$1
    local led=$(find_led)
    if [ -n "$led" ]; then
        # Disable trigger first
        echo "none" > "$LED_BASE/$led/trigger" 2>/dev/null
        echo "$state" > "$LED_BASE/$led/brightness" 2>/dev/null
    fi
    uci set onecloud-led.main.state="$state"
    uci commit onecloud-led
}

case "$1" in
    on)
        apply_state 1
        echo "LED ON"
        ;;
    off)
        apply_state 0
        echo "LED OFF"
        ;;
    status)
        local s=$(get_state)
        [ "$s" = "1" ] && echo "ON" || echo "OFF"
        ;;
    *)
        echo "Usage: $0 {on|off|status}"
        exit 1
        ;;
esac
exit 0
