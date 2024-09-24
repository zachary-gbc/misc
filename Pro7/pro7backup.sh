#!/bin/bash

# 1 = manual
# 2 = backup folder

logdatetime=$(date +%F_%H:%M:%S)
currentday=$(date +%A)
backupfolder=$2

echo "$logdatetime - Running Backup for $currentday";
rm -rf ~/Sync/ProPresenter_Backups/$backupfolder/$currentday/*

for foldername in Configuration Downloads Libraries Playlists Presets Themes; do
  mkdir -p ~/Sync/ProPresenter_Backups/$backupfolder/$currentday/$foldername/
  rsync -qrtu ~/Documents/ProPresenter/$foldername/ ~/Sync/ProPresenter_Backups/$backupfolder/$currentday/$foldername/
done 

if [[ $currentday == "Tuesday" ]]
then
  mkdir -p ~/Sync/ProPresenter_Backups/$backupfolder/Media/
  rsync -qrtu --delete ~/Documents/ProPresenter/Media/ ~/Sync/ProPresenter_Backups/$backupfolder/Media/
fi

echo $currentday > ~/Sync/ProPresenter_Backups/$backupfolder/lastbackupday.txt
echo "$logdatetime - Backup Complete"
