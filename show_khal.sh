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
# Apps used:
# Sync with vdirsyncer              found here: https://github.com/pimutils/vdirsyncer 
# Show calendar with khal           found here: https://github.com/pimutils/khal
# Html conversion is done with aha  found here: https://github.com/theZiz/aha
# Conversion from html to png is done with chromium

# Get Parameters from conf-file 
source kindlecalendar.conf

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
# This is optional and only debuging the output of khal and aha.
cp work/output.html ${host_web_server_file_location}/${host_webserver_subfolder}

# Generate png 
# This is using the chromium browser
#TODO: Make this customizable for different chrome variants
chromium-browser --headless --no-sandbox --disable-gpu --screenshot=work/output.png --window-size=600,800 work/output.html

# Make it read-only for all
chmod 644 work/output.png

# Copy png-file to the webserver
cp work/output.html ${host_web_server_file_location}/${host_webserver_subfolder}

# Now we are done here!