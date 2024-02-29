#!/usr/bin/bash
data_file="/home/master-desktop04/Parameter/ParaForReplay3.csv"

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
Env=$(awk -v task="$curr_task" -F ',' 'NR == task {print $6}' "$data_file")
echo "$Delay $Loss $BW $Env"


if [[ -z $url ]]; then
    echo "All task done"
    echo "$Latest_task" > lastReplayRun.txt
    /usr/bin/crontrab -r
elif [[ $url == https://* || $url == http://* ]]; then
    full_url="$url"
else
    # Add "https://" to the beginning of the URL
    full_url="https://www.project.internal:442/$folder/$url"
    export DISPLAY=:0.0
    #mm-webreplay Record/"$folder"
    sshpass -p 123456789 ssh master-desktop06@192.168.11.6 <<EOF
	sudo tc qdisc change dev enp8s0 root netem delay ${Delay}ms loss ${Loss}% rate ${BW}mbps 
	tc qdisc show dev enp8s0
	exit
EOF
    /home/master-desktop04/.local/bin/robot --variable HARFILENAME:$folder --variable ReplayWeb:$full_url /home/master-desktop04/gethar.robot
    mv -v /home/master-desktop04/${folder}.har /home/master-desktop04/Replay/Env${Env}/${folder}_${Delay}_${Loss}_${BW}_Env${Env}_http2_$Latest_task.har
    #echo "$curr_task" > lastReplayRunEnv2.txt
    ./ReplayWebHttp3.sh
    echo "$full_url"

fi
