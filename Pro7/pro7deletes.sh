#!/bin/bash

logdatetime=$(date +%F_%H:%M:%S)

echo "$logdatetime - Running Deletes Now";

while read line; do
  if [[ $line != "" ]]
  then
    if [[ ${line:0:1} != "#" ]]
    then
      local_item="${HOME}/Library/Fonts/$line"
      sync_item="${HOME}/Sync/ProPresenter_Shared_Content/Fonts/$line"
      rm -rf "$local_item"
      rm -rf "$sync_item"
      echo "Removed: $line"
    fi
  fi
done <~/Sync/ProPresenter_Shared_Content/Deletes/fonts.txt

while read line; do
  if [[ $line != "" ]]
  then
    if [[ ${line:0:1} != "#" ]]
    then
      local_item="${HOME}/Documents/ProPresenter/Themes/$line"
      sync_item="${HOME}/Sync/ProPresenter_Shared_Content/Themes/$line"
      rm -rf "$local_item"
      rm -rf "$sync_item"
      echo "Removed: $line"
    fi
  fi
done <~/Sync/ProPresenter_Shared_Content/Deletes/themes.txt

while read line; do
  if [[ $line != "" ]]
  then
    if [[ ${line:0:1} != "#" ]]
    then
      local_item="${HOME}/Documents/ProPresenter/Libraries/$line"
      sync_item="${HOME}/Sync/ProPresenter_Shared_Content/Libraries/$line"
      rm -rf "$local_item"
      rm -rf "$sync_item"
      echo "Removed: $line"
    fi
  fi
done <~/Sync/ProPresenter_Shared_Content/Deletes/libraries.txt

echo "$logdatetime - Deletes Complete"
