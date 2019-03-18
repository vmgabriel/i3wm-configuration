# ! /bin/bash
# Programa especializado en la instalacion de la personalizacion de I3WM

# Autor: Gabriel Vargas Monroy

base=~/Documentos/.i3
# i3conf=~/.config/i3/conf
i3conf=~/Documentos/cursos/conf

instalar_dependencias()
{
    programas=`cat program.dat`
    sleep 3

    echo "Las dependecias solo funcionan con ARCHLINUX y derivados."
    echo -e "\nActualizando..."
    # sudo pacman -Syu
    clear
    echo "Hecho"
    echo -e "\nInstalando Dependencias"
    sleep 3
    # sudo pacman -S $programas
    clear
    echo "Hecho"
}

salvar_personalizacion_actual()
{
    base_back=$base-backup
    if [ -d $base ]; then
        echo "Se detecto una configuracion en $base pasando a -> $base-backup"
        mkdir $base_back
        mv -Rf $base/* $base_back
    fi
    mv $i3conf $i3conf-backup
}

instalar_personalizacion()
{
    echo -e "\n"
    instalar_dependencias
    sleep 3
}

desinstalar_personalizacion()
{
    echo -e "\n"
    echo "No se desinstalaran las Dependencias"x
}

# Limpiar la pantalla
clear

# Desplegar Menu
echo "----------------"
echo "1. Instalar Personalizacion"
echo "2. Desinstalar Personalizacion"
echo "----------------"

read -n1 -p "Ingrese una opcion[1-2]:" opcion

case $opcion in
    1)
        if [ ! -d $base/ ]; then
            mkdir $base/
        fi

        cp -Rf ./* $base/
        cd $base
        # cd ~/.i3

        salvar_personalizacion_actual
        instalar_personalizacion
        ;;
    2)
        desinstalar_personalizacion
        ;;
esac
