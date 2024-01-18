#!/bin/bash

# SCRIPT DISSENYAT PER CONFIGURAR MÀQUINES UBUNTU SERVER 22.04 del ISARDVDI

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
echo "S'ha actualitzat i aplicat la configuració del NETPLAN."

# Canvia la politica de minima llargada de la contrasenya a 1 caracter
echo "Adding lines to $FITXER_PAM"
cat <<EOL >> "$FITXER_PAM"
password  [success=1 default=ignore] 	pam_unix.so obscure yescript minlen=1
password	requisite	pam_deny.so
password	required	pam_permit.so
EOL

echo "s'ha tret la restricció de llargada minima del Passwd ($FITXER_PAM)"

# Pregunta si vols canviar la contrasenya.
read -p "Vols canviar la contrasenya? [Enter]=Si [Esc]=NO: " choice

case "$choice" in
  "" )
    passwd
    echo "S'ha canviat la contrasenya correctament"
    ;;
  * )
    echo "Hasta luego lucas!"
    ;;
esac

# Pregunta si vols Actualitzar els repositoris
read -p "Vols canviar la contrasenya? [Enter]=Si [Esc]=NO: " ReposChoice

case "$ReposChoice" in
  "" )
    sudo apt update
    echo "S'han actualitzat tots els repositoris"
    ;;
  * )
    echo "Hasta luego lucas!"
    ;;
esac

# Pregunta si vols vols executar "console-setup" per canviar el tipus i la mida de la lletra 
read -p "Vols canviar la contrasenya? [Enter]=Si [Esc]=NO: " FontChoice

case "$FontChoice" in
  "" )
    sudo dpkg-reconfigure console-setup
    echo "S'ha canviat la configuració de la lletra al terminal"
    ;;
  * )
    echo " Eso es todo amigo, Hasta luego lucas!"
    ;;
esac


# Enllaç amb informació sobre el format de lletra i colors al BASH: https://misc.flogisoft.com/bash/tip_colors_and_formatting
