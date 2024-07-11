TIMESTAMP=$(date '+%s')

fetch_weather () {
  local CURRENT_WEATHER=$(curl --silent wttr.in/Cedartown?format=2\&u)
  echo $CURRENT_WEATHER
  echo $CURRENT_WEATHER > /tmp/wttr.in
  echo $TIMESTAMP >> /tmp/wttr.in
}
  
if [ -e /tmp/wttr.in ]; then
  LAST_CHECK_TIMESTAMP=$(tail -1 /tmp/wttr.in)
  DIFFERENCE=$(expr $TIMESTAMP - $LAST_CHECK_TIMESTAMP)
  if [ $DIFFERENCE -gt 300 ]; then
    WEATHER=$(fetch_weather)
  else
    WEATHER=$(head -1 /tmp/wttr.in)
  fi
else
  WEATHER=$(fetch_weather)
fi

echo $WEATHER
