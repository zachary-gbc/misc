#!/bin/bash

# variables
obsfile="/Users/username/Movies/GrandPrix/replay.mp4"
outputfolder="/Users/username/Desktop/GrandPrixVideos"
companionip="1.1.1.1:8000"
companionnotreadybutton="61/1/3"
companionreadybutton="61/1/4"
secondstokeep=5
slowdownspeed=5.0
testing=false
iteration=1

echo "Press Q to exit"

while true
do
  if [ $testing = "true" ]; then echo "Starting Loop $x"; ((x++)); fi
  
  read -t 1 -n 1 userinput
  if [[ ! -z $userinput ]]
  then
    if [[ "$userinput" == "Q" ]] || [[ "$userinput" == "q" ]]; then echo "Exiting Script"; exit; fi
  fi

  if [[ -f "$obsfile" ]]
  then
    curl -X POST https://$companionip/api/location/$companionnotreadybutton/press
    sleep 1
    videolength=1
    probelen=$(ffprobe -i "$obsfile" -show_entries format=duration -v quiet -of csv="p=0")
    videolength=${probelen%.*}
    if [ $testing = "true" ]; then echo "Video Length is: $videolength"; fi

    if [ $videolength -gt $secondstokeep ]
    then
      videotrim=$((videolength - secondstokeep))
      if [ $videotrim -gt 60 ]
      then
        echo "Unable to trim videos longer than 60 seconds"
      else
        ffmpeg -y -ss 00:00:$videotrim -i $obsfile -c:v copy -c:a copy $outputfolder/last.mp4
      fi
    else
      cp $obsfile $outputfolder/last.mp4
    fi
    cp $outputfolder/last.mp4 $outputfolder/$iteration-trimmed.mp4

    mv $obsfile $outputfolder/$iteration-original.mp4
    ffmpeg -y -i $outputfolder/last.mp4 -filter:v "setpts=$slowdownspeed*PTS" -an $outputfolder/lastslow.mp4
    curl -X POST https://$companionip/api/location/$companionreadybutton/press

    if [ $testing = "true" ]; then echo "Finished #$iteration"; fi
    echo $iteration > "${outputfolder}latest"
    ((iteration++))
  fi
  sleep 2
done
