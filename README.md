[![GitHub release](https://img.shields.io/github/release/alanbarber/jbh.svg)](#)
[![Github Releases](https://img.shields.io/github/downloads/alanbarber/jbh/latest/total.svg)](#)
[![GitHub issues](https://img.shields.io/github/issues/alanbarber/jbh.svg)](#)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/AlanBarber/jbh?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

# jbh.sh
(JBH) Jekyll Blog Helper - A bash shell script to help manage a Jekyll weblog
site

JBH provides a series of commands for performing common blogging activities
within a Jekyll managed blog.

````
	Usage: jbh.sh [OPTIONS]...
	Jekyll Blog Helper - A command line blog management tool
	
	Options:
	
	  -b, --build    runs a jekyll build
	  -c, --clean    cleans out the site output directory
	  -l, --list     lists all posts or drafts
	  -n, --new      creates a new post
	  -p, --publish  copies site via rcp/rsync to remote server
	  -s, --serve    runs the jekyll server
      -u, --update   update title or date of a post
	  -v, --version  displays version of the script
	
	Modifiers:
	
	  --build:
	    -d, --draft  includes drafts in jekyll build
	  --list:
	    -d, --draft  lists draft posts
	    -p, --post   lists posts
	  --new:
	    -d, --draft  creates a new draft post
        -t, --template specifies a template to use to create the post
	  --move:
	    -d, --draft  moves a draft to post
	    -p, --post   moves a post to draft
	  --serve:
	    -d, --draft  includes draft in jekyll server
      --update:"	
        -d, --draft    indicates you are updating a draft
        --date     updates date of a post specified
        --title    updates title of post specified

	Examples:
	
	  jbh.sh --new "Blog title"
	    Creates a new post with the given title
	
	  jbh.sh --new "Blog title" "1/1/2015"
	    Create a new post on a specific date

      jbh.sh --new "Blog title" --template "template-name"
        Creates a new post witht he given title using a custom template
	
	  jbh.sh --new --draft "Blog title"
	    Creates a new draft post with the given title
	
	  jbh.sh --build
	    Builds the site
	
	  jbh.sh --publish
	    Runs rcp/rsync to copy built site to a remote server
	    * NOTE: Server settings are stored at top of script

      jbh.sh --publish --stage "1/1/2015"
        Runs rcp/rsync to copy built site to a stage folder for the specified
        date on remote server
        * NOTE: Server settings are stored at top of script
        * NOTE: This command is designed to work with companion JBHCron.sh script
	
	  jbh.sh --list "*2015*"
	    Lists all posts that have '2015' in the file name
	
	  jbh.sh --move --draft "2015-01-01-blog-title.md"
	    Moves the matching file from draft to post folder

      jbh.sh --update "2015-01-01-blog-title.md" --date "2/1/2015"
      jbh.sh --update "2015-01-01-blog-title.md" --title "new title"
        Updates the given post's data. This is a distructive process that
        will rename the file, update values inside the header, and move
        any assets folders to match. You can only update one value at a time.
````

## Install

Copy the *jbh.sh* script into the base folder of the your Jekyll site.

Open the script with your editor of choice and there are several settings you
will need to setup for publishing to your remote server.

## How To Use

### Create a Post

````
	$ jbh.sh --new "Enter Your Post Title"
````

This will create a properly formatted Jekyll post file and a correlating asset
folder for storing photos and files that are part of your post.

````
	$ jbh.sh --new "Enter Your Post Title" "1/1/2015"	
````

Add a date to the --new command after the title and you can have a post created
for that specific date 

#### Drafts

If you wish to create a draft all you need to do is add a --draft after the
--new to indicate a draft.

````
	$ jbh.sh --new --draft "Enter Your Draft Title"
````

````
	$ jbh.sh --new --draft "Enter Your Draft Title" "1/1/2015"
````

### Listing Posts and Drafts

````
	$ jbh.sh --list
````

To list all posts just call the --list command

If you wish to list drafts add a --draft after the command

````
	$ jbh.sh --list --draft
````

#### Filtering

You can enter filters to help search for specific posts

````
	$ jbh.sh --list "*2015*"
````

This example would list all posts that match \*2015\*

### Moving Posts & Drafts

Drafts are used to create new blog posts that are not published until you are
ready but can be built or served locally.

When you are ready to publish a draft you need to move it from the draft folder
to the post folder to be included in the build process.

JBH provides a basic move command to do this for you.

````
	$ jbh.sh --move --draft "2015-01-01-post-title.md"
````

This will move the posts file from the draft to post folder.

If you need remove a published post you can also use the move command to do this

````
	$ jbh.sh --move --post "2015-01-01-post-title.md"
````

This will move the matching post file from the post folder to the draft folder.

### Updating Title or Date of Posts & Drafts 

The update command allows you to change the title or date of an existing post.

````
    $ jbh.sh --update "2015-01-01-blog-title.md" --date "2/1/2015"
````

````
	$ jbh.sh --update "2015-01-01-blog-title.md" --title "New title"
````

This is a destructive process that will edit the post file contents, change the
filename and move any contents in asset directories to new locations.

### Build The Site

````
	$ jbh.sh --build
````

This runs the Jekyll build to update the local copy of your site.

### Publish To Your Web Server

````
	$ jbh.sh --publish
````

### Cleaning The Site Folder

Sometimes the Jekyll build and server process will may run into issues when it
builds your site and the contents do not get updated correctly.

There is an easy fix to clean out the site folder so a fresh build will generate
all new files.

````
	$ jbh.sh --clean
````

This pushes the changes via scp or rsync to your remote server

## Compatibility / Reporting Bugs & Issues

JBH is developed and tested on Windows 10 using Git Bash from an install of Git
1.9.5

It has not be tested on other platforms. 

If you find a bug or issue please create an issue and include details about the
environment you are using.

## Change Log

See the history in [CHANGELOG.md](CHANGELOG.md)

## License

JBH is license under the [Apache 2.0 License][LICENSE]

