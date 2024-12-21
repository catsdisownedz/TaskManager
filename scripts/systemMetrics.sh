#!/usr/bin/env bash


function get_cpu_performance(){

    execution_source_check
#     text_command="top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print \"CPU usage: \" \$1 \" %\"}'"
# progress_bar_command="top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print \$1}' | tr -d '[:space:]'"

#     # text_command="top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print "CPU usage: " $1 " %"} ' "
#     # progress_bar_command="top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print $1}' |tr -d '[:space:]'"

#     display_progress_bar "CPU Performance" $text_command $progress_bar_command
    (
        while :; do
        echo "# $(top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print "CPU usage: " $1 " %"} ')" #for the text
       
        top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print $1}'
        alert_check=$( top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print $1}' |tr -d '[:space:]') #for the progress bar
        if checking_alerts $alert_check "High CPU Usage" "CPU usage is too high $alert_check"; then 
            exit 
        fi
        sleep 3
        done
    ) | zenity --progress --title="CPU Performance" --width=500

    
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

function get_cpu_temp(){
   
    # sensors | grep 'Tctl:' | cut -d ':' -f2 |awk '{print $1}'
    execution_source_check
   
    (while :; do
   
    echo "# $(sensors | grep 'Tctl:' | cut -d ':' -f2 |awk '{print "current temp: " $1}')"
    sensors | grep 'Tctl:' | cut -d ':' -f2 |awk '{gsub(/[^0-9.]/, ""); print}'
    alert_check=$(sensors | grep 'Tctl:' | cut -d ':' -f2 |awk '{gsub(/[^0-9.]/, ""); print}') #for the progress bar
    if checking_alerts $alert_check "High CPU Temperature" "CPU Temperature is too high $alert_check"; then 
        exit 
    fi
    sleep 3 
    done ) | zenity --progress --title="CPU Temperature" --width=500


}



function get_disk_usage(){
    # df -h | column -t 
    df -h --total | head -n 1 
    df -h --total |tail -n 1
    df -h --total | awk '/^total/ {print "Used Disk: " $3 " / " $2}'


}

function get_smart_status(){
    sudo smartctl --all /dev/nvme0
}


function get_memory_usage(){
    free -h #| column -t
    free -h | awk '/^Mem:/ {print "Used RAM: "$3 " / " $2}'

}

function get_gpu_info() {
   
    
    if lspci | grep -i "NIVIDIA" ; then
        nvidia-smi

    elif lspci | grep -i "AMD"; then
        radeontop

    elif lspci | grep -i "Intel"; then
        sudo intel_gpu_top


    fi
############################################################
    #for NVIDIA, you might use `nvidia-smi`
    #for AMD, `radeontop`, but use lspci for basic info.
    # gpu_line=$(lspci | grep -i 'vga\|3d\|2d')
    # if [ -z "$gpu_line" ]; then
    #     echo "No dedicated GPU found or unable to detect GPU usage."
    # else
    #     echo "GPU Info:"
    #     echo "$gpu_line"
    #     echo
    #     echo "For more detailed GPU stats, consider installing specific GPU tools like 'nvidia-smi' or 'radeontop'."
    # fi
    # lspci | grep -i 'vga\|3d\|display'
    # lspci | head -n 3
    # if lspci | grep -i nvidia > /dev/null 2>&1; then
    #     # NVIDIA GPU
    #     output=$(nvidia-smi)
    #     zenity --info --text="<b>NVIDIA GPU Information</b>\n\n$output"
    # elif lspci | grep -i 'amd' | grep -i 'vga' > /dev/null 2>&1; then
    #     # AMD GPU
    #     # Ensure radeontop is installed
    #     output=$(radeontop -b -l 1 2>/dev/null)
    #     if [ -z "$output" ]; then
    #         zenity --info --text="AMD GPU detected but radeontop is not installed or failed to run."
    #     else
    #         zenity --info --text="<b>AMD GPU Information (radeontop)</b>\n\n$output"
    #     fi
    # elif lspci | grep -i 'intel' | grep -i 'vga' > /dev/null 2>&1; then
    #     # Intel Integrated GPU
    #     # intel_gpu_top should be installed for detailed metrics
    #     output=$(intel_gpu_top -l 1 2>/dev/null)
    #     if [ -z "$output" ]; then
    #         zenity --info --text="Intel GPU detected but intel_gpu_top is not installed or failed to run."
    #     else
    #         zenity --info --text="<b>Intel GPU Information</b>\n\n$output"
    #     fi
    # else
    #     zenity --info --text="No supported GPU detected or tools not installed."
    # fi
   
    
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
    zenity --info --title="Exit Page" --text="<b>Thanks BAAAYIE</b>" --width=500
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
            display_data "GPU Utilization & Health" "$data"
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
