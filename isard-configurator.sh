#!/bin/bash

# Borra el terminal.
clear

# SCRIPT DISSENYAT PER CONFIGURAR MÀQUINES UBUNTU SERVER 22.04 del ISARDVDI


# Colors
R='\033[0;31m' #Vermell
G='\033[0;32m' #Verd
Y='\033[1;33m' #Groc
NC='\033[0m' # No Color
# per cridar als colors, s'han de posar davant del text: echo -e "${COLOR} text". Disponibles ${R} ${G} ${Y} ${NC}


# Definir la ruta de del fitxer netplan
FITXER_NETPLAN="/etc/netplan/00-installer-config.yaml"

# Definir la ruta de del fitxer PAM (per canviar els requisits de llargada de la contrasenya)
FITXER_PAM="/etc/pam.d/common-password"

# Crear o sobreescriure el fitxer de netplan
cat <<EOL > "$FITXER_NETPLAN"
network:
  ethernets:
    enp1s0:
      dhcp4: true
    enp2s0:
      addresses:
        - 172.16.39.10/24
EOL

# Aplica la configuració del fitxer netplan
netplan apply

# Després Borra el terminal.
clear

echo -e "S'ha actualitzat i aplicat la configuració del NETPLAN."
echo
echo

# Canvia la politica de minima llargada de la contrasenya a 1 caracter
echo -e "Adding lines to $FITXER_PAM"
cat <<EOL >> "$FITXER_PAM"
password  [success=1 default=ignore] 	pam_unix.so obscure yescript minlen=1
password	requisite	pam_deny.so
password	required	pam_permit.so
EOL

echo -e "${G} s'ha tret la restricció de llargada minima del Passwd ${NC} ($FITXER_PAM)"
echo
echo

# Pregunta si vols canviar la contrasenya.
read -p "Vols canviar la contrasenya? [Enter]=Si [Esc]/N=NO: " choice

case "$choice" in
  "" )
    passwd
    echo -e "${G} S'ha canviat la contrasenya correctament"
    ;;
  * )
    echo -e "${Y} No has volgut canviar la contrasenya"
    ;;
esac

# Després Borra el terminal.
clear

# Pregunta si vols Actualitzar els repositoris
read -p "Vols actualitzar els repositoris? [Enter]=Si [Esc]/N=NO: " ReposChoice

case "$ReposChoice" in
  "" )
    sudo apt update
    echo -e "${G} S'han actualitzat tots els repositoris"
    ;;
  * )
    echo -e "${Y} No has volgut canviar la contrasenya"
    ;;
esac

# Després Borra el terminal.
clear

# Pregunta si vols vols executar "console-setup" per canviar el tipus i la mida de la lletra 
read -p "Vols canviar el tipus i la mida de la lletra? [Enter]=Si [Esc]=NO: " FontChoice

case "$FontChoice" in
  "" )
    sudo dpkg-reconfigure console-setup
    echo -e "S'ha canviat la configuració de la lletra del terminal."
    ;;
  * )
    echo -e "${Y} No s'ha canviat la configuració lletra. Eso es todo amigo."
    ;;
esac


# Enllaç amb informació sobre el format de lletra i colors al BASH: https://misc.flogisoft.com/bash/tip_colors_and_formatting
