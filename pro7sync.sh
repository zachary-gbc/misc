#!/bin/bash

processnumber=$(ps aux | grep -v grep | grep -ci "ProPresenter")
if [ $processnumber != 0 ]
then
  exit 1
fi
host=$(hostname -s)
user=""

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
esac

lib_local="/Users/$user/Documents/ProPresenter/Libraries/"
lib_sync="/Users/$user/Sync/ProPresenter_Shared_Content/Libraries/"
thm_local="/Users/$user/Documents/ProPresenter/Themes/"
thm_sync="/Users/$user/Sync/ProPresenter_Shared_Content/Themes/"

if [ $user == "" ]
then
  echo "Unable to Run Due to Host Not Setup Correctly in Script"
  exit 1
fi

echo "Running Sync Now";
rsync -qrtu --exclude="LibraryData" $lib_local $lib_sync
rsync -qrtu --exclude="LibraryData" $lib_sync $lib_local
rsync -qrtu --exclude="LibraryData" $thm_local $thm_sync
rsync -qrtu --exclude="LibraryData" $thm_sync $thm_local
echo "Sync Complete"
# rsync -qrt --delete?  #unsure on how/where to add delete, need to test that
