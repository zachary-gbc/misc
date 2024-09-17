#!/bin/bash

# Location here: https://youtu.be/yPvsbHqPIdQ
# mdls command to use: mdls -n com_apple_ats_name_full -n kMDItemFSName <filename>

cd ~/Library/Application\ Support/Adobe/CoreSync/plugins/livetype

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
        fullname=$(mdls -n com_apple_ats_name_full ${subfolderlist[$y]})
        filename=$(mdls -n kMDItemFSName ${subfolderlist[$y]})

        full=${fullname#*'='}
        full=${full%'"'*}
        file=${filename#*'"'}
        file=${file%'"'*}

        allfiles[$z]="${mainfolderlist[$x]}/$file"
        allnames[$z]=$full
        ((z++))
      done
    fi
  fi
done

if [ ${#allfiles[@]} == 0 ]
then
  echo "No Fonts"
else
  echo "All Fonts:"
  for ((x=0; x<$z; x++))
  do
    echo "$z = ${allfiles[$x]} - ${allnames[$x]}"
  done
fi

echo "Unable to copy file, please move manually"
