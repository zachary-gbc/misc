#!/bin/bash

logdatetime=$(date +%F_%H:%M:%S)

echo "$logdatetime - Running Deletes Now";

while read line; do
  if [[ $line != "" ]]
  then
    if [[ ${line:0:1} != "#" ]]
    then
      rm -rf ~/Documents/ProPresenter/$line
      rm -rf ~/Sync/ProPresenter_Shared_Content/$line
    fi
  fi
done <~/Sync/ProPresenter_Shared_Content/deletes.txt

echo "$logdatetime - Deletes Complete"
