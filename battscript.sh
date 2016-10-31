#!/bin/sh

CHARGESTAT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep 'state' | awk -F" " '{ print $2 }' | sed -e 's/discharging//' -e 's/charging/+/') 

LEVEL=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep 'percentage' | awk -F" " '{ print $2 }' | sed -e 's/%//')

if [ "$CHARGESTAT" == "+" ]; then
    echo "Batt:<fc=#85FF00>"$LEVEL"</fc>%"$CHARGESTAT
elif [ "$LEVEL" -lt "20" ]; then
    echo "Batt:<fc=#FF8600>"$LEVEL"</fc>%!"
elif [ "$LEVEL" -ge "98" ]; then
    echo " Batt:<fc=#8CC4FF>"$LEVEL"</fc>%"
else
    echo "Batt:<fc=#CCCC00>"$LEVEL"</fc>%"
fi
