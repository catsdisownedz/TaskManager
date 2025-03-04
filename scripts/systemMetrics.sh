#!/usr/bin/env bash

# ./static_json.sh
echo "entered the systemMetrics.sh"

function get_cpu_performance(){

    (
        while :; do
        echo "# $(top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print "CPU usage: " $1 " %"} ')" #for the text
       
        top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print $1}'
        sleep 3
        done
    ) | zenity --progress --title="CPU Performance" --width=500

    alert_check=$( top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print $1}' |tr -d '[:space:]') 
    if checking_alerts $alert_check "High CPU Usage" "CPU usage is too high $alert_check"; then 
        exit 
    fi
    
}

function get_cpu_temp(){
    (while :; do
   
    echo "# $(sensors | grep 'Tctl:' | cut -d ':' -f2 |awk '{print "current temp: " $1}')"
    sensors | grep 'Tctl:' | cut -d ':' -f2 |awk '{gsub(/[^0-9.]/, ""); print}'
    sleep 3 
    done ) | zenity --progress --title="CPU Temperature" --width=500
   
    alert_check=$(sensors | grep 'Tctl:' | cut -d ':' -f2 |awk '{gsub(/[^0-9.]/, ""); print}') 
    if checking_alerts $alert_check "High CPU Temperature" "CPU Temperature is too high $alert_check"; then 
        exit 
    fi


}
# function display_progress_bar(){
#     title_name="$1"
#     text_command="$2"
#     progress_bar_command="$3"
#     (while :; do
#     echo "# $(eval $text_command)"
#     eval $progress_bar_command
#     sleep 3 
#     done ) | zenity --progress --title="$titlename" --width=500
# }


function get_disk_usage(){
    # df -h | column -t 
    df -h --total | head -n 1 
    df -h --total |tail -n 1
    df -h --total | awk '/^total/ {print "Used Disk: " $3 " / " $2}'
    alert_check=$(df -h --total | awk '/^total/ {print ($3/$2)*100}')
    if checking_alerts $alert_check "High Disk Usage" "Disk usage is too high:  $alert_check%" $alert_check; then 
        exit 
    fi


}

#hard disk's health
function get_smart_status(){
    sudo smartctl --all /dev/nvme0 | awk '/=== START OF SMART DATA SECTION ===/{exit} {print}'
    # smartctl --all /dev/nvme0
    # smartctl --health /ded/nvme0
    # smartctl --all 
}


function get_memory_usage(){
    free -h #| column -t
    free -h | awk '/^Mem:/ {print "Used RAM: "$3 " / " $2}'
    alert_check=$(free -h | awk '/^Mem:/ {print ($3/$2)*100}') 
    if checking_alerts $alert_check "High RAM Usage" "RAM usage is too high $alert_check"; then 
        exit 
    fi

}

function get_gpu_info() {
   
    
   if lspci | grep -i "NVIDIA" > /dev/null; then
        nvidia-smi
    elif lspci | grep -i "AMD" > /dev/null; then
        # radeontop -i | grep "GPU" | awk '{print $3}'
        sensors | grep "edge" | awk '{print "GPU temp: " $2}'
        
    elif lspci | grep -i "Intel" > /dev/null; then
        intel_gpu_top
    else
        echo "No supported GPU found."
fi   
    
}


function get_network_stats(){
    nstat | awk '{printf "%-25s %-10s %-10s\n", $1, $2, $3}'
   
}

function get_system_load(){
    uptime
}

function display_data(){
    heading="$1"
    data="$2"
    zenity --question --no-wrap --text="<b>$heading</b>\n\n$data" --title="$heading" \
    --width=500 --height=300 \
    --ok-label="OK" --cancel-label="Back" 

    if [ $? -eq 0 ] ; then
        exit_page
    else
        selection_check
    fi  
}

function checking_alerts(){
    alert_check=$1
    if (( $(echo "$alert_check > 80" | bc -l) )); then
            zenity --warning --title="$2" --text="$3" --width=300 
            return 1
    fi
}

function exit_page(){
    zenity --question \
  --title="Exit Page" \
  --text="<b>Thanks BAAAYIE</b>" \
  --width=500 \
  --cancel-label="Generate Report" 
  

   if [ $? -eq 0 ] ; then
        exit
    else
        
        exit
    fi  
}

function choose_resource() {
   
    selection=$(zenity --list \
        --title="Choose a Resource" \
        --text="Select the resource you want to check:" \
        --column="Number" --column="Resource" \
        1 "CPU Performance" \
        2 "CPU Temperature" \
        3 "Disk Usage" \
        4 "SMART Status" \
        5 "Memory Consumption" \
        6 "GPU Utilization and Health" \
        7 "Network Interface Statistics" \
        8 "System Load Metrics"  --width=500 --height=300)

    echo "$selection"
}

function main(){
    zenity --info --title="Task Manager" \
    --text=" Welcome to Task Manager by\
 <b><span foreground='#ADD8E6' >m</span><span foreground='orange' font='12'>r</span><span foreground='pink' font='12'>z</span></b> :) \\ 
    \n \n <span foreground='#90EE90'>click oki! to continue</span>" \
    --ok-label="oki!" \
    --width=500 

    selection_check

}

function selection_check() {
    resource=$(choose_resource)
    if [ -z "$resource" ]; then
        zenity --error --text="No selection made!"
        exit 1
    fi
    systemMetrics "$resource"
}

function systemMetrics() {
    resource=$1
    case $resource in
        "1")
            data=$(get_cpu_performance)          
            ;;
        "2")
            data=$(get_cpu_temp)
            ;;
        "3")
            data=$(get_disk_usage)
            display_data "Disk Usage" "$data"
            ;;
        "4")
            data=$(get_smart_status)
            display_data "SMART Status" "$data"
            ;;
        "5")
            data=$(get_memory_usage)
            display_data "Memory Consumption" "$data"
            ;;
        "6")
            data=$(get_gpu_info)
            display_data "GPU Utilization and Health" "$data"
            ;;
        "7")
            data=$(get_network_stats)
            display_data "Network Interface Statistics" "$data"
            ;;
        "8") 
            data=$(get_system_load)
            display_data "System Load Metrics" "$data"
            ;;
        *)
            zenity --error --text="Invalid input!"
            ;;
    esac
}

function execution_source_check(){
    if [ $flag -eq 0  ]; then
        top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print $1}' |tr -d '[:space:]'
        exit
    fi

}

# Ensure the main logic runs only if the script is executed directly
flag=0
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    flag=1
    main
fi
