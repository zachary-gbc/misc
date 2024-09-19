#!/bin/bash

logdatetime=$(date +%F_%H:%M:%S)
echo "$logdatetime - Pro7 Scripts Started"

processnumber=$(ps aux | grep -v grep | grep -ci "ProPresenter")
manual=$1
runbackup="false"
runsync="false"
manualbackup=""
manualsync=""

if [[ $processnumber == 0 ]]
then
  runbackup="true"
  runsync="true"
fi

if [[ $1 == "manualbackup" ]] || [[ $1 == "manual" ]]
then
  runbackup="true"
  manualbackup="manual"
fi

if [[ $1 == "manualsync" ]] || [[ $1 == "manual" ]]
then
  runsync="true"
  manualsync="manual"
fi

if [[ $runbackup == "true" ]]
then
  echo "bash ~/Documents/Scripts/pro7backup.sh $manualbackup"
fi

if [[ $runsync == "true" ]]
then
  echo "bash ~/Documents/Scripts/pro7sync.sh $manualsync"
fi
