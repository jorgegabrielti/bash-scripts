#!/bin/bash

# Bastion host company
BASTION_HOST="<HOST BASTION>"

# Open connection vpn fortclient
echo "Openfortivpn starting ..."
nohup openfortivpn > /dev/null 2>&1 &

if [ "$?" == "0" ]; then
  echo -e "Openfortivpn connected: [OK]\n"
else 
  echo -e "Openfortivpn connected: [FAIL]\n"
fi


_sshpass_config ()
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

### sshpass with gpg
case $1 in 
    "--sshpass-config")
     _sshpass_config
     sshpass -e ssh ${USER}@${BASTION_HOST} -o StrictHostKeyChecking=no
     ;;
     *)
     exit 0
     ;;
esac

