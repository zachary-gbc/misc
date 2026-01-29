#!/bin/bash

# First Create SSH Key: ssh-keygen -t rsa
# Copy Key to Server: ssh-copy-id pi@10.63.0.100 (input password when asked)
# Script should run daily: 30 20 * * *

# On remote system schedule cron: find /home/pi/companionbackups -type f -mtime +30 -delete

today=$(date +%Y-%m-%d)
filename="/home/backups/backup-CompanionPi_$today.companionconfig"

if [[ -f "$filename" ]]
then
  scp $filename pi@10.63.0.100:/home/pi/companionbackups/
fi
