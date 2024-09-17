#!/bin/bash

processnumber=$(ps aux | grep -v grep | grep -ci "ProPresenter")
host=$(hostname -s)
logdatetime=$(date +%F_%H:%M:%S)
daybackup=$(date +%A)

if [ $processnumber == 0 ] || [ "$1" == "manualsync" ]
then
  if [ "$daybackup" == "Sunday" ] && [ "$1" != "manualsync" ]
  then
    echo "$logdatetime - Sync Script Not Started, Not Automatic on Sunday"
    exit 1
  else
    echo "$logdatetime - Sync Script Started"
  fi
else
  echo "$logdatetime - Sync Script Not Started, ProPresenter Running"
  exit 1
fi

echo "Running Sync Now";
rsync -qrtu --exclude="LibraryData" --exclude Old_Songs ~/Documents/ProPresenter/Libraries/ ~/Sync/ProPresenter_Shared_Content/Libraries/
rsync -qrtu --exclude="LibraryData" --exclude Old_Songs ~/Sync/ProPresenter_Shared_Content/Libraries/ ~/Documents/ProPresenter/Libraries/
rsync -qrtu ~/Documents/ProPresenter/Themes/ ~/Sync/ProPresenter_Shared_Content/Themes/
rsync -qrtu ~/Sync/ProPresenter_Shared_Content/Themes/ ~/Documents/ProPresenter/Themes/
rsync -qrtu ~/Library/Fonts/ ~/Sync/ProPresenter_Shared_Content/Fonts/
rsync -qrtu ~/Sync/ProPresenter_Shared_Content/Fonts/ ~/Library/Fonts/
echo "Sync Complete"
