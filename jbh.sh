#/bin/bash
#----------------------------------------
# JBH - Jekyll Blog Helper
# A bash shell script tool to management
# Jekyll blog sites.
# For more information please visit
# http://github.com/alanbarber/jbh
#----------------------------------------
# Settings
# Notes: Always set leading and trailing slashes in path
#        Paths are relative to the jekyll directory

_sitePath="/_site/"	
_postPath="/_posts/"
_draftPath="/_drafts/"
_templatePath="/_templates/"
_assetPath="/assets/"

_excerptSeparator="/--more--/"

# Remote Server Settings
# Notes: Paths should be fully qualified
_remoteUseRsync="true"

_publishUser="username"
_publishServer="server.tld"
_publishPath="/home/username/public_html/"

_stageUser="username"
_stageServer="server.tld"
_stagePath="/home/username/public_html_stage/"

########################################
# DO NOT EDIT BELOW THIS LINE
########################################
# Current Version Of Script
_version="1.3.0 beta"

# Helper Function
function fnConvertTitleToFilenameFormat {
	# lowercase, remove non alphanumerics and non spaces, convert spaces to dash
	local _title=$(echo $1 | sed -e 's/\(.*\)/\L\1/')
	_title=$(echo $_title | sed -e 's/[[:punct:]]//g')
	_title=$(echo $_title | sed -e 's/\s/-/g')
	echo "$_title"
}
function fnGetFileNameFromDateAndTitle { 
	local _title=$(fnConvertTitleToFilenameFormat "$2")
	local _date=$(date -d "$1" +%Y-%m-%d)
	echo "$_date-$_title.md"

}
function fnGetAssetDirectoryFromDateAndTitle {
	if [[ "$_assetPath" != "" ]]; then
		local _title=$(fnConvertTitleToFilenameFormat "$2")
		echo "$_assetPath$(date -d $1 +%Y)/$(date -d $1 +%m)/$(date -d $1 +%d)/$_title"
	else
		echo ""
	fi
}
# Feature Functions
# Version
function fnVersion {
	echo "Jekyll Blog Helper $_version"
	echo "Report bugs to <github.com/alanbarber/jbh>"
	echo ""
}
# Help Info
function fnHelpInfo {
	echo "Usage: jbh.sh [OPTIONS]..."
	echo "Jekyll Blog Helper $_version - A command line blog management tool"
	echo ""
	echo "Options:"
	echo ""
	echo "  -b, --build    runs a jekyll build"
	echo "  -c, --clean    cleans out the site output directory"
	echo "  -h, --help     displays help info for the script"
	echo "  -l, --list     lists all posts or drafts"
	echo "  -m, --move     moves a draft to post or post to draft status"
	echo "  -n, --new      creates a new post or draft"
	echo "  -p, --publish  copies site via rcp/rsync to remote server"
	echo "  -s, --serve    runs the jekyll server"
	echo "  -u, --update   update title or date of a post"	
	echo "  -v, --version  displays version of the script"
	echo ""
	echo "Modifiers:"
	echo ""
	echo "  --build:"
	echo "    -d, --draft    includes drafts in jekyll build"
	echo "  --list:"
	echo "    -d, --draft    lists draft posts"
	echo "    -p, --post     lists posts"
	echo "  --new:"
	echo "    -d, --draft    creates a new draft post"
	echo "    -t, --template specifies a template to use to create the post"
	echo "  --move:"
	echo "    -d, --draft    moves a draft to post"
	echo "    -p, --post     moves a post to draft"
	echo "  --publish:"
	echo "    -s, --stage    copies site to staging folder on remote server"
	echo "  --serve:"
	echo "    -d, --draft    includes draft in jekyll server"
	echo "  --update:"	
	echo "    -d, --draft    indicates you are updating a draft"
	echo "        --date     updates date of a post specified"
	echo "        --title    updates title of post specified"
	echo ""
	echo "Examples:"
	echo ""
	echo "  jbh.sh --new \"Blog title\""
	echo "    Creates a new post with the given title"
	echo ""
	echo "  jbh.sh --new \"Blog title\" \"1/1/2015\""
	echo "    Create a new post on a specific date"
	echo ""
	echo "  jbh.sh --new \"Blog title\" --template \"template-name\""
	echo "    Creates a new post witht he given title using a custom template"
	echo ""
	echo "  jbh.sh --new --draft \"Blog title\""
	echo "    Creates a new draft post with the given title"
	echo ""
	echo "  jbh.sh --build"
	echo "    Builds the site"
	echo ""
	echo "  jbh.sh --publish"
	echo "    Runs rcp/rsync to copy built site to a remote server"
	echo "    * NOTE: Server settings are stored at top of script"
	echo ""
	echo "  jbh.sh --publish --stage \"1/1/2015\""
	echo "    Runs rcp/rsync to copy built site to a stage folder for the specified"
	echo "    date on remote server"
	echo "    * NOTE: Server settings are stored at top of script"
	echo "    * NOTE: This command is designed to work with companion JBHCron.sh script"
	echo ""
	echo "  jbh.sh --list \"*2015*\""
	echo "    Lists all posts that have '2015' in the file name"
	echo ""
	echo "  jbh.sh --move --draft \"2015-01-01-blog-title.md\""
	echo "    Moves the matching file from draft to post folder"
	echo ""
	echo "  jbh.sh --update \"2015-01-01-blog-title.md\" --date \"2/1/2015\" "
	echo "  jbh.sh --update \"2015-01-01-blog-title.md\" --title \"new title\" "
	echo "    Updates the given post's data. This is a destructive process that"
	echo "    will rename the file, update values inside the header, and move"
	echo "    any assets folders to match. You can only update one value at a time."
	echo ""	
	echo "Report bugs to <github.com/alanbarber/jbh>"
	echo ""
}
# Build
function fnBuild {
	echo "Running Jekyll build..."
	if [[ "$1" == "-d" || "$1" == "--draft" ]]; then
		echo "Including drafts..."
		jekyll build --destination ".$_sitePath" --drafts
	else
		jekyll build --destination ".$_sitePath"
	fi
}
# Clean
function fnClean {
	echo "Cleaning site directory '$_sitePath'..."
	# we remove and recreate the dir to make sure all files
	# including hidden dot files (.htaccess, etc) are gone
	rm -rf .$_sitePath
	mkdir -p .$_sitePath
}
# List
function fnList {
	if [[ "$1" == "-d" || "$1" == "--draft" ]]; then
		echo "Listing draft posts..."
		local _listPath="$_draftPath"
		local _listSearch="$2"
	elif [[ "$1" == "-p" || "$1" == "--post" ]]; then
		echo "Listing posts..."
		local _listPath="$_postPath"
		local _listSearch="$2"		
	else
		echo "Listing posts..."
		local _listPath="$_postPath"
		local _listSearch="$1"
	fi
	ls -Ax1 .$_listPath$_listSearch
} 
# Move Draft
function fnMoveDraft {

}
# Move Posts
function fnMovePost {
	local _moveFile="$2"
	if [[ ("$1" == "-d" || "$1" == "--draft") && "$_moveFile" != "" ]]; then
		echo "Moving draft to post..."
		if [ -e ".$_draftPath$_moveFile" ]; then
			mv -f .$_draftPath$_moveFile .$_postPath$_moveFile
		else
			echo "  Error: Unable to find draft '$_moveFile'"
			exit 1
		fi
	elif [[ ("$1" == "-p" || "$1" == "--post") && "$_moveFile" != "" ]]; then
		echo "Moving post to draft..."
		if [[ -e ".$_postPath$_moveFile" || -e "" ]]; then
			mv -f .$_postPath$_moveFile .$_draftPath$_moveFile
		else
			echo "  Error: Unable to file post '$_moveFile'"
			exit 1
		fi
	else
		echo "  Error: No file specified to move"
		echo ""
		exit 1
	fi
}
# New Draft
function fnNewDraft {

}
# New Post
function fnNewPost {
	echo "Creating new post..."
	if [[ "$1" == "-d" || "$1" == "--draft" ]]; then
		echo "  Making post a draft..."
		local _title="$2"
		if [ "$3" == "" ]; then
			local _date=$(date +%Y-%m-%d)
		else
			local _date=$(date -d $3 +%Y-%m-%d)
		fi
		local _path="$_draftPath"
	else
		_title="$1"
		if [ "$2" == "" ]; then
			local _date=$(date +%Y-%m-%d)
		else
			local _date=$(date -d $2 +%Y-%m-%d)
		fi		
		local _path="$_postPath"
	fi
	# setup vars
	local _fileName=$(fnGetFileNameFromDateAndTitle "$_date" "$_title")
	local _outputFile="$_path$_fileName"
	local _assetDir=$(fnGetAssetDirectoryFromDateAndTitle "$_date" "$_title")

	# Create file and write Jekyll header info
	echo "  Creating file '$_outputFile'..."
	echo "    Title: $_title"
	echo "    Date: $_date"

	echo "---" > ".$_outputFile"
	echo "layout: post" >> ".$_outputFile"
	echo "title: \"$_title\"" >> ".$_outputFile"
	echo "date: $_date" >> ".$_outputFile"
	echo "categories: []" >> ".$_outputFile"
	echo "tags: []" >> ".$_outputFile"
	echo "---" >> ".$_outputFile"
	
	# Create asset directory for post and add markdown link reference to bottom
	if [[ "_assetDir" != "" ]]; then
		echo -e "\n\n$_excerptSeparator\n\n[assets]: $_assetDir" >> ".$_outputFile"
		echo "  Creating asset folder '$_assetDir'"
		mkdir -p ".$_assetDir"
	fi
}
# Publish
function fnPublish {
	echo "Publishing site to remote server..."
	# Verify settings
	if [[ "$_publishPath" == "" || "$_publishUser" == "" || "$_publishServer" == "" ]]; then
		echo "  Error: Unable to determine settings to publish to remote server!"
		echo ""
		exit 1
	else
		if [[ "$_remoteUseRsync" == "true" ]]; then
			echo "Using rsync..."
			rsync --compress --recursive --checksum --itemize-changes --delete .$_sitePath $_publishUser@$_publishServer:$_publishPath
		else
			echo "Using scp..."
			scp -C -r .$_sitePath* $_publishUser@$_publishServer:$_publishPath
		fi
	fi
}
# Stage
function fnStage {
	echo "Staging site to remote server..."
	# Verify settings
	if [[ "$_stagePath" == "" || "$_stageUser" == "" || "$_stageServer" == "" ]]; then
		echo "  Error: Unable to determine settings to stage to remote server!"
		echo ""
		exit 1
	else
		if [[ "$1" == "" ]]; then
			echo "ERROR: Please specify date to stage!"
			exit 1
		fi
		
		local _date=$(date -d $1 +%Y-%m-%d)
		local _remotePath="$_publishStagePath$_date/"		
		
		if [[ "$_remoteUseRsync" == "true" ]]; then
			echo "Using rsync..."
			rsync --compress --recursive --checksum --itemize-changes --delete .$_sitePath $_publishUser@$_publishServer:$_remotePath
		else
			echo "Using scp..."
			scp -C -r .$_sitePath* $_publishUser@$_publishServer:$_remotePath
		fi
}
# Server
function fnServe {
	echo "Running Jekyll server..."
	if [[ "$1" == "-d" || "$1" == "--draft" ]]; then
		echo "Including drafts..."
		jekyll serve --destination ".$_sitePath" --drafts
	else
		jekyll serve --destination ".$_sitePath"
	fi
}
function fnUpdateDraft {

}
# Update Post
function fnUpdatePost {
	if [[ "$1" == "-d" || "$1" == "--draft" ]]; then
		local _updatePostType="draft"
		local _updateFile="$2"
		local _updateFilePath="$_postPath$_updateFile"
		local _updateAction="$3"
		local _updateValue="$4"
		local _updateCurrentAssetDir=""
		local _updateNewAssetDir=""
	else
		local _updatePostType="post"
		local _updateFile="$1"
		local _updateFilePath="$_postPath$_updateFile"
		local _updateAction="$2"
		local _updateValue="$3"
		local _updateCurrentAssetDir=""
		local _updateNewAssetDir=""
	fi

	#
	if [[ "$_updateFile" != "" && -e ".$_updateFilePath" ]]; then
	
	else
		echo "  Error: unable to find $_updatePostType '$_updateFile'"
		echo ""
		exit 1
	fi	
}
# Process command line# Parse options
case "$1" in
	-b)
		fnBuild "$2"
		;;
	--build)
		fnBuild "$2"
		;;
	-c)
		fnClean
		;;
	--clean)
		fnClean
		;;
	--clear)
		fnClean
		;;
	-l)
		fnList "$2" "$3"
		;;
	--list)
		fnList "$2" "$3"
		;;
	-m)
		fnMove "$2" "$3"
		;;
	--move)
		fnMove "$2" "$3"
		;;
	-n)
		fnNew "$2" "$3" "$4" "$5" "$6"
		;;
	--new)
		fnNew "$2" "$3" "$4" "$5" "$6"
		;;
	-p)
		if [[ "$2" == "-s" || "$2" == "--stage" ]]; then
			fnStage "$3"
		else
			fnPublish
		fi
		;;
	--publish)
		if [[ "$2" == "-s" || "$2" == "--stage" ]]; then
			fnStage "$3"
		else
			fnPublish
		fi
		;;
	-s)
		fnServe "$2"
		;;
	--serve)
		fnServe "$2"
		;;
	--server)
		fnServe "$2"
		;;
	-u)
		fnUpdate "$2" "$3" "$4" "$5"
		;;
	--update)
		fnUpdate "$2" "$3" "$4" "$5"
		;;		
	-v)
		fnVersion
		;;
	--version)
		fnVersion
		;;
	*)
		fnHelpInfo
		;;
esac
exit 0
