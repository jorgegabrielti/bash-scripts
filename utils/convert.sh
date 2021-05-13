#!/bin/bash

grep -vi 'duration' report.csv \
| while read LINE; do

    DURATION="$(echo $LINE | cut -d',' -f7 | tr -d '"')"

    # Time obtained
    DAY=$(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '[[:digit:]]d' | tr -d '[:alpha:]')
    HOU=$(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '[[:digit:]]h' | tr -d '[:alpha:]')
    MIN=$(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '[[:digit:]]m' | tr -d '[:alpha:]')
    SEC=$(echo $LINE | cut -d',' -f7 | tr -d '"' | grep -Eo '[[:digit:]]s' | tr -d '[:alpha:]')

    if [ ! -z ${DAY} ]; then
      D=$(echo "${DAY}*86400" | bc)
      DURATION_CONVERT="${DURATION_CONVERT}+${D}"
    fi 

    if [ ! -z ${HOU} ]; then
      H=$(echo "${HOU}*3600" | bc)
      DURATION_CONVERT="${DURATION_CONVERT}+${H}"
    fi

    if [ ! -z ${MIN} ]; then
      M=$(echo "${MIN}*60" | bc)
      DURATION_CONVERT="${DURATION_CONVERT}+${M}"
    fi

    S=${SEC} 
    DURATION_CONVERT="${DURATION_CONVERT}+${S}"
    echo ${DURATION_CONVERT} | cut -d'+' -f2- | bc
    #echo ${LINE} | sed "s/$DURATION/${DURATION_CONVERT}/g"
    unset DURATION_CONVERT
done #| tee -a new.csv


#grep -vi 'duration' report.csv | while read LINE; do      DURATION=$(echo $LINE | cut -d',' -f7);      DURATION_CONVERTED=$(echo $LINE | cut -d',' -f7 | tr -s '[=h=]|[=m=][:blank:]' ':' | tr -d 's|"|\'\' | cut -d':' -f -3);      echo ${LINE} | sed "s/$DURATION/${DURATION_CONVERTED}/g";  done | tee -a new.csv
