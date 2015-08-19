#(JBH) Jekyll Blog Helper - A bash shell script to help manage a jekyll weblog site

#Change Log

## Version 1.3.0

 * Added --staging option to --publish command. Lets you send the site to a
non-production location for testing or staging to production at a later time. 
 * Added --template option to --new command. Lets you select an optional
template as the basis for creating a new post or draft.
 * Added --update command. This command gives you the ability to change the
date/title of and existing post or draft.
 * Lots of code refactoring to make it easier to work with.

## Version 1.2.0

 * Added --list command. Lets you get a raw view of posts and drafts. Includes
optional filter.
 * Added --move command. Lets you move drafts to post and posts to draft folder.
 * Changed asset folder so that if set to "" in config it will disable creation
of asset folder and not add ref link to bottom of post

## Version 1.1.0

 * Added paths to config options at the top
 * Found a bug in the --new command
 * Added version info to script for better tracking of bug reports

## Version 1.0.0

Initial release to public
