#!/bin/bash

function main(){
    menu="Resources:\
    1)CPU performance and temperature\
    2)CPU temerature
    3)Disk usage \
    4)SMART status
    5)Memory consumption\
    6)GPU utilization and health\
    7)Network interface statistics\
    8)System load metrics"

    input=$(zenity --list --title="Select resource"  --column="resource" $menu --width=1000 --height=300)
    # read -sp "Please enter the number of the resource you want to check(1-7)" input
    # echo :
    systemMetrics "$input"
}
function systemMetrics(){
    resource=$1
    case $resource in
    "1") #cpu
        output=$(top - bn1 | head -n 3) 
         zenity --info --text="**CPU Performance**: ${output}";;
       
    "2") #cpu temp
        output=$(sensors);;
        # zenity --info --text="**CPU Temperature**: ${output}" 
        #i will write it in setupinfluxdb
    "3") #disk
        output=$(df -h)
        zenity --info --text="$output"  ;;
    "4") #SMART
        sudo smartctl --all /dev/nvme0 ;;   # the /dev/nvme0 part differs from device to device
    "5") #memory
       free -h
        ;;
    "6") #gpu
        # GPU_TYPE=$(lspci | grep -i 'vga\|3d\|2d' | awk '{print tolower($0)}')
        # if [$GPU_TYPE== ""]
        ;;
    "7") 
        #ip -s link
        ifconfig
    ;;
    
    *)
        zenity --error --text="Invalid input!"

        echo Invalid input ;;
       
    esac 
}
main
# #dependencies: sudo apt install gpustat //for nividia
# #            sudo apt install radeontop  //for radeon
# #              sudo apt install smartmontools





#
#
# nvm i will write it in setup influxdb.sh, 
#



function get_gpu_info() {
    if lspci | grep -i nvidia > /dev/null 2>&1; then
        # NVIDIA GPU
        output=$(nvidia-smi)
        zenity --info --text="<b>NVIDIA GPU Information</b>\n\n$output"
    elif lspci | grep -i 'amd' | grep -i 'vga' > /dev/null 2>&1; then
        # AMD GPU
        # Ensure radeontop is installed
        output=$(radeontop -b -l 1 2>/dev/null)
        if [ -z "$output" ]; then
            zenity --info --text="AMD GPU detected but radeontop is not installed or failed to run."
        else
            zenity --info --text="<b>AMD GPU Information (radeontop)</b>\n\n$output"
        fi
    elif lspci | grep -i 'intel' | grep -i 'vga' > /dev/null 2>&1; then
        # Intel Integrated GPU
        # intel_gpu_top should be installed for detailed metrics
        output=$(intel_gpu_top -l 1 2>/dev/null)
        if [ -z "$output" ]; then
            zenity --info --text="Intel GPU detected but intel_gpu_top is not installed or failed to run."
        else
            zenity --info --text="<b>Intel GPU Information</b>\n\n$output"
        fi
    else
        zenity --info --text="No supported GPU detected or tools not installed."
    fi
}
