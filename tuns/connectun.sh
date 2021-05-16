#!/bin/bash

# Requirements
# - openfortivpn
# - sshpass
# - gpg

sed -i 's/\r$//' conf/tuns.db
sed -i 's/\r$//' conf/connectun.conf

help () 
{
  echo "Usage: ./connectun.sh [OPTION]"
  echo "  --openfortivpn      connect a fortigate-based vpn"
  echo "  --sshpass-config    config sshpass to access without password"
  echo "  --tunnel            ssh tunnels defined in the file conf/tuns.db"
  
}

openfortivpn_connect ()
{
  source conf/connectun.conf
  # Bastion host validation
  if [ $(echo ${BASTION_HOST} | grep -Eo '[0-9]{0,3}\.[0-9]{0,3}\.[0-9]{0,3}\.[0-9]{0,3}') ]; then
    echo -e "\n[OK]  : Bastion host defined!"
  else
    echo -e "\n[FAIL]: Bastion host not defined!" 
  fi

  if [ "$($(which pgrep) -c openfortivpn)" == "1" ]; then
    echo -e "\nOpenfortivpn is running...\nStarting ping test conneciton..."
    ping -c 4 -q ${BASTION_HOST}
    if [ "$?" == "0" ]; then
      echo -e "\nOpenfortivpn up and running...\n"
    fi 
  else
    # Open connection vpn fortclient
    echo -e "\nOpenfortivpn starting ...\n"
    nohup openfortivpn --persistent=${OPENFORTIVPN_RECONNECT_TIME_LOOP} & > /dev/null 2>&1 

    if [ "$?" == "0" ]; then
      echo -e "Openfortivpn connected: [OK]\n"
    else 
      echo -e "Openfortivpn connected: [FAIL]\n"
    fi
  fi   
}


sshpass_config ()
{
  source conf/connectun.conf

  # Bastion host validation
  if [ $(echo ${BASTION_HOST} | grep -Eo '[0-9]{0,3}\.[0-9]{0,3}\.[0-9]{0,3}\.[0-9]{0,3}') ]; then
    echo -e "\n[OK]: Bastion host defined!"
  else
    echo -e "\n[FAIL]: Bastion host not defined!" 
  fi

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

valid_ip ()
{
  for IP in ${@}; do
    if [ grep -Eo '[0-9]{0,3}\.[0-9]{0,3}\.[0-9]{0,3}\.[0-9]{0,3}' "${IP}" ]; then
      echo "IP valid: [OK]"
    else  
      echo "IP valid: [FAIL]"
      exit 0
    fi 
  done
}

# Tunnel create
host_connect ()
{
  # Source config file
  source conf/connectun.conf
  source conf/tuns.db

  # Connect to vpn
  openfortivpn_connect

  # Validation regex ip
  valid_ip ${PROXY} ${HOST}

  # Connect in proxy to tunnel
  sed -i 's/\r$//' conf/tuns.conf
  TUN_COUNT=$(grep -cv 'localport' conf/tuns.db)
  for ((i=0; i<${TUN_COUNT}; i++)); do 
    STRING_TUNS["$i"]="$(echo -L:$(grep -v 'localport' conf/tuns.db | head -n$((${i} + 1)) | tail -n1))"
  done
  sshpass -p $(gpg -d -q .sshpasswd.gpg) ssh ${STRING_TUNS[*]} ${USER_TUN}@${BASTION_HOST} -o StrictHostKeyChecking=no -fgnNT 

}

### sshpass with gpg
case $1 in 

  "--sshpass-config")
    sshpass_config
    openfortivpn_connect
    echo -e "\nTry: 'sshpass -p \$(gpg -d -q .sshpasswd.gpg) ssh ${USER_TUN}@${BASTION_HOST} -o StrictHostKeyChecking=no'"
  ;;
  "--openfortivpn")
    openfortivpn_connect
  ;;
  "--tunnel")
    host_connect ${PROXY} ${HOST[*]}
	;;
  *)
    help
  ;;

esac

