#!/bin/bash

# variables
outputfolder="/Users/username/Desktop/GrandPrixVideos/"
secondstokeep=1
slowdownspeed=3
videotoreplay=$(<latest)
pro7ipaddress="1.1.1.1"
pro7port="50001"
testing=false

cd $outputfolder

echo "Just Replay? (y for just replay)"
read justreplay
if [[ "$justreplay" != "y" ]] && [[ "$justreplay" != "Y" ]]
then
  echo "Iteration to Replay (leave blank for last video):"
  read iteration
  echo "Seconds to Keep (leave blank for default of 1 second):"
  read seconds
  echo "Slow Down Speed (leave blank for default of 3 (2 is half speed)):"
  read slowdown
  if [[ "$iteration" != "" ]]
  then
    videotoreplay=$iteration
  fi
  if [[ "$seconds" != "" ]]
  then
    secondstokeep=$seconds
  fi
  if [[ "$slowdown" != "" ]]
  then
    slowdownspeed=$slowdown
  fi

  file=$videotoreplay-original.mp4
  if [ $testing = "true" ]; then echo "Starting $videotoreplay"; fi

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
  else
      ffmpeg -y -ss 00:00:$videotrim -i $file -c:v copy -c:a copy $videotoreplay-trimmed-replay.mp4
    fi
  else
    cp $file $videotoreplay-trimmed-replay.mp4
  fi
  ffmpeg -y -i $videotoreplay-trimmed-replay.mp4 -filter:v "setpts=$slowdownspeed*PTS" -an $videotoreplay-replay.mp4
else
  cp $videotoreplay.mp4 $videotoreplay-replay.mp4
fi

endvideolength=$(($secondstokeep * $slowdownspeed + 1))
curl "http://$pro7ipaddress:$pro7port/v1/presentation/focused/next/trigger"
open -a VLC "$outputfolder$videotoreplay-replay.mp4"
sleep $endvideolength
sleep 1
curl "http://$pro7ipaddress:$pro7port/v1/presentation/focused/previous/trigger"
