#!/usr/bin/bash
data_file="RecordURL.csv"

typeset -i Latest_task=$(cat lastRun.txt) #get last task
echo "$Latest_task"

curr_task=$((Latest_task +1))
echo "$curr_task"

url=$(awk -v task="$curr_task" -F ',' 'NR == task {print $2}' "$data_file")
folder=$(echo "$url" | sed 's/\./_/g')
echo "$url"
echo "$folder"
if [[ -z $url ]]; then
    echo "All task done"
    echo "$Latest_task" > lastRun.txt
elif [[ $url == https://* || $url == http://* ]]; then
    full_url="$url"
else
    # Add "https://" to the beginning of the URL
    full_url="https://$url"
    mm-webrecord Record/"$folder" robot --variable RecordWeb:$full_url RecordWeb.robot 
    echo "$curr_task" > lastRun.txt
    echo "$full_url"
fi


