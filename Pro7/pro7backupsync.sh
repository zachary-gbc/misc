#!/bin/bash

processnumber=$(ps aux | grep -v grep | grep -ci "ProPresenter")
logdatetime=$(date +%F_%H:%M:%S)
host=$(hostname -s)
daybackup=$(date +%A)
lastbackupday="never"
skipbackup=0
skipsync=0
$logmessage=""

echo "$logdatetime - Backup & Sync Script Started"

if [ $processnumber == 0 ] || [ "$1" == "manual" ] 
then
  skipbackup=0
else
  echo "$logdatetime - Backup Skipped, ProPresenter Running"
  skipbackup=1
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

if [ "$lastbackupday" == "$daybackup" ] && [ $skipbackup == 0 ]
then
  if [ "$1" != "manual" ]
  then
    echo "$logdatetime - Backup Already Completed for Today"
    skipbackup=1
  fi
fi

if [ $skipbackup == 0 ]
then
  echo "$logdatetime - Running Backup Now for $daybackup";
  rm -rf ~/Sync/ProPresenter_Backups/$backupfolder/$daybackup/*

  for foldername in Configuration Downloads Libraries Playlists Presets Themes; do
    mkdir -p ~/Sync/ProPresenter_Backups/$backupfolder/$daybackup/$foldername/
    rsync -qrtu ~/Documents/ProPresenter/$foldername/ ~/Sync/ProPresenter_Backups/$backupfolder/$daybackup/$foldername/
  done 

  if [ $daybackup == "Monday" ]
  then
    mkdir -p ~/Sync/ProPresenter_Backups/$backupfolder/Media/
    rsync -qrtu --delete ~/Documents/ProPresenter/Media/ ~/Sync/ProPresenter_Backups/$backupfolder/Media/
  fi

  echo $daybackup > ~/Sync/ProPresenter_Backups/$backupfolder/lastbackupday.txt
  echo "$logdatetime - Backup Complete"
fi

# Sync Script
if [ $processnumber == 0 ] || [ "$1" == "manual" ]
then
  if [ "$daybackup" == "Sunday" ] && [ "$1" != "manual" ]
  then
    echo "$logdatetime - Sync Not Started, Not Automatic on Sunday"
    skipsync=1
  fi
else
  skipsync=1
fi

if [ $skipsync == 0 ]
then
  echo "Running Sync Now";
  rsync -qrtu --exclude="LibraryData" --exclude Old_Songs ~/Documents/ProPresenter/Libraries/ ~/Sync/ProPresenter_Shared_Content/Libraries/
  rsync -qrtu --exclude="LibraryData" --exclude Old_Songs ~/Sync/ProPresenter_Shared_Content/Libraries/ ~/Documents/ProPresenter/Libraries/
  rsync -qrtu ~/Documents/ProPresenter/Themes/ ~/Sync/ProPresenter_Shared_Content/Themes/
  rsync -qrtu ~/Sync/ProPresenter_Shared_Content/Themes/ ~/Documents/ProPresenter/Themes/
  rsync -qrtu ~/Library/Fonts/ ~/Sync/ProPresenter_Shared_Content/Fonts/
  rsync -qrtu ~/Sync/ProPresenter_Shared_Content/Fonts/ ~/Library/Fonts/
  echo "Sync Complete"
fi
