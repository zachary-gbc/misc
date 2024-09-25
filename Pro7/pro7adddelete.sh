#!/bin/bash

pathtoremove="/Users/$USER/"
numbertoremove=${#pathtoremove}

read -p "Please add file or folder to be deleted: " item

if [[ ${item:$numbertoremove:14} == "Library/Fonts/" ]]
then
  echo ${item:$numbertoremove+14} >> ~/Sync/ProPresenter_Shared_Content/Deletes/fonts.txt
  echo "Added Font: ${item:$numbertoremove+14}"
fi

if [[ ${item:$numbertoremove:30} == "Documents/ProPresenter/Themes/" ]]
then
  echo ${item:$numbertoremove+30} >> ~/Sync/ProPresenter_Shared_Content/Deletes/themes.txt
  echo "Added Theme Item: ${item:$numbertoremove+30}"
fi

if [[ ${item:$numbertoremove:33} == "Documents/ProPresenter/Libraries/" ]]
then
  echo ${item:$numbertoremove+33} >> ~/Sync/ProPresenter_Shared_Content/Deletes/libraries.txt
  echo "Added Library Item: ${item:$numbertoremove+33}"
fi
