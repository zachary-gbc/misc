#!/bin/bash

processnumber=$(ps aux | grep -v grep | grep -ci "ProPresenter")
logdatetime=$(date +%F_%H:%M:%S)
host=$(hostname -s)
currentday=$(date +%A)

echo "$logdatetime - Sync Script Started"

if [[ $currentday == "Sunday" ]] && [[ $1 != "manual" ]]
then
  echo "$logdatetime - Sync Skipped, Not Automatic on Sunday"
  exit 1
fi

echo "$logdatetime - Running Sync Now";
rsync -qrtu --exclude="LibraryData" --exclude Old_Songs ~/Documents/ProPresenter/Libraries/ ~/Sync/ProPresenter_Shared_Content/Libraries/
rsync -qrtu --exclude="LibraryData" --exclude Old_Songs ~/Sync/ProPresenter_Shared_Content/Libraries/ ~/Documents/ProPresenter/Libraries/
rsync -qrtu ~/Documents/ProPresenter/Themes/ ~/Sync/ProPresenter_Shared_Content/Themes/
rsync -qrtu ~/Sync/ProPresenter_Shared_Content/Themes/ ~/Documents/ProPresenter/Themes/
rsync -qrtu ~/Library/Fonts/ ~/Sync/ProPresenter_Shared_Content/Fonts/
rsync -qrtu ~/Sync/ProPresenter_Shared_Content/Fonts/ ~/Library/Fonts/
echo "$logdatetime - Sync Complete"
