#!/bin/sh
# Author:   Jan Philipp Köhler   
# Date:     05.05.2023
#
# Version:   0.1  
# Description:
# This script firstly syncs your caledar entries with "vdirsyncer sync"
# and the displays the calender with "khal -v CRITICAL  calendar".
#
# In Order to make this work make sure to have booth tools installed
# and configured properly.
#

# 

# calculate_sleep_offset
# Gets the difference between the current time and the next run. 
# Param 1: Time of the next run. (Format hh:mm)
calculate_sleep_offset () 
{
    local current_time=$(date +%s)
    local target_time=$(date -d '05/05/2023 $1' +%s)

    local sleep_seconds=$(( $target_time - $current_time ))
    sleep $sleep_seconds

    return $sleep_seconds
}

# MAIN:

# determine startup parameters
if [ $1 = '']
then
    echo "Not enough arguments. Please supply up to 3 refresh times like this: 05:00 12:00 18:00 "
    echo "Or use -h or --help for help." #TODO Implement help!

$refresh_time1=$1
$refresh_time1=$2
$refresh_time1=$3

# determine first run:
current_time=$(date +%H:%M)




while true # Improve here!
    
    # invoke 1 timeslot
    # calc time to wait
    # wait
    # show calender

    # invoke 2 timeslot
    # calc waittime
    # wait
    # show calender

    # invoke 3 timeslot
    # calc waittime
    # wait
    # show calender

    # Sync & show results:
    clear
    # Sync with vdirsyncer 
    # found here: https://github.com/pimutils/vdirsyncer 
    vdirsyncer sync
    clear 

    # Show calendar with khal
    # found here: https://github.com/pimutils/khal
    echo ">---------<= Tagesübersicht =>---------<"  
    khal -v CRITICAL  calendar 

done

#SOMEVAR='text stuff'  
#echo "$SOMEVAR"