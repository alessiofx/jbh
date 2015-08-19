#/bin/bash
#----------------------------------------
# JBHCron - Jekyll Blog Helper Cron
# A cron script to check a staging folder
# for new versions of a jekyll static
# site and update the public site
# 
# This script should be placed in the
# home directory of your webserver and
# scheduled via cron to run at least once
# a day.
#
_version="1.0.0"
# http://github.com/alanbarber/jbh
#----------------------------------------
# Settings
# Note: Always set leading and trailing slashes in path! Paths are relative.
_publicPath="/home/username/public_html/"
_stagingPath="/home/username/public_html_stage/"

########################################
# DO NOT EDIT BELOW THIS LINE
########################################

# Make sure public path exists
if [ ! -d "$_publicPath" ]; then
	echo "ERROR: Public site directory '$_publicPath' was not found."
	exit 1
fi
# Make sure staging path exists
if [ ! -d "$_stagingPath" ]; then
	echo "ERROR: Staging site directory '$_stagingPath' was not found."
	exit 1
fi

# Get the current date and check to see if we have staging folder for today
_date=$(date +%Y-%m-%d)
_currentDayStagePath="$_stagingPath$_date/"

if [ -d "$_currentDayStagePath" ]; then

	# Use rsync to copy contents of staging to public
	rsync --archive --recursive --delete --quiet "$_currentDayStagePath" "$_publicPath"

	# If there are no errors from rsync then we delete the stage folder
	if [[ "$?" == "0" ]]; then
		rm -rf "$_currentDayStagePath"
	else
		"ERROR: Copy of staging folder '$_currentDayStagePath' to production folder '$_publicPath' failed."
		exit 1
	fi
fi
exit 0
