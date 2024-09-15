#!/bin/bash

processnumber=$(ps aux | grep -v grep | grep -ci "ProPresenter")
host=$(hostname -s)
logdatetime=$(date +%F_%H:%M:%S)
daybackup=$(date +%A)

if [ $processnumber == 0 ] || [ "$1" == "manualsync" ]
then
  if [ $daybackup == "Sunday" ] && [ "$1" != "manualsync" ]
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

case $host in
  "Sanctuary-Media")
    user="media"
    ;;
  "Youth-Room-Media")
    user="youthroommac"
    ;;
  "Staff-Wing-Media")
    user="Media"
    ;;
  "Zachary-Flight-Laptop")
    user="techd"
    ;;
  "ZacharyhtLaptop")
    user="techd"
    ;;
  *)
    user=""
    ;;
esac

if [ "$user" == "" ]
then
  echo "$logdatetime - Host Not Setup Correctly in Script"
  exit 1
fi

lib_local="/Users/$user/Documents/ProPresenter/Libraries/"
lib_sync="/Users/$user/Sync/ProPresenter_Shared_Content/Libraries/"
thm_local="/Users/$user/Documents/ProPresenter/Themes/"
thm_sync="/Users/$user/Sync/ProPresenter_Shared_Content/Themes/"
font_local="/Users/$user/Library/Fonts/"
font_sync="/Users/$user/Sync/ProPresenter_Shared_Content/Fonts/"

echo "Running Sync Now";
rsync -qrtu --exclude="LibraryData" --exclude Old_Songs $lib_local $lib_sync
rsync -qrtu --exclude="LibraryData" --exclude Old_Songs $lib_sync $lib_local
rsync -qrtu $thm_local $thm_sync
rsync -qrtu $thm_sync $thm_local
rsync -qrtu $font_local $font_sync
rsync -qrtu $font_sync $font_local
echo "Sync Complete"
# rsync -qrt --delete?  #unsure on how/where to add delete, need to test that
