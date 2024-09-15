#!/bin/bash

processnumber=$(ps aux | grep -v grep | grep -ci "ProPresenter")
logdatetime=$(date +%F_%H:%M:%S)
host=$(hostname -s)
daybackup=$(date +%A)
lastbackupday="never"

if [ $processnumber == 0 ] || [ $1 == "manualbackup" ] 
then
  echo "$logdatetime - Backup Script Started"
else
  echo "$logdatetime - Backup Script Not Started, ProPresenter Running"
  exit 1
fi

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
  echo "$logdatetime - Host Not Setup Correctly in Script"
  exit 1
fi

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
echo "$logdatetime - Backup Complete"
