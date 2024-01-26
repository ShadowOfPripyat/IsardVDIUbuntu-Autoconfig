#!/bin/bash

# Borra el terminal.
clear
# SCRIPT DISSENYAT PER CONFIGURAR MÀQUINES UBUNTU SERVER 22.04 del ISARDVDI

 # Colors
R='\e[91m' #Vermell
G='\e[92m' #Verd
Y='\e[93m' #Groc
NC='\e[39m' # Color per defecte (blanc)
RA='\e[0m' #Fer un reset a tots els atributs de format al terminal
INV='\e[7m' # Inverteix els colors
 # Formatació
B='\e[1m' #Lletra Negreta
S='\e[4m' #Lletra subrallada
# per cridar als colors o formats, s'han de posar davant del text: echo -e "${COLOR} text". Disponibles ${R} ${G} ${Y} ${NC} ${B} ${S}
echo "${RA}" # Fer reset als colors del terminal
# Definir la ruta de del fitxer netplan i Definir la ruta de del fitxer PAM (per canviar els requisits de llargada de la contrasenya)
FITXER_NETPLAN="/etc/netplan/00-installer-config.yaml"
FITXER_PAM="/etc/pam.d/common-password"
USUARI=$(whoami)
# Genera un número aleatori entre 1 i 65 per la IP.
randip=$(shuf -i 1-65 -n 1)

# Create an IP address with the random number
ip_default="172.16.$randip.1"


#----INICI--------------------------------------------------------------------------------------------------------------------------------------------

# Funció per Imprimir el Títol ascii art
PosarTitol() {
cat << "EOF"

    Benvingut al...
    _________ ___    ____  ____     __________  _   ____________________  ______  ___  __________  ____ 
   /  _/ ___//   |  / __ \/ __ \   / ____/ __ \/ | / / ____/  _/ ____/ / / / __ \/   |/_  __/ __ \/ __ \
   / / \__ \/ /| | / /_/ / / / /  / /   / / / /  |/ / /_   / // / __/ / / / /_/ / /| | / / / / / / /_/ /
 _/ / ___/ / ___ |/ _, _/ /_/ /  / /___/ /_/ / /|  / __/ _/ // /_/ / /_/ / _, _/ ___ |/ / / /_/ / _, _/ 
/___//____/_/  |_/_/ |_/_____/   \____/\____/_/ |_/_/   /___/\____/\____/_/ |_/_/  |_/_/  \____/_/ |_| v1.76
EOF
}
# Crida al Títol
PosarTitol

echo
echo
echo "${B} ${S} Aquest script et permet:"
echo "  - Configurar el netplan per la targeta "Personal""
echo "  - ${R} TREURE ${B} ${S} la CONTRASENYA ()"
echo "  - Actualitzar els Repositoris"
echo "  - Canviar la Mida de la Lletra"
echo
echo ${RA}

# Funció per introduir una IP personalitzada
read_custom_ip() {
  read -p "Introdueix una IP per la targeta "enp2s0" (Predeterminada $ip_default/24): " custom_ip
}

echo

# Pregunta si configurar una IP.
read -p "vols configurar una IP per la "Personal" (enp2s0)? (s/n): " set_custom_ip

case $set_custom_ip in
  [sS])
    read_custom_ip
    ;;
  *)
    custom_ip=$ip_default
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


# ALIAS personalitzats
aliases_content=$(cat <<'EOL'
alias ..='cd ..'
alias ...='cd ../..'
alias ç="clear"
alias celar="clear"
alias cler="clear"
alias clare="clear"
alias cd..='cd ..'
alias cd...='cd ../..'
alias atp='apt'
alias isntall='sudo apt install'
alias install='sudo apt install'
alias netply='sudo netplan apply'
alias ping='ping -c 4'
alias update='sudo apt-get update && sudo apt-get upgrade'
EOL
)
# Path to the .bash_aliases file
bash_aliases_file="$HOME/.bash_aliases"
# Create or overwrite the .bash_aliases file
echo "$aliases_content" > "$bash_aliases_file"
# Apply the aliases
source "$bash_aliases_file"

# Instala el BAT
echo instalant el BAT...
echo
curl -sLO https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-musl_0.24.0_amd64.deb
sudo dpkg -i bat-musl_0.24.0_amd64.deb
rm *bat-musl_0.24.0_amd64.deb


# Després Borra el terminal.
clear

# Crida al Títol un altre cop
PosarTitol

echo "INFO: ${G} S'ha instalat la comanda 'BAT', una versió millorada del 'CAT'"
echo "INFO: ${G} s'han aplicat alias per facilitar la execucio de comandes"
echo "INFO: ${G} S'ha actualitzat i aplicat la configuració del NETPLAN."
echo "($FITXER_NETPLAN)"
echo ${RA}
# Pregunta si vols canviar la contrasenya.
read -p "   Vols treure la contrasenya? [Enter]=Si [Esc]/N=NO: " choice

case "$choice" in
  "" )
    passwd -d $USUARI
    echo "${G} S'ha eliminat la contrasenya correctament"
    ;;
  * )
    echo "${Y} No has volgut canviar la contrasenya"
    ;;
esac


# [NO UTILITZAT] Funció per definir una contrasenya diferent, que també crida a la funció "ModificarPolitica" per treure la restrició de caracters mínims de la contrasenya.

# Funció que Canvia la politica de minima llargada de la contrasenya a 1 caracter
# ModificarPolitica() {
# cat <<EOL > "$FITXER_PAM"
# password  [success=1 default=ignore] 	pam_unix.so obscure yescript minlen=1
# password	requisite	pam_deny.so
# password	required	pam_permit.so
# EOL
# echo
# echo
# echo "INFO: ${G} s'ha tret la restricció de llargada minima del Passwd ${NC}"
# echo "($FITXER_PAM)"
# echo ${RA}
# }

# read -p "   Vols canviar la contrasenya? [Enter]=Si [Esc]/N=NO: " choice

# case "$choice" in
#   "" )
#     ModificarPolitica
#     passwd
#     echo "${G} S'ha canviat la contrasenya correctament"
#     ;;
#   * )
#     echo "${Y} No has volgut canviar la contrasenya"
#     ;;
# esac

# Després Borra el terminal.
clear

# Crida al Títol un altre cop
PosarTitol

# Pregunta si vols Actualitzar els repositoris
echo
echo
read -p "Vols actualitzar els repositoris? [Enter]=Si [Esc]/N=NO: " ReposChoice

case "$ReposChoice" in
  "" )
    sudo apt update
    echo "${G} S'han actualitzat tots els repositoris"
    ;;
  * )
    echo
    echo
    echo "${Y} No has volgut canviar la contrasenya"
    echo
    echo
    ;;
esac

# Després Borra el terminal.
clear

# Crida al Títol un altre cop
PosarTitol

# Pregunta si vols vols executar "console-setup" per canviar el tipus i la mida de la lletra 
read -p "Vols canviar el tipus i la mida de la lletra? [Enter]=Si [Esc]=NO: " FontChoice

case "$FontChoice" in
  "" )
    sudo dpkg-reconfigure console-setup

    echo
    echo
    echo "S'ha canviat la configuració de la lletra del terminal."
    echo
    echo
    ;;
  * )
    echo
    echo
    echo "${Y} No s'ha canviat la configuració de lletra. Eso es todo amigo."
    echo
    echo "chao pescao"
    ;;
esac

echo "${RA}"

# cat << "EOF"
# gud luk boi
# QQQQQQQQQQQQQQQQQQWQQQQQWWWBBBHHHHHHHHHBWWWQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
# QQQQQQQQQQQQQQD!`__ssaaaaaaaaaass_ass_s____.  -~""??9VWQQQQQQQQQQQQQQQQ
# QQQQQQQQQQQQP'_wmQQQWWBWV?GwwwmmWQmwwwwwgmZUVVHAqwaaaac,"?9$QQQQQQQQQQQ
# QQQQQQQQQQW! aQWQQQQW?qw#TTSgwawwggywawwpY?T?TYTYTXmwwgZ$ma/-?4QQQQQQQQ
# QQQQQQQQQW' jQQQQWTqwDYauT9mmwwawww?WWWWQQQQQ@TT?TVTT9HQQQQQQw,-4QQQQQQ
# QQQQQQQQQ[ jQQQQQyWVw2$wWWQQQWWQWWWW7WQQQQQQQQPWWQQQWQQw7WQQQWWc)WWQQQQ
# QQQQQQQQf jQQQQQWWmWmmQWU???????9WWQmWQQQQQQQWjWQQQQQQQWQmQQQQWL 4QQQQQ
# QQQQQQP'.yQQQQQQQQQQQP"       <wa,.!4WQQQQQQQWdWP??!"??4WWQQQWQQc ?QWQQ
# QQQQP'_a.<aamQQQW!<yF "!` ..  "??$Qa "WQQQWTVP'    "??' =QQmWWV?46/ ?QQ
# QQP'sdyWQP?!`.-"?46mQQQQQQT!mQQgaa. <wWQQWQaa _aawmWWQQQQQQQQQWP4a7g -W
# Q[ j@mQP'adQQP4ga, -????" <jQQQQQWQQQQQQQQQWW;)WQWWWW9QQP?"`  -?QzQ7L ]
# W jQkQ@ jWQQD'-?$QQQQQQQQQQQQQQQQQWWQWQQQWQQQc "4QQQQa   .QP4QQQQfWkl j
# E ]QkQk $D?`  waa "?9WWQQQP??T?47`_aamQQQQQQWWQw,-?QWWQQQQQ`"QQQD\Qf(.Q
# Q,-Qm4Q/-QmQ6 "WWQma/  "??QQQQQQL 4W"- -?$QQQQWP`s,awT$QQQ@  "QW@?$:.yQ
# Qm/-4wTQgQWQQ,  ?4WWk 4waac -???$waQQQQQQQQF??'<mWWWWWQW?^  ` ]6QQ' yQQ
# QQQw,-?QmWQQQQw  a,    ?QWWQQQw _.  "????9VWaamQWV???"  a j/  ]QQf jQQQ
# QQQQQw,"4QQQQQQm,-$Qa     ???4F jQQQQQwc <aaas _aaaaa 4QW ]E  )WQ`=QQQQ
# QQQQQWQ/ $QQQQQQQa ?H ]Wwa,     ???9WWWh dQWWW,=QWWU?  ?!     )WQ ]QQQQ
# QQQQQQQQc-QWQQQQQW6,  QWQWQQQk <c                             jWQ ]QQQQ
# QQQQQQQQQ,"$WQQWQQQQg,."?QQQQ'.mQQQmaa,.,                . .; QWQ.]QQQQ
# QQQQQQQQWQa ?$WQQWQQQQQa,."?( mQQQQQQW[:QQQQm[ ammF jy! j( } jQQQ(:QQQQ
# QQQQQQQQQWWma "9gw?9gdB?QQwa, -??T$WQQ;:QQQWQ ]WWD _Qf +?! _jQQQWf QQQQ
# QQQQQQQQQQQQQQws "Tqau?9maZ?WQmaas,,    --~-- ---  . _ssawmQQQQQQk 3QQQ
# QQQQQQQQQQQQQQQWQga,-?9mwad?1wdT9WQQQQQWVVTTYY?YTVWQQQQWWD5mQQPQQQ ]QQQ
# QQQQQQWQQQQQQQQQQQWQQwa,-??$QwadV}<wBHHVHWWBHHUWWBVTTTV5awBQQD6QQQ ]QQQ
# QQQQQQQQQQQQQQQQQQQQQWWQQga,-"9$WQQmmwwmBUUHTTVWBWQQQQWVT?96aQWQQQ ]QQQ
# QQQQQQQQQWQQQQWQQQQQQQQQQQWQQma,-?9$QQWWQQQQQQQWmQmmmmmQWQQQQWQQW(.yQQQ
# QQQQQQQQQQQQWQQQQQQWQQQQQQQQQQQQQga%,.  -??9$QQQQQQQQQQQWQQWQQV? sWQQQQ
# QQQQQQQQWQQQQQQQQQQQQQQWQQQQQQQQQQQWQQQQmywaa,;~^"!???????!^`_saQWWQQQQ
# QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQWWWWQQQQQmwywwwwwwmQQWQQQQQQQQ
# EOF

# Enllaç amb informació sobre el format de lletra i colors al BASH: https://misc.flogisoft.com/bash/tip_colors_and_formatting
# ús de la comanda "expect" per esperar un prompt i "send" per enviar un text: https://phoenixnap.com/kb/linux-expect
