#!/bin/bash

logdatetime=$(date +%F_%H:%M:%S)
host=$(hostname -s)
currentday=$(date +%A)
lastbackupday="never"

echo "$logdatetime - Backup Script Started"

case $host in
  "Sanctuary-Media")
    backupfolder="Sanctuary"
    ;;
  "Youth-Room-Media")
    backupfolder="Youth_Room"
    ;;
  "Staff-Wing-Media")
    backupfolder="Staff_Wing"
    ;;
  "Zachary-Flight-Laptop")
    backupfolder="ZF_Laptop"
    ;;
  "ZacharyhtLaptop")
    backupfolder="ZF_Laptop"
    ;;
  *)
    backupfolder=""
    ;;
esac
lastbackupday=$(<~/Sync/ProPresenter_Backups/$backupfolder/lastbackupday.txt)

if [[ $lastbackupday == $currentday ]] && [[ $1 != "manual" ]]
then
    echo "$logdatetime - Backup Already Completed for Today"
    exit 1
fi

echo "$logdatetime - Running Backup Now for $currentday";
rm -rf ~/Sync/ProPresenter_Backups/$backupfolder/$currentday/*

for foldername in Configuration Downloads Libraries Playlists Presets Themes; do
  mkdir -p ~/Sync/ProPresenter_Backups/$backupfolder/$currentday/$foldername/
  rsync -qrtu ~/Documents/ProPresenter/$foldername/ ~/Sync/ProPresenter_Backups/$backupfolder/$currentday/$foldername/
done 

if [[ $currentday == "Monday" ]]
then
  mkdir -p ~/Sync/ProPresenter_Backups/$backupfolder/Media/
  rsync -qrtu --delete ~/Documents/ProPresenter/Media/ ~/Sync/ProPresenter_Backups/$backupfolder/Media/
fi

echo $currentday > ~/Sync/ProPresenter_Backups/$backupfolder/lastbackupday.txt
echo "$logdatetime - Backup Complete"
