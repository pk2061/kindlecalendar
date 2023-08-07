#!/bin/sh
# Author:   Jan Philipp Köhler   
# Date:     05.08.2023
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
#
# Apps used:
# Sync with vdirsyncer              found here: https://github.com/pimutils/vdirsyncer 
# Show calendar with khal           found here: https://github.com/pimutils/khal
# Html conversion is done with aha  found here: https://github.com/theZiz/aha

# Parameters: 
# 

# Sync calendar events:
vdirsyncer sync

# Show the calendar / list of events and parse it into html:
khal --color agenda | aha -n > work/agenda.html

# German localization:
# Replace "Today" with "Heute" 
sed -i s/Today/Heute/ work/agenda.html
# Replace "Tomorrow" with "Morgen" 
sed -i s/Tomorrow/Morgen/ work/agenda.html

# Add current Date:
date +'<span style="font-weight:bold;">Heute ist %A, der %d.%m.%Y</span>' > work/date.txt

# Combine files to one:
cat html/aha-header.tpl work/date.txt work/agenda.html html/aha-footer.tpl > work/output.html

# Store output.html on the webserver:
# This is optional and only for sort of debuging.
# The path 
<- HERE!
/var/www + #TODO: Subfolder für www Pfad

# Generate png 

#SOMEVAR='text stuff'  
#echo "$SOMEVAR"

#TODO: - webserver config 
#TODO: - Cron Job + Doku
#TODO: - Kindle Script + Cronjob
#TODO: - Doku auf Github
#TODO: - DEPLOY-Skript bauen

Stuff:
https://suebenit.com/de/sysadmin/server/raspi/raspberry-pi-als-webserver-mit-nginx.html

sudo chromium-browser --headless --no-sandbox --disable-gpu --screenshot=test2.png test.html
