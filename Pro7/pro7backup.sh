#!/bin/bash

processnumber=$(ps aux | grep -v grep | grep -ci "ProPresenter")
logdatetime=$(date +%F_%H:%M:%S)
host=$(hostname -s)
daybackup=$(date +%A)
lastbackupday="never"

if [ $processnumber == 0 ] || [ "$1" == "manualbackup" ] 
then
  echo "$logdatetime - Backup Script Started"
else
  echo "$logdatetime - Backup Script Not Started, ProPresenter Running"
  exit 1
fi

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

if [ "$daybackup" == "" ]
then
  echo "$logdatetime - Day Not Set"
  exit 1
fi

if [ "$lastbackupday" == "$daybackup" ]
then
  if [ "$manual" != "manualbackupnow" ]
  then
    echo "$logdatetime - Backup Already Completed for Today"
    exit 1
  fi
fi

echo "$logdatetime - Running Backup Now for $daybackup";
rm -rf ~/Sync/ProPresenter_Backups/$backupfolder/$daybackup/*

for foldername in Configuration Downloads Libraries Playlists Presets Themes; do
  mkdir -p ~/Sync/ProPresenter_Backups/$backupfolder/$daybackup/$foldername/
  rsync -qrtu ~/Documents/ProPresenter/$foldername/ ~/Sync/ProPresenter_Backups/$backupfolder/$daybackup/$foldername/
done 

if [ $daybackup == "Monday" ]
then
  mkdir -p ~/Sync/ProPresenter_Backups/$backupfolder/$daybackup/Media/
  rsync -qrtu ~/Documents/ProPresenter/Media/ ~/Sync/ProPresenter_Backups/$backupfolder/$daybackup/Media/
fi

echo $daybackup > ~/Sync/ProPresenter_Backups/$backupfolder/lastbackupday.txt
echo "$logdatetime - Backup Complete"
