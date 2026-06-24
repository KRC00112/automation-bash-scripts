#!/bin/bash

file_arr=($(ls -I "*.sh"))
directory_arr=()

function check_if_item_exists(){
    a=("$@")
    ((last_idx=${#a[@]} - 1))
    b=${a[last_idx]}
    unset a[last_idx]

    for i in "${a[@]}"
    do
        if [ $b == $i ]
        then 
            return 0
        fi
    done
    return 1
}


for file in ${file_arr[@]}
do
 ext=$( echo $file | awk -F'.' '{print $NF}' )
 if ! check_if_item_exists "${directory_arr[@]}" "$ext" 
 then
    directory_arr+=($ext) 
 fi
done

for dir in ${directory_arr[@]}
do
    mkdir "$dir"
done

for file in ${file_arr[@]}
do
 for dir in ${directory_arr[@]}
 do
  ext=$( echo $file | awk -F'.' '{print $NF}' )
  if [ $ext == $dir ]
  then
   mv $file $dir
  fi
 done
done























