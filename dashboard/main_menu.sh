#!/usr/bin/env bash
# main_menu.sh
# The main menu of the dashboard with options:
# - Live Stats
# - Reports
# - Search Historical Data
# - Exit

source ./utils.sh

while true; do
    CHOICE=$(zenity --list --title="Main Menu" \
        --text="$(heading_text 'System Monitoring Dashboard')\n$(body_text 'Choose an option:')" \
        --column="ID" --column="Action" \
        1 "View Live Stats" \
        2 "Reports" \
        3 "Search Historical Data" \
        4 "Exit" \
        --height=300 --width=400)

    case $CHOICE in
        1)
            ./live_stats.sh
            ;;
        2)
            ./reports_menu.sh
            ;;
        3)
            ./search_menu.sh
            ;;
        4)
            break
            ;;
        *)
            break
            ;;
    esac
done





# #!/bin/bash
# function main(){
#     echo "Resources:\
#     1)CPU performance and temperature\
#     2)Disk usage \
#     3)SMART status
#     4)Memory consumption\
#     5)GPU utilization and health\
#     6)Network interface statistics\
#     7)System load metrics
#     "
#     read -sp "Please enter the number of the resource you want to check(1-7)" input
#     echo :
#     systemMetrics "$input"
# }
# function systemMetrics(){
#     resource=$1
#     case $resource in
#     "1") #cpu
#         top - bn1 | head -n 3 ;;
     
#     "2") #disk
#         df -h ;;
#     "3") #SMART
#         sudo smartctl --all /dev/nvme0 ;;   # the /dev/nvme0 part differs from device to device
#     "4") #memory
#        free -h ;;
#     "5") #gpu
#         radeon ;;
   
#     *)
#         echo Invalid input ;;
       
#     esac 
# }
# main
# #dependencies: sudo apt install gpustat //for nividia
# #            sudo apt install radeontop  //for radeon
# #              sudo apt install smartmontools