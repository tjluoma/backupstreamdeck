#!/usr/bin/env zsh -f
# Purpose: Backup the Application Support folder and plist for Stream Deck
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2020-09-27

	# What FOLDER do you want the backup files to be saved to? You can/should change this
	# unless the desktop is OK with you
BACKUP_TO="$HOME/Desktop"


################################################################################
########
########		You should not need to edit anything below this.
########
################################################################################

NAME="$0:t:r"

if [[ -e "$HOME/.path" ]]
then
	source "$HOME/.path"
else
	PATH='/usr/local/scripts:/usr/local/di:/usr/local/sbin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:'
fi

##########################################################################################


if [ ! -d "$BACKUP_TO" -a -d "$HOME/Desktop" ]
then
		# if the backup directory does not exist but Desktop does, use Desktop
	BACKUP_TO="$HOME/Desktop"
elif [ ! -d "$BACKUP_TO" -a -d "$HOME" ]
then
		# if the backup directory does not exist but Home does, use Home
	BACKUP_TO="$HOME"
fi

##########################################################################################

DIR="$HOME/Library/Application Support/com.elgato.StreamDeck"

if [[ ! -d "$DIR" ]]
then
	echo "${NAME} '$DIR' does not exist."
	exit 0
fi
	# yes I know about 'chroot' in `tar` but I like using `cd` better
	# in zsh '$DIR:h' is the same as `dirname "$DIR"`
cd "$DIR:h"

##########################################################################################

zmodload zsh/datetime

function timestamp { strftime "%Y-%m-%d--%H.%M.%S" "$EPOCHSECONDS" }

TIME=$(timestamp)

PLIST_BACKUP="${BACKUP_TO}/com.elgato.StreamDeck.${TIME}.plist"

	# Let's also backup "$HOME/Library/Preferences/com.elgato.StreamDeck.plist"
	# with the same timestamp as the other
defaults export com.elgato.StreamDeck "$PLIST_BACKUP"

##########################################################################################

if (( $+commands[xz] ))
then
		# xz is an extremely good compression tool, but it is not installed
		# on macOS by default. But if it is, we'll use it.

	FILENAME="${BACKUP_TO}/com.elgato.StreamDeck.${TIME}.tar.xz"

	echo "$NAME at `timestamp`: Creating '$FILENAME'..."

	tar --options='xz:compression-level=9' --xz -c -f "$FILENAME" "$DIR:t"

else
		# if 'xz' is not installed, we'll use 'bzip2' which is still good.

	FILENAME="${BACKUP_TO}/com.elgato.StreamDeck.${TIME}.tar.bz2"

	echo "$NAME at `timestamp`: Creating '$FILENAME'..."

	tar --create --bzip2 --file "$FILENAME" "$DIR:t"

fi

EXIT="$?"

if [ "$EXIT" = "0" ]
then

	echo "$NAME: Finished successfully at `timestamp`. Files are:\n${FILENAME}\n${PLIST_BACKUP}"

	exit 0

else

	ERROR_LOG="$BACKUP_TO/$NAME.Error-Log.txt"

	echo "$0 at `timestamp`: the `tar` command failed with an exit code equal to '$EXIT' (should be zero)." | tee -a "$ERROR_LOG"

	exit 1

fi

	# we should never get here, but you never know.
exit 0
#EOF
