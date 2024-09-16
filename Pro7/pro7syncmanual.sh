#!/bin/bash

logdatetime=$(date +%F_%H:%M:%S)
echo "$logdatetime - Manual Sync Script Started"

exit 1

bash ~/Documents/Scripts/pro7sync.sh manualsync
