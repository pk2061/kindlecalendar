#!/bin/bash
# Author:   Jan Philipp Köhler   
# Date:     08.08.2023
#
# Version:   0.1  
# Description:
# This script picks up the calendar image file from the host´s webserver
# and copies it into the screensaver folder.
#
# The kindle needs to be jailbreaked and the following tools need to be installed:
#TODO: Add Documentation

# Get Parameters from conf-file 
source kindlecalendar.conf

# Delete current image
 rm /mnt/us/linkss/screensavers/output.png 

# Get new screensaver image
curl http://"${host_server_address}"/"${host_webserver_subfolder}"/output.png -o /mnt/us/linkss/screensavers/output.png

# Reboot the device for the new screensaver to take effect:
reboot