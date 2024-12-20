#!/usr/bin/env bash
# setup_influxdb.sh
# Ensures InfluxDB database is created before we start collecting.

# # Wait for InfluxDB to be ready
# sleep 5

# # Create the database 'metrics' if it doesn't exist
# curl -s -XPOST 'http://influxdb:8086/query' --data-urlencode "q=CREATE DATABASE metrics" > /dev/null






function get_cpu_performance(){
    top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print $1}'
      
}


function get_cpu_temp(){
    sensors | grep 'Tctl:' | cut -d ':' -f2 |awk '{print $1}'
    # temp_line=$(sensors | grep -m1 "Package id 0: ")
    # if [ -z "$temp_line" ]; then
    #     echo "CPU Temperature info not found."
    # else
    #     echo "$temp_line"
    # fi
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
    zenity --info --no-wrap --text="<b>$heading</b>\n\n$data" --title="$heading" --width=500 --height=300
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


function main() {
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
            display_data "CPU Performance" "CPU usage: $data %"
            ;;
        "2")
            data=$(get_cpu_temp)
            display_data "CPU Temperature" "$data" 
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

main

