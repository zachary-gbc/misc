# Pro7 Backup and Sync Scripts
1. Ensure Sync is running on computer, root folder is ~/Sync, and correct folders are being syncronized locally
1. Copy pro7backup.sh, pro7sync.sh, and pro7scripts.sh to ~/Documents/Scripts folder
1. Open terminal and type: chmod +x ~/Documents/Scripts/pro7*.sh
1. Open System Settings, go to Privacy & Security, Full Disk Access
1. Click plus sign at the bottom and add in /bin/bash
1. Copy pro7scripts.plist to ~/Library/LaunchAgents
1. Update pro7scripts.plist paths in file (lines 8, 21, and 23)
1. Update minute based on schedule below:
  - Sanctuary Mac: 0 & 30
  - Youth Room Mac: 10 & 40
  - Staff Wing Mac: 15 & 45
  - Other Laptops: 20 & 50

### Reboot Computer after finishing steps above