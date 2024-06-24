SINK=$( pactl list short sinks | sed -e 's,^\([1-9][0-9]*\)[^0-9].*,\1,' | head -n 1 )
VOLUME=$( pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' )

DATE=$(date '+%a %b %e')
TIME=$(date '+%R')

WEATHER=$($PWD/.config/sway/includes/weather.sh)

# WIFI=📶$(nmcli -t device show wlp0s20f3 | grep CONNECTION | awk -F : '{print $2}')
# SIGNAL=$(iw dev wlp0s20f3 station dump | grep "signal:" | awk '{print $2,$NF}')

# echo $WIFI $SIGNAL 🔹 $WEATHER 🔹 🔊$VOLUME% 🔹 🗓️$DATE 🔹 ⏲️$TIME " "
echo $WEATHER 🔹 🔊$VOLUME% 🔹 🗓️$DATE 🔹 ⏲️$TIME " "

