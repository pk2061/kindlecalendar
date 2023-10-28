#!/bin/sh
# Author:   Jan Philipp Köhler   
# Date:     01.09.2023
#
# Version:   0.1  
# Description:
# This script picks up the calendar image file from the host´s webserver
# and copies it into the screensaver folder.
#
# The kindle needs to be jailbreaked and the following tools need to be installed:
# Kindle Screen Saver Hack  found here: https://wiki.mobileread.com/wiki/Kindle_Screen_Saver_Hack_for_all_2.x,_3.x_%26_4.x_Kindles
# Kindle Jailbrake          found also in the link provided above

#TODO: Add further documentation!

# Get Parameters from conf-file 
#source /mnt/us/kindlecalendar/kindlecalendar.conf

# Check if Calender is up to date:
date_file=$(date '+%Y-%m-%d')

# Check if update is needed:
if [ ! -f "/mnt/us/kindlecalendar/lock/$date_file" ]; then
    # Date file does not exit -> update:
    # Cleanup old date files:
    rm /mnt/us/kindlecalendar/lock/*

    # Create new datefile:
    touch /mnt/us/kindlecalendar/lock/$date_file

    # Delete current image:
    rm /mnt/us/linkss/screensavers/output.png

    # Get new screensaver image:
    #TODO: Make config-file work here!
    #curl http://"${host_server_address}"/"${host_webserver_subfolder}"/output.png -o /mnt/us/linkss/screensavers/output.png
    curl http://192.168.0.52/kindlecalendar/output.png -o /mnt/us/linkss/screensavers/output.png # <- Replace the http-address with your settings here!

    # Log message for debug:
    result=$?
    if test "$result" != "0"; then
        echo $(date -u) "Curl command failed with: $result" >> /mnt/us/kindlecalendar/logs.txt
    else
        echo $(date -u) "Calendar updated!" >> /mnt/us/kindlecalendar/logs.txt
    fi
  
    # Reboot the device for the new screensaver to take effect:
    reboot
else
    # Print message to screen to show that the chronjob is working:
    #eips 5 10 "Cronjob started -> file already found."
    #sleep 5
    #eips 5 10 "                                      "

    # Uncomment for debug to see if cronjob is working:
   #echo $(date -u) "Cronjob started -> file already found." >> /mnt/us/kindlecalendar/logs.txt
fi


