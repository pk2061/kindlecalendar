# kindlecalendar
A commandline based calendar for Kindle e-readers.

The goal of the projekt is to display a CALDAV-Calendar (from iCloud, nextCloud whatever) as screensaver on your (old) Kindle ebook reader.

First of all: 
All code and scripts are provided as is and comes with no warrenty what so ever.

This litle project is based on two scripts:
The show_kahl which goes on a linux-bases host system and the get_calendar_image which runs on the Kindle and gets the calander data from the host.

The host side:
The host is fetching the calendar entries from your CALDAV calendar and creates a png file for the Kindle to download.

The show_khal.sh script:
This script syncs your caledar entries with "vdirsyncer sync"
and outputs the calender to the termnial with khal.
After that, the output will be captured to html with aha and made nice with some html/css.
At last the html output is converted to a png-image file using chromium and put to the webserver,
where it can be picked up by the kindle client.

Host requirements:
You need a simple Linux based system as host. I uses a Raspberry Pi 2 for example.
Basically a similar Computer should be fine. Alternativly you can use a Linux-VM or server somewhere.
It should also be possible to run this in a Docker-Container, but I have not tested that as of now.

Also it should not matter if the host runs in your local network or an the internet somewhere.
The only thing that matters, is that the host can reach your calendar provider and that it can be reached by the Kindle.

The following apps must be installed:
Sync calendar entries with vdirsyncer found here: https://github.com/pimutils/vdirsyncer 
Show calendar with khal               found here: https://github.com/pimutils/khal
Html conversion is done with aha      found here: https://github.com/theZiz/aha
Conversion from html to png is done with chromium.
Any kind of webserver (e.g. nginx),

How to setup the host side:
Make sure you have the apps installed and configured which are listed above.
The documentation to khal (and vdirsyncer) can be found here: https://khal.readthedocs.io/en/latest/

When khal is up and running you can copy / checkout the projekt files to your user directory.
On the Host the following files must be installed:
    html
        aha-footer.tpl  
        aha-header.tpl  
        aha-middle.tpl    
    work
        <empty>
    kindlecalendar.conf
    show_khal.sh

Webserver:
To export the generated png-file with the calendar events on the kindle, the host needs an active webserver up an running.
Depending on the webserver you are goning to use, you need to setup a (virtual) folder called "kindlecalendar".
- Please refer to documentation of your webserver on how to set this up. 

When this is done fill out the parameters in the kindlecalendar.conf file 

kindlecalendar.conf
#   Host Adress:
#   IP oder DNS name under which the host can be reached in the network
host_server_address="<your_ip_here>"

#   Webserver local file path:
#   Make sure that the user which executes the show_khal.sh script has read & write permissions on the folders listet below.

#   The place in the host file-system where the files are stored for the webserver running on the host device
host_web_server_file_location="/var/www/html"

#   Sudirectory for the kindlecalendar files on the webserver 
host_webserver_subfolder="kindlecalendar"

If you done that test the script to make sure you have everything set up correctly.
You should be able to see your calendar entries in your browser when you run the following adress:
<your host ip oder hostname>/kindlecalendar/output.png (e.g. http://raspberrypi.local/kindlecalendar/output.png).

Keep the browsertab open or note the address somewhere, you will need it below!

Config Crontab on Host:
To update the calender an a daily basis you need to register the show_khal.sh script in cron.

For that run

crontab -e

add the follwoing line to execute the host script every night an 01:00:
0 1 * * * ~/kindlecalendar/show_khal.sh


On Kindle: 
The Kindle (the client) now just needs to download the generated png-file and show it as screensaver, while the Kindle is "turned off". 

Prepare the Kindle:
The kindle needs to be jailbreaked and the following tools need to be installed:
Kindle Screen Saver Hack  found here: https://wiki.mobileread.com/wiki/Kindle_Screen_Saver_Hack_for_all_2.x,_3.x_%26_4.x_Kindles
Kindle Jailbrake          found also in the link provided above
USBNetwork                found also in the link provided above      

Also the KUAL launcher helps to switch the USBNetwork on and off. 
This is optional, but it can be found here: https://www.mobileread.com/forums/showthread.php?t=203326

Also a good documentation an how to jailbrake the Kindle 4 I am was unsing for the projet can be found here:
https://wiki.mobileread.com/wiki/Kindle4NTHacking#Jailbreak

Setup get_calendar_image.sh script:
This script picks up the calendar image file from the host´s webserver nd copies it into the screensaver folder.

Plug your Kindle in your computer and create the folloing folders on the Kindle 

mkdir kindlecalendar
mkdir kindlecalendar/lock

Next copy the following files into the new folder kindlecalendar
    get_calendar_image.sh
    kindlecalendar.conf <- this is currently optinal as it is not used yet.

Open the get_calendar_image.sh script and in the curl statement replace the http-address with your host address (from above).

Setting up the cron job on the Kindle:
The kindle will only sit there and display the current calendar as its screensaver.
In order to update the calendar the get_calendar_image.sh script: needs to run the script periodically. For this a cron job on the Kindle is needed.

To set this up make sure USBNetwork is installed in the Kindle.*
The to start it either use KUAL or press the keyboard button on the Kindle, and type ;debugOn (make sure to get the semicolon at the beginning), and then enter (↵) to enable debug mode.
Press the keyboard button again, and type ~usbNetwork and hit enter (↵). It may pause for a second. Once it’s done, press keyboard, type ;debugOff and hit enter.
Reconnect your Kindle to your computer via USB.
Connect to you Kindle via SSH using putty on Windows or any terminal on Linux or Mac.

#Hier weitermachen!
Type ssh root@192.168.15.244 and hit enter.
You’ll be prompted for a password. The default password is mario.

Type ssh root@192.168.15.244 and hit enter.
if You’ll be prompted for a password use default password mario.

By default, the Kindle’s drive is mounted in read-only mode. To make it writeable, type 

mntroot rw and hit enter.

need to edit its configuration file:
nano /etc/crontab/root
Add this line to the bottom

*/5 *  * * * /mnt/us/kindlecalendar/get_calendar_image.sh

This lets the calendar image update every night at 02:00

Again, to save and exit type ⌃O, enter, then ⌃X.
Finally, restart cron:
/etc/init.d/cron restart


Install USBNetwork
Once the Kindle is jailbroken, we’ll need one more thing in order to access it via command line: USBNetwork. You’ll find it in the same forum post where you found the Jailbreak download link. The process for installing is slightly different here — read the instructions, but what you’ll need to do is plug the Kindle in, copy the .bin file over, and then launch it by going to [Menu] -> Settings -> [Menu] -> Update Your Kindle.
Add the script to download images
Next up is to access the Kindle via the command line so we can set up our script to download images. First, we need to enable USBNetwork to allow command-line access via USB:
Disconnect your Kindle from your computer
Press the keyboard button on the Kindle, and type ;debugOn (make sure to get the semicolon at the beginning), and then enter (↵) to enable debug mode.
Press the keyboard button again, and type ~usbNetwork and hit enter (↵). It may pause for a second. Once it’s done, press keyboard, type ;debugOff and hit enter.
Reconnect your Kindle to your computer via USB.
From a command line on your computer (i.e. in the Terminal app on a Mac):
Type ssh root@192.168.15.244 and hit enter.
You’ll be prompted for a password. The default password is mario.
You’re in! One more thing before we can do anything: by default, the Kindle’s drive is mounted in read-only mode. To make it writeable, type mntroot rw and hit enter.
Create the image-downloading script:
nano /mnt/us/script.sh
This will create an empty file for your script and open it for editing. In the editor, type the following, substituting in the URL to download your image (from step 2 above):
curl Insert_your_URL_from_step_2_here -o status.png
eips -c
eips -c
eips -g status.png
To save and exit the editor, type control-O, enter, and then control-X.
The first line there downloads your image and saves it to a file called “status.png”. eips is a program that comes with the Kindle for drawing to the screen. The first two eips commands clear the screen (twice for good measure - especially on older devices there can be some ghosting). The last line displays our image.
You can now test the script by running it like this ./script.sh. You should see the Kindle screen clear, and then a moment later your image will appear.
Set up a cron job
We’ll want the Kindle to automatically download the image and display it every minute. The Kindle’s OS, like other Linux-based operating systems, comes with cron, a tool for running tasks on a schedule. To use it, we just need to edit its configuration file:
nano /etc/crontab/root
Add this line to the bottom:
* * * * * /mnt/us/script.sh
Again, to save and exit type ⌃O, enter, then ⌃X.
Finally, restart cron:
/etc/init.d/cron restart
If everything worked, you should see the image refresh on your Kindle screen every minute. You’re done! You can now unplug the Kindle from your computer.


#TODO: - webserver config 
#TODO: - Cron Job + Doku
#TODO: - Kindle Script + Cronjob
#TODO: - Doku auf Github
#TODO: - DEPLOY-Skript bauen für kindle


Credits to MATT HEALY for inspiration! His Kindle projekt can be found here: https://matthealy.com/kindle
I also borrowed the guide on how to set up the cronjob on the Kindle mostly from him.


*/5 *  * * * /mnt/us/kindlecalendar/get_calendar_image.sh
