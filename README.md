# backupstreamdeck

Mac shell script to backup Stream Deck configuration files

This script backs up two things:

```text
	"$HOME/Library/Preferences/com.elgato.StreamDeck.plist"

	"$HOME/Library/Application Support/com.elgato.StreamDeck/"
```

The first is the preferences file that the app uses.

The second includes all of the custom profiles that you have, most likely, worked very hard to hand-craft and personalize. (Those are in `"$HOME/Library/Application Support/com.elgato.StreamDeck/ProfilesV2/"`.)

## Customization

`BACKUP_TO="$HOME/Desktop"`

## How to Run

I recommend downloading `backupstreamdeck.sh` and moving it to `/usr/local/bin/` and then making it executable:

```text
	chmod 755 /usr/local/bin/backupstreamdeck.sh
```

If you have never installed any other Unix utilities you may need to create `/usr/local/bin/` using:

```text
	sudo mkdir -p /usr/local/bin/

	sudo chown "$LOGNAME" /usr/local/bin/
```

Once installed, you can run the command any time by entering `backupstreamdeck.sh` in Terminal. But, of course, I recommend that you automate this, because how likely is it that you will remember to do that?

### Keyboard Maestro and `launchd`

I have a [Keyboard Maestro](https://www.keyboardmaestro.com/main/) macro which runs this script every time the Stream Deck app quits.

However, I sometimes go a long time without quitting the app or rebooting my Mac, so I decided to have an automated backup that runs: 1) whenever I log in to my Mac and 2) every 24 hours after that.

To do that, I use `launchd` which is a built-in part of macOS to run things at certain times.

If you want to do this, download the file `com.tjluoma.backupstreamdeck.plist` and save it to `"$HOME/Library/LaunchAgents/"` (you _may_ need to created that folder).

***Note:*** When you download the file, make sure that your web browser does not change the extension. It _must_ end in `.plist` or else it will not work.

Once you have it in the right place, you need to tell `launchd` to "load" the new file. Copy/paste this command into Terminal:

`launchctl load "$HOME/Library/LaunchAgents/com.tjluoma.backupstreamdeck.plist"`

and hit <kbd>Enter</kbd>. If you don’t see anything, that means it worked. If you get an error message, make sure the file name is correct and try again. (Also make sure that you are using straight &quot; and not “smart” or “curly” quotes.)

### What if I want to back it up more or less often using `launchd` ?

You can change the time between backups by editing this part of the `com.tjluoma.backupstreamdeck.plist` file:

```text
	<key>StartInterval</key>
	<integer>86400</integer>
```

The `86400` is the number of seconds in 24 hours. If you set it to `3600` then it would back up every hour. If you set it to `21600` it would back up every 6 hours. And so on.

If you edit the file _after_ you load it, you will need to unload it:

`launchctl unload "$HOME/Library/LaunchAgents/com.tjluoma.backupstreamdeck.plist"`

and then load it again:

`launchctl load "$HOME/Library/LaunchAgents/com.tjluoma.backupstreamdeck.plist"`

***Note!*** If you do edit the `com.tjluoma.backupstreamdeck.plist` file, be sure you are using a text editor such as TextEdit or BBEdit, not Pages, Microsoft Word, etc. Actually, I highly recommend the excellent app [LaunchControl](https://www.soma-zone.com/LaunchControl/) for managing `launchd` plists. It will even show you the "translation" of seconds to minutes/hours/etc, and it will help you load/reload the `.plist` file when needed.

## How to restore

If you want to move these files to another computer or if you need to use them to restore a "corrupted" installation, step number one is to ***make 100% sure that the Stream Deck app is not running.***

Trying to replace these files while the app is running is a terrible idea, akin to trying to replace the chain on your bicycle as you are riding your bicycle. Sure, it _might_ be OK, but odds are good that it will not be OK.

### To Use the Backup plist

0. Make sure the app is not running.

1. Go to `~/Library/Preferences/`

2. If there is an existing `com.elgato.StreamDeck.plist` file, rename it to something like `com.elgato.StreamDeck.plist.OLD` and move it somewhere like the Desktop.

3. Copy the `.plist` file you _want_ to use to  `~/Library/Preferences/` and make sure it is named `com.elgato.StreamDeck.plist`

### To Use the Backup Preferences Folder

0. Make sure the app is not running.

1. Go to `~/Library/Application Support`

2. If there is an existing `com.elgato.StreamDeck` folder, rename it to something like `com.elgato.StreamDeck.OLD` and move it to the Desktop or somewhere else.

3. Uncompress the backup file, and rename it to `com.elgato.StreamDeck`


## No Warranty Expressed or Implied

Use entirely at your own risk.

This works… as far as I know… and should definitely not reformat your hard drive and post your taxes and nude selfies to the Dark Web, but if it does that _or anything else_, well, as the man said…

!["It's not my fault."](https://raw.githubusercontent.com/tjluoma/backupstreamdeck/main/img/han.jpg)

See [License](LICENSE.txt) for complete details about my complete lack of culpability and responsibility.


