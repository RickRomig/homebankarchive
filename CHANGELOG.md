# Changelog

### 17 May 2019
1. Changed the temporary file creation and error checking to get the error status directly instead of indirectly.
```
# Old code:
ref_file=$(mktemp)
if "$?" -ne "0" ]; then
  echo "Error: Failed to create reference file." >&2
  exit 1
fi
# New code:
if ! ref_file=$(mktemp)
then
  echo "Error: Failed to create reference file." >&2
  exit 1
fi
```
2. Changed error checking on for changing the timestamp for the temporary file.
```
# Old code:
touch -t $rd $ref_file
if [ "$?" -ne "0" ]; then
  echo "Error: Could not change the timestamp of the reference file." >&2
  exit 1
fi
# New code:
if ! touch -t "$rd" "$ref_file"
then
  echo "Error: Could not change the timestamp of the reference file." >&2
  exit 1
fi
```

3. Changed the temporary directory creation and error checking to get the error status directly instead of indirectly.
```
# Old code:
backup_dir=$(mktemp -d)
if [ "$?" -ne "0" ]; then
  echo "Error: Failed to create temporary directory." >&2
  exit 1
fi
# New code:
if ! backup_dir=$(mktemp -d)
then
  echo "Error: Failed to create temporary directory." >&2
  exit 1
fi
```

### 30 April 2019 Added
1. Changed the code that creates the temporary file to display an error message if the file creation fails.
```
# Old code:
ref_file=$(mktemp) || exit 1
# New code:
ref_file=$(mktemp)
if "$?" -ne "0" ]; then
  echo "Error: Failed to create reference file." >&2
  exit 1
fi
```
2. Changed the code that creates the temporary directory to display an error message if the directory creation fails.
```
# Old cde:
backup_dir=$(mktemp -d) || exit 1
# New code:
backup_dir=$(mktemp -d)
if [ "$?" -ne "0" ]; then
  echo "Error: Failed to create temporary directory." >&2
  exit 1
fi
```

### 30 April 2018
1. Removed the echo command from the code that created the temporary file because it was causing the script to exit.
```
# Old code:
ref_file=$(mktemp) || echo "Error: Reference file not created." >&2; exit 1
New code:
ref_file=$(mktemp) || exit 1
```
2. Added code to create a temporary directory to hold the backup files to be archived.
```
backup_dir=$(mktemp -d) || exit 1
```
3. Changed the find command that copies the backup files to be archived to the created temporary directory instead of the backup folder.
```
# Old code:
find ./ -maxdepth 1 -type f -iname "*.bak" -not -newer $ref_file -exec mv '{}' backup/ \;
# New code:
find ./ -maxdepth 1 -type f -iname "*.bak" -not -newer $ref_file -exec mv '{}' $backup_dir/ \;
```
4. Removed the code that created the backup folder if it didn't exist.
```
# Old code:
[ -d ~/Documents/HomeBank/backup ] || mkdir -p ~/Documents/HomeBank/backup
```
5. Updated cleanup function to also remove the temporary directory upon exit.
```
# Old code:
cleanup () {
  if [ -f "$ref_file" ]; then
    rm -f "$ref_file"
  fi
}
# New code:
cleanup () {
  [ -f "$ref_file" ] && rm -f "$ref_file"
  [ -d "$backup_dir" ] && rm -rf "$backup_dir"
}
```

### 29 April 2019
1. Re-coded the creation of the temporary reference file to use mktemp instead of usng a static file name. Also updated error messages for failure of file creation or changing the timestamp.
```
# Old code:
ref_file="/tmp/homebank.tmp"
touch -t $rd $ref_file
if [ "$?" -ne "0" ]; then
  echo "Error: Could not create $ref_file">&2
  exit 1
fi
# New code:
ref_file=$(mktemp) || echo "Error: Reference file not created." >&2; exit 1
touch -t $rd $ref_file
if [ "$?" -ne "0" ]; then
  echo "Error: Could not create correct timestamp for reference file." >&2
  exit 1
fi
```
2. Added error message and exit for invalid arguments.
```
# New code:
# Check for invalid argument
if [ -n "$1" ]; then
  echo "Error: Invalid argument. Try 'hb-archive --help' for more info." >&2
  exit 1
fi
```

### 21 April 2019
1. Removed `-n1` optinn from read command so there would be a newline between the response and the next displayed line. The `-n1` accepts the first character received without waiting for a newline character.
```
# old code:
read -n1 -p "Do you still wish to archive backup files for $prevmonth? [yN]" yn
# new code:
read -p "Do you still wish to archive backup files for $prevmonth? [yN]" yn
```
2. Added `$'\n'$` to the line to add a newline to the displayed text to separate it from the read prompt.
```
# old code:
echo "Archive operation canceled."
# new code:
echo $'\n'$"Archive operation canceled."
```

### 19 April 2018
1. Corrected the comment for initializing the runflag variable to match the assigned value.

### 7 April 2019
1. Fixed an error in the cleanup function which prevented the temporary reference file from being deleted. Changed `rm -f "ref_file"` to `'rm -f "$ref_file"`.
2. Changed the method to fetch the previous month so it's not dependent upon a specific number of days in the past.
```
# Old code:
prevmonth=$(date --date="40 days ago" +"%B %Y")
# New code:
prevmonth=$(date --date="-1 month" +"%B %Y")
```
3. Changed the method to fetch the previous month for the archive file name so it's not dependent upon a specific number of days in the past.
```
# Old code:
hbarchive=$(date --date="40 days ago" +"%Y-%m")
hbarchive+="-backup.zip"
# Ndw code:
hbarchive=$(date --date="-1 month" +"%Y-%m")
hbarchive+="-backup.zip"
```

### 3 April 2019
1. Created new variables to contain the script's title and the reference file name, replacing all hard coded references to them.
```
ref_file="/tmp/homebank.tmp"
```
2. Added a trap statement to clean up the temporary reference file upon exit and a function to do the cleanup.
```
trap cleanup EXIT
# Cleanup tmp file after exit
cleanup () {
  if [ -f "$ref_file" ]; then
    rm -f "ref_file"
  fi
}
```
3. Changed conditional statements to use extended integer test when testing runflag status and date.
```
# Old code:
if [ "$runflag" -eq "1" ] && [ "$today" -lt "21" ]; then
  .....
elif [ "$runflag" -eq "1" ]; then
  .....
fi
# New code:
if (( runflag == 1 )) && (( today < 21 )); then
  .....
elif (( runflag == 1 )); then
  .....
fi
```
4. Changed the conditional statements for creating archive and backup directories so if the tests for the existence of the directories fail, they are created.
```
# Old code:
# Create the backup and archive folders if they don't already exist
[ ! -d ~/Documents/HomeBank/backup ] && mkdir -p ~/Documents/HomeBank/backup
[ ! -d ~/Documents/HomeBank/archive ] && mkdir -p ~/Documents/HomeBank/archive
# New code:
# Create the backup and archive folders if they don't already exist
[ -d ~/Documents/HomeBank/backup ] || mkdir -p ~/Documents/HomeBank/backup
[ -d ~/Documents/HomeBank/archive ] || mkdir -p ~/Documents/HomeBank/archive
```

5. Added the relative path to both archive and backup directories in the zip command, eliminating the need to cd in to and out of the backup directory.
```
# Old code:
cd backup/
echo "Creating $hbarchive ..."
zip -m ../archive/$hbarchive *.bak
cd ..
# New code:
echo "Creating $hbarchive ..."
zip -m archive/$hbarchive backup/*.bak
```
