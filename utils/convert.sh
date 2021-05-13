#!/bin/bash

grep -vi 'duration' report.csv \
| while read LINE; do

    DURATION="$(echo $LINE | cut -d',' -f7 | tr -d '"')"

    # Time obtained
    if [ $(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '[[:digit:]]d') ]; then
      DAY=$(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '[[:digit:]]d' | tr -d '[:alpha:]')
      D=$(echo "${DAY}*86400" | bc)
      DURATION_CONVERT="${D}"
    fi 

    if [ $(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '[[:digit:]]h') ]; then
      HOU=$(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '[[:digit:]]h' | tr -d '[:alpha:]')
      H=$(echo "${HOU}*3600" | bc)
      if [ ! -z ${DURATION_CONVERT} ]; then
        DURATION_CONVERT="${DURATION_CONVERT}+${H}"
      else
        DURATION_CONVERT="${H}"
      fi 
    fi
    
    if [ $(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '[[:digit:]]m') ]; then
      MIN=$(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '[[:digit:]]m' | tr -d '[:alpha:]')
      M=$(echo "${MIN}*60" | bc)
      if [ ! -z ${DURATION_CONVERT} ]; then
        DURATION_CONVERT="${DURATION_CONVERT}+${M}"
      else
        DURATION_CONVERT="${M}"
      fi
    fi 

    if [ $(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '[[:digit:]]s') ]; then
      SEC=$(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '[[:digit:]]s' | tr -d '[:alpha:]')
      S=${SEC} 
      if [ ! -z ${DURATION_CONVERT} ]; then
        DURATION_CONVERT="${DURATION_CONVERT}+${S}"
      else
        DURATION_CONVERT="${S}"
      fi
    fi
    echo ${DURATION_CONVERT} | bc
    unset DURATION_CONVERT
  done 
  
#| tee -a new.csv


#echo ${LINE} | sed "s/$DURATION/${DURATION_CONVERT}/g"
#grep -vi 'duration' report.csv | while read LINE; do      DURATION=$(echo $LINE | cut -d',' -f7);      DURATION_CONVERTED=$(echo $LINE | cut -d',' -f7 | tr -s '[=h=]|[=m=][:blank:]' ':' | tr -d 's|"|\'\' | cut -d':' -f -3);      echo ${LINE} | sed "s/$DURATION/${DURATION_CONVERTED}/g";  done | tee -a new.csv

