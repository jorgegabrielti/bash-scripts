#!/bin/bash

# Requirements
# - openfortivpn
# - sshpass
# - gpg


### Default variables

# Bastion host company
BASTION_HOST="<BASTION HOST>"

# Openfortivpn configs
OPENFORTIVPN_RECONNECT_TIME_LOOP="120"
# ------------------------------------------------------

help () 
{
  echo "Usage: ./connectun.sh [OPTION]"
  echo "  --openfortivpn      connect a connect a fortigate-based vpn"
  echo "  --sshpass-config    config sshpass to access without password"
}


openfortivpn_connect ()
{
  # Open connection vpn fortclient
  echo "Openfortivpn starting ..."
  nohup openfortivpn --persistent=${OPENFORTIVPN_RECONNECT_TIME_LOOP} > /dev/null 2>&1 &

  if [ "$?" == "0" ]; then
    echo -e "Openfortivpn connected: [OK]\n"
  else 
    echo -e "Openfortivpn connected: [FAIL]\n"
  fi
}


sshpass_config ()
{
  if [ ! -e .sshpasswd.gpg ]; then
    read -p "Type your password: " PASSWORD
    echo ${PASSWORD} > .sshpasswd
    gpg -c .sshpasswd
    export SSHPASS=$(gpg -d -q .sshpasswd.gpg)
    rm -f .sshpasswd
  else
    read -p "A '.sshpasswd' file already exists. Do you want to set up a new password [y/N]: " NEW_PASSWORD_OPTION
    while [ ${NEW_PASSWORD_OPTION} != "y" -a ${NEW_PASSWORD_OPTION} != "Y" -a ${NEW_PASSWORD_OPTION} != "n" -a ${NEW_PASSWORD_OPTION} != "N" ]; do
         echo "Invalid option!"
	 read -p "Do you want to set up a new password [y/N]: " NEW_PASSWORD_OPTION	
    done

    # Config a new password condition
    if [ ${NEW_PASSWORD_OPTION} == "y" -o ${NEW_PASSWORD_OPTION} == "Y" ]; then
      read -p "Type your password: " PASSWORD
      echo ${PASSWORD} > .sshpasswd
      gpg -c .sshpasswd
      export SSHPASS=$(gpg -d -q .sshpasswd.gpg)
      rm -f .sshpasswd
    fi 
  fi 
}

#gitlab_server_tun () 
#{

#}

# Bastion host validation
[ $(echo ${BASTION_HOST} | grep -Eo '[0-9]{0,3}\.[0-9]{0,3}\.[0-9]{0,3}\.[0-9]{0,3}') ] \
&& echo "[OK]  :" \
|| echo "[FAIL]: Bastion host not defined!" && exit 0

### sshpass with gpg
case $1 in 

   "--sshpass-config")
     sshpass_config
     sshpass -e ssh ${USER}@${BASTION_HOST} -o StrictHostKeyChecking=no
   ;;
   "--openfortivpn")
     openfortivpn_connect
   ;;
   "-t|--tunnel")
   shift
    case "$1" in
	    "--gitlab-server")
        gitlab_server_tun
		  ;;
    esac  
   ;;
  *)
   help
  ;;

esac

