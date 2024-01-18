#!/bin/bash

# Borra el terminal.
echo "${RA}"
clear
# SCRIPT DISSENYAT PER CONFIGURAR MÀQUINES UBUNTU SERVER 22.04 del ISARDVDI

 # Colors
R='\e[91m' #Vermell
G='\e[92m' #Verd
Y='\e[93m' #Groc
NC='\e[39m' # Color per defecte (blanc)
RA='\e[0m' #Fer un reset a tots els atributs de format al terminal
 # Formatació
B='\e[1m' #Lletra Negreta
S='\e[4m' #Lletra subrallada

# per cridar als colors o formats, s'han de posar davant del text: echo -e "${COLOR} text". Disponibles ${R} ${G} ${Y} ${NC} ${B} ${S}

# Definir la ruta de del fitxer netplan i Definir la ruta de del fitxer PAM (per canviar els requisits de llargada de la contrasenya)
FITXER_NETPLAN="/etc/netplan/00-installer-config.yaml"
FITXER_PAM="/etc/pam.d/common-password"

# Genera un número aleatori entre 1 i 65 per la IP.
randip=$((1 + RANDOM % 65))

echo
echo
echo "${B} ${S} Aquest Script configura el netplan, et deixa posar una contrassenya de 1 caracter i t'obre un asistent per canviar la mida de la lletra"
echo 
echo
echo ${RA}

# Funció per introduir una IP personalitzada
read_custom_ip() {
  read -p "Enter custom IP address for enp2s0 (press Enter for default 172.16.$randip.10/24): " custom_ip
}

# Ask user for custom IP
read -p "vols posar una IP per la targeta "Personal" (enp2s0)? (s/n): " set_custom_ip

case $set_custom_ip in
  [sS])
    read_custom_ip
    ;;
  *)
    custom_ip="172.16.$randip.10"
    ;;
esac

# Crear o sobreescriure el fitxer de netplan
cat <<EOL > "$FITXER_NETPLAN"
network:
  ethernets:
    enp1s0:
      dhcp4: true
    enp2s0:
      addresses:
        - $custom_ip/24
EOL

# Aplica la configuració del fitxer netplan
netplan apply

# Després Borra el terminal.
clear

echo
echo
echo -e "S'ha actualitzat i aplicat la configuració del NETPLAN."
echo
echo

# Canvia la politica de minima llargada de la contrasenya a 1 caracter
cat <<EOL >> "$FITXER_PAM"
password  [success=1 default=ignore] 	pam_unix.so obscure yescript minlen=1
password	requisite	pam_deny.so
password	required	pam_permit.so
EOL

echo
echo
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
echo
echo
read -p "Vols actualitzar els repositoris? [Enter]=Si [Esc]/N=NO: " ReposChoice

case "$ReposChoice" in
  "" )
    sudo apt update
    echo -e "${G} S'han actualitzat tots els repositoris"
    ;;
  * )
    echo
    echo
    echo -e "${Y} No has volgut canviar la contrasenya"
    echo
    echo
    ;;
esac

# Després Borra el terminal.
clear

# Pregunta si vols vols executar "console-setup" per canviar el tipus i la mida de la lletra 
read -p "Vols canviar el tipus i la mida de la lletra? [Enter]=Si [Esc]=NO: " FontChoice

case "$FontChoice" in
  "" )
    sudo dpkg-reconfigure console-setup

    echo
    echo
    echo -e "S'ha canviat la configuració de la lletra del terminal."
    echo
    echo
    ;;
  * )
    echo
    echo
    echo -e "${Y} No s'ha canviat la configuració lletra. Eso es todo amigo."
    echo
    echo
    ;;
esac

echo "${RA}"

# Enllaç amb informació sobre el format de lletra i colors al BASH: https://misc.flogisoft.com/bash/tip_colors_and_formatting
