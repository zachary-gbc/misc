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

lib_local="~/Documents/ProPresenter/Libraries/"
lib_sync="~/Sync/ProPresenter_Shared_Content/Libraries/"
thm_local="~/Documents/ProPresenter/Themes/"
thm_sync="~/Sync/ProPresenter_Shared_Content/Themes/"
font_local="~/Library/Fonts/"
font_sync="~/Sync/ProPresenter_Shared_Content/Fonts/"

echo "Running Sync Now";
rsync -qrtu --exclude="LibraryData" --exclude Old_Songs $lib_local $lib_sync
rsync -qrtu --exclude="LibraryData" --exclude Old_Songs $lib_sync $lib_local
rsync -qrtu $thm_local $thm_sync
rsync -qrtu $thm_sync $thm_local
rsync -qrtu $font_local $font_sync
rsync -qrtu $font_sync $font_local
echo "Sync Complete"
