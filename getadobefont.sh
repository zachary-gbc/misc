#!/bin/bash

# Location here: https://youtu.be/yPvsbHqPIdQ
# mdls command to use: mdls -n com_apple_ats_name_full -n kMDItemFSName <filename>

cd ~/Library/Application\ Support/Adobe/CoreSync/plugins/livetype
rm -f ~/Documents/Scripts/Fonts/*

shopt -s nullglob dotglob
mainfolderlist=(*)
allfiles=()
allnames=()
z=0

for ((x=0; x<${#mainfolderlist[@]}; x++))
do
  if [ ${mainfolderlist[$x]} != ".DS_Store" ]
  then
    if [[ -d ~/Library/Application\ Support/Adobe/CoreSync/plugins/livetype/${mainfolderlist[$x]} ]]
    then
      cd ~/Library/Application\ Support/Adobe/CoreSync/plugins/livetype/${mainfolderlist[$x]}
      
      shopt -s nullglob dotglob
      subfolderlist=(*)
      for ((y=0; y<${#subfolderlist[@]}; y++))
      do
        file=${subfolderlist[$y]}
        if [[ ${file: -4} == ".otf" ]]
        then
          cp ~/Library/Application\ Support/Adobe/CoreSync/plugins/livetype/${mainfolderlist[$x]}/$file ~/Documents/Scripts/Fonts/${file:1}
        fi
      done
    fi
  fi
done

cd ~/Documents/Scripts/Fonts
shopt -s nullglob dotglob
newlist=(*)
for ((y=0; y<${#newlist[@]}; y++))
do
  fullname=$(mdls -n com_apple_ats_name_full ${newlist[$y]})
  filename=$(mdls -n kMDItemFSName ${newlist[$y]})

  fullname=${fullname//$'\n'/}
  full=${fullname#*'='}
  full=${full:7}
  full=${full%'"'*}
  file=${filename#*'"'}
  file=${file%'"'*}

  if [[ ${file: -4} == ".otf" ]]
  then
    allfiles[$z]="$file"
    allnames[$z]=$full
    ((z++))
  fi
done


if [ ${#allfiles[@]} == 0 ]
then
  echo "No Fonts"
else
  echo "All Fonts:"
  for ((x=0; x<$z; x++))
  do
    newfilename="${allfiles[$x]}                "
    echo "${newfilename:0:9} - ${allnames[$x]}"
  done
fi

echo "Unable to copy file, please move manually"
