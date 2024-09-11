#!/bin/bash

processnumber=$(ps aux | grep -v grep | grep -ci "ProPresenter")
if [ $processnumber != 0 ]
then
  exit 1
fi
manual=$1
host=$(hostname -s)
daybackup=$(date +%A)
backupfolder="temp"
user=""
lastbackupday="never"
logdatetime=$(date -I)
echo "$date - Backup Script Started"

case $host in
  "Sanctuary-Media")
    user="media"
    backupfolder="Sanctuary"
    ;;
  "Youth-Room-Media")
    user="youthroommac"
    backupfolder="Youth_Room"
    ;;
  "Staff-Wing-Media")
    user="Media"
    backupfolder="Staff_Wing"
    ;;
  "Zachary-Flight-Laptop")
    user="techd"
    backupfolder="ZF_Laptop"
    ;;
  "ZacharyhtLaptop")
    user="techd"
    backupfolder="ZF_Laptop"
    ;;
  *)
    user=""
    backupfolder=""
    ;;
esac
lastbackupday=$(</Users/$user/Sync/ProPresenter_Backups/$backupfolder/lastbackupday.txt)

if [ $user == "" ]
then
  echo "$date - Host Not Setup Correctly in Script"
  exit 1
fi

if [ "$daybackup" == "" ]
then
  echo "$date - Day Not Set"
  exit 1
fi

if [ "$lastbackupday" == "$daybackup" ]
then
  if [ "$manual" != "manualbackupnow" ]
  then
    echo "$date - Backup Alreday Completed for Today"
    exit 1
  fi
fi

echo "$date - Running Backup Now for $daybackup";
rm -rf /Users/$user/Sync/ProPresenter_Backups/$backupfolder/$daybackup/*

for foldername in Configuration Downloads Libraries Playlists Presets Themes; do
  mkdir -p /Users/$user/Sync/ProPresenter_Backups/$backupfolder/$daybackup/$foldername/
  rsync -qrtu /Users/$user/Documents/ProPresenter/$foldername/ /Users/$user/Sync/ProPresenter_Backups/$backupfolder/$daybackup/$foldername/
done 

if [ $daybackup == "Monday" ]
then
  mkdir -p /Users/$user/Sync/ProPresenter_Backups/$backupfolder/$daybackup/Media/
  rsync -qrtu /Users/$user/Documents/ProPresenter/Media/ /Users/$user/Sync/ProPresenter_Backups/$backupfolder/$daybackup/Media/
fi

echo $daybackup > /Users/$user/Sync/ProPresenter_Backups/$backupfolder/lastbackupday.txt
echo "$date - Backup Complete"
