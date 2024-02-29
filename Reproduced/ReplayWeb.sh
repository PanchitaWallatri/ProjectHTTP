#!/usr/bin/bash
data_file="/home/mahimahi/ParaForReplay.csv"

typeset -i Latest_task=$(cat lastReplayRun.txt) #get last task
echo "$Latest_task"

curr_task=$((Latest_task +1))
echo "$curr_task"

url=$(awk -v task="$curr_task" -F ',' 'NR == task {print $2}' "$data_file")
folder=$(echo "$url" | sed 's/\./_/g')
echo "$url"
echo "$folder"

Delay=$(awk -v task="$curr_task" -F ',' 'NR == task {print $3}' "$data_file")
Loss=$(awk -v task="$curr_task" -F ',' 'NR == task {print $4}' "$data_file")
BW=$(awk -v task="$curr_task" -F ',' 'NR == task {print $5}' "$data_file")
echo "$Delay $Loss $BW"

if [[ -z $url ]]; then
    echo "All task done"
    echo "$Latest_task" > lastReplayRun.txt
elif [[ $url == https://* || $url == http://* ]]; then
    full_url="$url"
else
    # Add "https://" to the beginning of the URL
    full_url="https://$url"
    export DISPLAY=:0.0
    mm-webreplay Record/"$folder" mm-delay $Delay mm-loss uplink $Loss mm-link ${BW}Mbps_trace ${BW}Mbps_trace  -- robot --variable HARFILENAME:$folder --variable ReplayWeb:$full_url /home/mahimahi/gethar.robot
    mv -v /home/mahimahi/${folder}.har /home/mahimahi/Replay/${folder}/${folder}${Delay},${Loss},${BW}.har
    echo "$curr_task" > lastReplayRun.txt
    echo "$full_url"

fi
