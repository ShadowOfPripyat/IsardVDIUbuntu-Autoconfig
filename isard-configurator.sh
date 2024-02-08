#!/bin/bash
# check if dialog is installed and if its not, install it
REQUIRED_PKG="dialog"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "Please Wait"
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi

# Genera un número aleatori entre 1 i 65 per la IP.
randip=$(shuf -i 1-65 -n 1)
randhost=$(shuf -i 5-20 -n 1)
# Create an IP address with the random number
example_ip="172.16.$randip.$randhost"
FITXER_NETPLAN="/etc/netplan/00-installer-config.yaml"
FITXER_PAM="/etc/pam.d/common-password"



#-------------check-if-packages-are-installed-----------------------
pkg1=$(
  # Check if is installed
  PKG_NAME1="bat"
  # PKG_OKY6=$(dpkg-query -W --showformat='${Package}\n' $PKG_NAME2|grep "PKG_NAME2" 2> /dev/null)
  if dpkg-query -W --showformat='${Status}\n' $PKG_NAME1 2>/dev/null |grep "install ok installed" > /dev/null; then
    echo "$PKG_NAME1 is Installed"
  else
    echo "$PKG_NAME1 is not installed."
  fi
)

pkg2=$(
  PKG_NAME2="webmin"
  if dpkg-query -W --showformat='${Status}\n' $PKG_NAME2 2>/dev/null |grep "install ok installed" > /dev/null; then
    echo "$PKG_NAME2 is Installed"
  else
    echo "$PKG_NAME2 is not installed."
  fi
)


#---------------ALIAS personalitzats--------------
# Path to the .bash_aliases file
bash_aliases_file="$HOME/.bash_aliases"

makealiases_file(){
cat <<EOL > "$bash_aliases_file"
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
# Apply the aliases
source "$bash_aliases_file"
}

#----------------NETPLAN------------
netplanInputbox() {
    exec 3>&1;
    $custom_ip=$(dialog --clear --title "Set enp2s0 IP address" --inputbox "Introdueix la IP que vols utilitzar: \n\n exemple: $example_ip " 0 0 2>&1 1>&3);
    exec 3>&-;

    # Check if dialog was cancelled or user didn't input anything
    if [ $? -ne 0 ] || [ -z "$$custom_ip" ]; then
        echo "Operation cancelled. Maybe you didnt write an IP?"
        return
    fi

    #sanitize input with
    $custom_ip=$(echo "$$custom_ip" | tr -d '\n')  # Remove newline character (sanitize)
    echo "IP Address "$$custom_ip" successfully set"
}



configurarNetplan(){
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

sudo netplan apply
}


#----------------DELETE--USER--PASSWORD---------------
deletepassword(){
    passwd -d $USER
}


#----------------other------------

#  doallabove(){

#  }
#--------------------------------------------------START--GRAPHICAL--INTERFACE------------------------------------------------------#

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0



display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}


while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "ISARD CONFIGURATOR v1 GRAPHICAL-EDITION" \
    --title "ISARD CONFIGURATOR - $ldap_domain" \
    --clear \
    --cancel-label "Exit" \
    --menu "INFO: \n $pkg1 \n $pkg2 \n  \n \n Please select:" $HEIGHT $WIDTH 6 \
    "1" "Configurar el netplan per la targeta 'Personal'" \
    "2" "Treure la contrasenya del usuari $USER" \
    "3" "Canviar la mida de lletra del terminal" \
    "4" "Descarregar el Script 'LDAP-CONFIGURATOR'" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    1 )
      netplanInputbox
      configurarNetplan
      result=$(echo "S'ha canviat la IP de netplan. Comprova la configuració!")
      display_result "Configuració NETPLAN"
      ;;
    2 )
      deletepassword
      result=$(echo "S'ha eliminat la contrasenya. Ara ja no l'hauràs d'introduir fins que creis una nova.")
      display_result "Eliminar Contrasenya"
      ;;
    3 )
      dpkg-reconfigure console-setup
      result=$(echo "S'ha canviat la mida de lletra")
      display_result "Canviar Mida de lletra"
      ;;
    4 )
      wget -O ldap-configurator.sh https://raw.githubusercontent.com/ShadowOfPripyat/ldapconfigurator/main/ldap-configurator.sh
      result=$(echo "S'ha descarregat el LDAP CONFIGURATOR")
      display_result "Canviar Mida de lletra"
      ;;
    # 5 )
    #   #Afegir Repo webmin
    #   result=$(echo "El script de webmin encara no està implementat")
    #   display_result "Funció no implementada"
    #   ;;
    # 6 )
    #   #Instalar webmin
    #   result=$(echo "El script de webmin encara no està implementat")
    #   display_result "Funció no implementada"
    #   ;;
    # 7 )
    #   #Insertar Aqui
    #   result=$(echo "No està implementat")
    #   display_result "Funció no implementada"
    #   ;;
    # 8 )
    #   #Insertar Aqui
    #   result=$(echo "No està implementat")
    #   display_result "Funció no implementada"
    #   ;;
    # 9 )
    #   #Insertar Aqui
    #   result=$(echo "No està implementat")
    #   display_result "Funció no implementada"
    #   ;;
    # 7 )
    #   if [[ $(id -u) -eq 0 ]]; then
    #     result=$(du -sh /home/* 2> /dev/null)
    #     display_result "Home Space Utilization (All Users)"
    #   else
    #     result=$(du -sh $HOME 2> /dev/null)
    #     display_result "Home Space Utilization ($USER)"
    #   fi
    #   ;;
  esac
done
#-----------------------------------------------------END--GRAPHICAL--INTERFACE------------------------------------------------------#
    # "5" "Afegir repositori Webmin - No Implementat" \
    # "6" "Instalar Webmin - No Implementat" \
    # "7" "Instalar BAT (CAT millorat) - No Implementat" \
    # "8" "Fer TOT lo llistat a dalt - No Implementat" \
    # "9" "Més Opcions... (No Implementat)" \
