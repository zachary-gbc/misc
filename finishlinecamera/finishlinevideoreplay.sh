#!/bin/bash

# variables
outputfolder="/Users/username/Desktop/GrandPrixVideos/"
secondstokeep=5
slowdownspeed=2
pro7ipaddress="1.1.1.1"
pro7port="50001"
testing=false

echo "Iteration to Replay (leave blank for last video):"
read increment
echo "Seconds to Keep (leave blank for default of 5 seconds):"
read seconds
echo "Slow Down Speed (leave blank for default of 2 (2 is half speed)):"
read slowdown

cd $outputfolder
if [[ "$increment" == "" ]]
then
  videotoreplay=$(<latest)
else
  videotoreplay=$increment
fi
if [[ "$seconds" != "" ]]
then
  secondstokeep=$seconds
fi
if [[ "$slowdown" != "" ]]
then
  slowdownspeed=$slowdown
fi

endvideolength=$(($secondstokeep * $slowdownspeed))
file=$increment-original.mp4
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
    ffmpeg -y -ss 00:00:$videotrim -i $file -c:v copy -c:a copy $increment-trimmed-replay.mp4
  fi
else
  cp $file $increment-trimmed-replay.mp4
fi
ffmpeg -y -i $increment-trimmed-replay.mp4 -filter:v "setpts=$slowdownspeed*PTS" -an $increment-replay.mp4
curl "http://$pro7ipaddress:$pro7port/v1/presentation/focused/next/trigger"
open -a VLC "$outputfolder$increment-replay.mp4"
sleep $endvideolength
sleep 1
curl "http://$pro7ipaddress:$pro7port/v1/presentation/focused/previous/trigger"
