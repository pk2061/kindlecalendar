#!/bin/bash
# Author:   Jan Philipp Köhler   
# Date:     08.08.2023
#
# Version:   0.1  
# Description:
# This script syncs your caledar entries with "vdirsyncer sync"
# and outputs the calender to the termnial with khal.
# After that, the output will be captured to html with aha and made nice with some html/css.
# At last the html output is converted to a png-image file using chromium and put to the webserver,
# where it can be picked up by the kindle client.
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
source ~/kindlecalendar/kindlecalendar.conf

# Cleanup
rm ~/kindlecalendar/work/*

# Sync calendar events:
vdirsyncer sync

# Show the calendar / list of events and parse it into html:
khal --color list | aha -n > ~/kindlecalendar/work/agenda.html

#add empty row between days:
sed -i s/Tomorrow/<b>Tomorrow/ ~/kindlecalendar/work/agenda.h

# German localization:
# Replace "Today" with "Heute" 
sed -i s/Today/Heute/ ~/kindlecalendar/work/agenda.html
# Replace "Tomorrow" with "Morgen" 
sed -i s/Tomorrow/Morgen/ ~/kindlecalendar/work/agenda.html

# Add current Date:
date +'<span style="font-weight:bold;">Heute ist %A, der %d.%m.%Y</span>' > ~/kindlecalendar/work/date.txt

# Combine files to one:
cat ~/kindlecalendar/html/aha-header.tpl ~/kindlecalendar/work/date.txt ~/kindlecalendar/html/aha-middle.tpl ~/kindlecalendar/work/agenda.html ~/kindlecalendar/html/aha-footer.tpl > ~/kindlecalendar/work/output.html

# Store output.html on the webserver:
# This is optional and only debuging the output of khal and aha.
cp ~/kindlecalendar/work/output.html "${host_web_server_file_location}"/"${host_webserver_subfolder}"

# Generate png 
# This is using the chromium browser
#TODO: Make this customizable for different chrome variants
chromium-browser --headless --no-sandbox --disable-gpu --screenshot='kindlecalendar/work/output.png' --window-size=600,800 ~/kindlecalendar/work/output.html

# Make it read-only for all
chmod 644 ~/kindlecalendar/work/output.png

# Delete old file
rm "${host_web_server_file_location}"/"${host_webserver_subfolder}"/output.png

# Copy png-file to the webserver
cp ~/kindlecalendar/work/output.png "${host_web_server_file_location}"/"${host_webserver_subfolder}"

# Now we are done here!