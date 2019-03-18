# ! /bin/bash

# Permite mandar un dialogo que avise si la bateria esta completa o esta vacia
# Autor: Gabriel Vargas Monroy - tw: v_mgabriel

expresion=$(/usr/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | grep -Eo "([0-9]{1,3})")
expresion=$(($expresion + 0))
load=$(/usr/bin/upower -i $(upower -e | grep 'BAT') | grep -E "state" | grep -Eo "charging|discharging|fully-charged")

if [ "$load" = "fully-charged" ]; then
    /usr/bin/dunstify --appname="Battery Notify" --urgency=0 "<b>Bateria Completamente Cargada</b>" "La bateria se Encuentra al $expresion%"
fi

if [ $expresion -ge 96 ] && [ "$load" = "charging" ]; then
    /usr/bin/dunstify --appname="Battery Notify" --urgency=1 "<b>Bateria Completa</b>" "La bateria se encuentra en el $expresion%"
fi

if [ $expresion -lt 16 ] && [ $expresion -ge 10 ] && [ "$load" = "discharging" ]; then
    /usr/bin/dunstify --appname="Battery Notify" --urgency=1 "<b>Bateria Limitada</b>" "La bateria se encuentra en el minimo deseado: $expresion%"
fi

if [ $expresion -le 9 ] && [ "$load" = "discharging" ]; then
    /usr/bin/dunstify --appname="Battery Notify" --urgency=0 "<b>Bateria Critica</b>" "La bateria se Encuentra en Estado muy Bajo $expresion%, por favor conectarlo"
fi
