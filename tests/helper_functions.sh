#/bin/bash

# Settings
_assetPath="/assets/"

# Helper Functions
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
function fnGetDateFromFilename {
	local _date=$(echo $1 | sed -e 's/\([0-9]\{4\}-[0-9]\{1,2\}-[0-9]\{1,2\}\)-\(.*\)\.\(.*\)/\1/')
	echo "$_date"
}
function fnGetTitleFromFilename {
	local _title=$(echo $1 | sed -e 's/\([0-9]\{4\}-[0-9]\{1,2\}-[0-9]\{1,2\}\)-\(.*\)\.\(.*\)/\2/')
	echo "$_title"
}
function fnGetExtensionFromFilename {
	local _extension=$(echo $1 | sed -e 's/\([0-9]\{4\}-[0-9]\{1,2\}-[0-9]\{1,2\}\)-\(.*\)\.\(.*\)/\3/')
	echo "$_extension"
}
function fnGetAssetDirectoryFromDateAndTitle {
	if [[ "$_assetPath" != "" ]]; then
		local _title=$(fnConvertTitleToFilenameFormat "$2")
		echo "$_assetPath$(date -d $1 +%Y)/$(date -d $1 +%m)/$(date -d $1 +%d)/$_title"
	else
		echo ""
	fi
}
function fnGetAssetDirectoryFromFilename {
	if [[ "$_assetPath" != "" ]]; then
		echo "$_assetPath"
	else
		echo ""
	fi
}

# Tests of Helper Functions
echo "fnConvertTitleToFilenameFormat 'My name is Bob' => $(fnConvertTitleToFilenameFormat "My name is Bob")"
echo "fnGetFileNameFromDateAndTitle '01/01/2015' 'My name is Bob' => $(fnGetFileNameFromDateAndTitle "01/01/2015" "My name is Bob")"
echo "fnGetDateFromFilename '2015-01-01-my-name-is-bob.md' => $(fnGetDateFromFilename "2015-01-01-my-name-is-bob.md")"
echo "fnGetTitleFromFilename '2015-01-01-my-name-is-bob.md' => $(fnGetTitleFromFilename "2015-01-01-my-name-is-bob.md")"
echo "fnGetExtensionFromFilename '2015-01-01-my-name-is-bob.md' => $(fnGetExtensionFromFilename "2015-01-01-my-name-is-bob.md")"
echo "fnGetAssetDirectoryFromDateAndTitle '01/01/2015' 'My name is Bob' => $(fnGetAssetDirectoryFromDateAndTitle "01/01/2015" "My name is Bob")"
echo "fnGetAssetDirectoryFromFilename '2015-01-01-my-name-is-bob.md' => $(fnGetAssetDirectoryFromFilename "2015-01-01-my-name-is-bob.md")"
exit 0