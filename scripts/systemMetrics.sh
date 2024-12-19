#!/bin/bash

function main(){
    echo "Resources:\
    1)CPU performance and temperature\
    2)Disk usage \
    3)SMART status
    4)Memory consumption\
    5)GPU utilization and health\
    6)Network interface statistics\
    7)System load metrics
    "
    read -sp "Please enter the number of the resource you want to check(1-7)" input
    echo :
    systemMetrics "$input"
}
function systemMetrics(){
    resource=$1
    case $resource in
    "1") #cpu
        top - bn1 | head -n 3 ;;
     
    "2") #disk
        df -h ;;
    "3") #SMART
        sudo smartctl --all /dev/nvme0 ;;   # the /dev/nvme0 part differs from device to device
    "4") #memory
       free -h ;;
    "5") #gpu
        radeon ;;
   
    *)
        echo Invalid input ;;
       
    esac 
}
main
# #dependencies: sudo apt install gpustat //for nividia
# #            sudo apt install radeontop  //for radeon
# #              sudo apt install smartmontools