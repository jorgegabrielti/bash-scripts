#!/bin/bash

FILE=$1

grep -vi 'duration' ${FILE} \
| while read LINE; do

    DURATION="$(echo $LINE | cut -d',' -f7 | tr -d '"')"

    # Time obtained
    if [ $(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '.[[:digit:]]{0,9}d') ]; then
      DAY=$(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '.[[:digit:]]{0,9}d' | tr -d '[:alpha:]')
      D=$(echo "${DAY}*86400" | bc)
      DURATION_CONVERT="${D}"
    fi 

    if [ $(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '.[[:digit:]]{0,9}h') ]; then
      HOU=$(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '.[[:digit:]]{0,9}h' | tr -d '[:alpha:]')
      H=$(echo "${HOU}*3600" | bc)
      if [ ! -z ${DURATION_CONVERT} ]; then
        DURATION_CONVERT="${DURATION_CONVERT}+${H}"
      else
        DURATION_CONVERT="${H}"
      fi 
    fi
    
    if [ $(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '.[[:digit:]]{0,9}m') ]; then
      MIN=$(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '.[[:digit:]]{0,9}m' | tr -d '[:alpha:]')
      M=$(echo "${MIN}*60" | bc)
      if [ ! -z ${DURATION_CONVERT} ]; then
        DURATION_CONVERT="${DURATION_CONVERT}+${M}"
      else
        DURATION_CONVERT="${M}"
      fi
    fi 

    if [ $(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '.[[:digit:]]{0,9}s') ]; then
      SEC=$(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '.[[:digit:]]{0,9}s' | tr -d '[:alpha:]')
      S=${SEC} 
      if [ ! -z ${DURATION_CONVERT} ]; then
        DURATION_CONVERT="${DURATION_CONVERT}+${S}"
      else
        DURATION_CONVERT="${S}"
      fi
    fi
    DURATION_CONVERT=$(echo ${DURATION_CONVERT} | bc)
    echo ${LINE} | sed "s/$DURATION/${DURATION_CONVERT}/g"
    unset DURATION_CONVERT
  done | tee -a ${FILE%%.csv}${FILE%%.csv}-convert.csv



