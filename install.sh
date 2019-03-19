# ! /bin/bash
# Programa especializado en la instalacion de la personalizacion de I3WM

# Autor: Gabriel Vargas Monroy

base=~/.i3
# base=~/Documentos/.i3
i3conf=~/.config/i3/config
#i3conf=~/Documentos/cursos/config
rofiThemeConfig=~/.config/rofi
crona_path=/var/spool/cron
user=$(whoami)

instalar_dependencias()
{
    programas=`cat program.dat`

    echo "Las dependecias solo funcionan con ARCHLINUX y derivados."
    echo -e "\nActualizando..."
    sudo pacman -Syu
    clear
    echo "Hecho"
    echo -e "\nInstalando Dependencias"
    sudo pacman -S $programas
    clear
    echo "Hecho"
}

salvar_personalizacion_actual()
{
    base_back=$base-backup
    if [ -d $base ]; then
        echo "Se detecto una configuracion en $base pasando a -> $base-backup"
        mkdir $base_back
        mv $base/* $base_back # Metiendo todo lo que haya en i3 a i3-back
    else
        mkdir $base/
    fi
    echo "Pasando la configuracion de i3/config a i3/config-backup"
    mv $i3conf $i3conf-backup # Cambaindo el nombre a la configuracion de i3
    sleep 2
}

instalar_personalizacion()
{
    rofi_theme=$base/theme/rofi
    i3_config=$base/i3-config/config

    echo "Configurando..."
    sleep 1

    echo "Configuracion Base"
    cp -Rf ./* $base/
    cd $base
    sleep 1

    echo "Configuracion de Rofi"
    if [ ! -d $rofiThemeConfig ]; then
        mdkir -p $rofiThemeConfig
    fi
    cp -Rf $rofi_theme/* $rofiThemeConfig/
    sleep 1

    echo "Configurando i3WM"
    touch $i3conf
    cp $i3_config $i3conf
    sleep 1

    echo "Cargando Procesos..."
    batteryProcess=$HOME/.i3/scripts/batteryNotify.sh
    if [ ! -d $crona_path ]; then
        mkdir -p $crona_path
    fi
    echo "* * * * * XDG_RUNTIME_DIR=/run/user/\$(id -u) $batteryProcess" >> $crona_path/$user
    sudo systemctl start cronie.service
    sudo systemctl enable cronie.service
    sleep 1

    echo "Configuracion de MPD"
    mpdSU=/etc/mpd.conf
    mpdUS=~/.config/mpd
    mpdPath=$base/mpd
    archivoMPD=$base/configs/mpd.conf
    echo "# Configuracion hecha por: Gabriel Vargas Monroy" > $archivoMPD
    echo "" >> $archivoMPD
    echo "auto_update \"yes\"" >> $archivoMPD
    echo "bind_to_address \"0.0.0.0\"" >> $archivoMPD
    echo "" >> $archivoMPD
    echo "music_directory \"$HOME/Música\"" >> $archivoMPD
    echo "playlist_directory \"$HOME/.i3/mpd/playlists\"" >> $archivoMPD
    echo "db_file \"$HOME/.i3/mpd/tag_cache\"" >> $archivoMPD
    echo "log_file \"$HOME/.i3/mpd/log\"" >> $archivoMPD
    echo "pid_file \"$HOME/.i3/mpd/pid\"" >> $archivoMPD
    echo "state_file \"$HOME/.i3/mpd/state\"" >> $archivoMPD
    echo "" >> $archivoMPD
    echo "user \"$user\"" >> $archivoMPD
    sudo cp $archivoMPD $mpdSU
    sudo chmod 644 $mpdSU
    if [ ! -e $mpdUS ]; then
        mkdir $mpdUS
        touch $mpdUS/mpd.conf
    fi
    cp $archivoMPD $mpdUS
    if [ ! -d $mpdPath ]; then
        mkdir $mpdPath
    fi
    mkdir $mpdPath/playlists
    touch $mpdPath/pid
    touch $mpdPath/error.log

    echo "Para que los cambios surtan efecto poner WIN+SHIFT+R para reiniciar i3"
    sleep 3
}

# Limpiar la pantalla
clear

echo "------------"
echo "Instalacion de la personalizacion de i3wm en archlinux"
echo "------------"

# Desplegar Menu
echo "----------------"
read -n1 -p "Desea Instalar la configuracion?(syYS|n):" opcion
echo -e "\n"
echo "----------------"

case $opcion in
    s|S|Y|y)
        salvar_personalizacion_actual
        instalar_dependencias
        instalar_personalizacion
esac
