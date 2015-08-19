## jbhcron.sh

(JBHCron) Jekyll Blog Helper Cron

This is a server shell script that is designed to be copied to your server and
run via a cron job.

There are two settings in the script that you must set

_publicPath="/home/username/public_html"

_stagingPath="/home/username/public_html_stage"

The script is designed to allow for a maximum of one update per day. I suggest
you configure cron to run the script every 6 hours.

Create a folder in the staging folder with the date format "yyyy-mm-dd" and
place the contents of your website in that folder.

