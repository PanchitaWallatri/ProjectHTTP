#!/usr/bin/bash

run_top() {
    /usr/bin/top -b -n 1 -d 0.01 -u master-desktop04 | grep chrome > /home/master-desktop04/top.txt &
    top_pid=$!
}

replace_file() {
    current_datetime=$(date +"%Y%m%d_%H%M%S")
    cat /home/master-desktop04/top.txt | tr -s ' ' | sed 's/^ //g' | tr ' ' ',' > /home/master-desktop04/top.csv
    mv -v /home/master-desktop04/top.csv /home/master-desktop04/Resource/Env3/top_${counter}_env3_${current_datetime}.csv
}

process_name="chrome"
counter=0
while [ $counter -lt 3 ]; do
    while true; do
        if pgrep -x $process_name > /dev/null; then
            run_top
            break
        else
            sleep 0.001
        fi
    done

    while true; do
        if pgrep -x $process_name > /dev/null; then
            sleep 0.001
        else
            kill $top_pid
            replace_file
            ((counter++))
            break  # Break out of the inner loop to allow the outer loop to continue
        fi
    done
done

