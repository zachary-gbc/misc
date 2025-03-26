#!/bin/bash

# variables
obsfolder="/Users/username/Movies/GrandPrix"
outputfolder="/Users/username/Desktop/GrandPrixVideos/"
secondstosleep=2
secondstokeep=1
slowdownspeed=3
endvideolength=$(($secondstokeep * $slowdownspeed + 1))
pro7ipaddress="1.1.1.1"
pro7port="50001"
testing=false
iteration=1
x=0

cd $obsfolder
echo "Press Q to exit"

while true
do
  ((x++))
  if [ $testing = "true" ]; then echo "Starting Loop $x"; fi
  
  read -t 1 -n 1 userinput
  if [[ ! -z $userinput ]]
  then
    if [[ "$userinput" == "Q" ]] || [[ "$userinput" == "q" ]]; then echo "Exiting Script"; exit; fi
  fi

  for file in "$obsfolder"/*
  do
    if [ $testing = "true" ]; then echo "Current File: $file"; fi
    if [ ${file: -4} = ".mp4" ]
    then
      ((iteration++))
      if [ $testing = "true" ]; then echo "Currently on #$iteration"; fi
      sleep $secondstosleep

      videolength=1
      probelen=$(ffprobe -i "$file" -show_entries format=duration -v quiet -of csv="p=0")
      videolength=${probelen%.*}
      if [ $testing = "true" ]; then echo "Video Length is: $videolength"; fi

      if [ $videolength -gt $secondstokeep ]
      then
        videotrim=$((videolength - secondstokeep))
        if [ $videotrim -gt 60 ]
        then
          echo "Unable to trim videos longer than 60 seconds"
          cp $file $outputfolder$iteration-trimmed.mp4
      else
          ffmpeg -y -ss 00:00:$videotrim -i $file -c:v copy -c:a copy $outputfolder$iteration-trimmed.mp4
        fi
      else
        cp $file $outputfolder$iteration-trimmed.mp4
      fi
      mv $file $outputfolder$iteration-original.mp4
      ffmpeg -y -i $outputfolder$iteration-trimmed.mp4 -filter:v "setpts=$slowdownspeed*PTS" -an $outputfolder$iteration.mp4
      curl "http://$pro7ipaddress:$pro7port/v1/presentation/focused/next/trigger"
      open -a VLC "$outputfolder$iteration.mp4"
      sleep $endvideolength
      sleep 1
      curl "http://$pro7ipaddress:$pro7port/v1/presentation/focused/previous/trigger"
      echo "Finished #$iteration"
      echo $iteration > "${outputfolder}latest"
    fi
  done
done
