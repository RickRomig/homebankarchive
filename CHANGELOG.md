# Changelog
### 21 January 2020
**hb-cron.sh v1.0.0**
1. Added script to run as a cron job from crontab to create a zipped archive of the backup files from two months prior. In my case I used crontab to schedule it to run on the first of every month.
2. The script is based on the hb-late script. Extraneous comments, variables, and echo statement were removed.
3. The script was also changed to run as a POSIX script, instead of BASH to run as a cron job.

### 11 December 2019
**hb-archive v1.1.8**
1. Modified the leapyear function return the result of the first conditinoal test that succeeds thus eliminating the ISLEAP variable.
```
# Old code:
leapyear()
{
    YEAR=$(date +"%Y")
    ISLEAP=1

    if [ $(( YEAR % 4 )) -ne 0 ] ; then
      :
    elif [ $(( YEAR % 400 )) -eq 0 ] ; then
      ISLEAP=0
    elif [ $(( YEAR % 100 )) -eq 0 ] ; then
      :
    else
      ISLEAP=0
    fi
    return "ISLEAP"
}
# New code:
leapyear()
{
    YEAR=$(date +"%Y")

    if [ $(( YEAR % 4 )) -ne 0 ] ; then
      return 1
    elif [ $(( YEAR % 400 )) -eq 0 ] ; then
      return 0
    elif [ $(( YEAR % 100 )) -eq 0 ] ; then
      return 1
    else
      return 0
    fi
}
```
2. Added usage instructions to be displayed if an option other than --info or --version is entered.
3. Edited hba_info and hba_version HereDoc functions so as not to alter syntax highlightng in the rest of the script.

### 20 October 2019
**hb-archive v1.1.6**
1. Replaced `$HOMEDIR` variable with `$HOME`.
2. Assigned variables using command substituion before making them read-only.

**hb-late v0.0.7**
1. Assigned variables using command substituion before making them read-only.

### 21 September 2019
**hb-late v.0.0.4**
1. Added a simple script to be used to archive HomeBank backup files when `hb-archive` was not run by the end of the month. Creates an achive for two months prior.
2. This script does not include the `hb-archive` date checking routines.

### 12 September 2019
**Version 1.1.4**
1. Changed return values in the leapyear function so 0 (TRUE) is returned if the current year is a leap year and 1 (FALSE) if it is not.
2. Adjusted the checkdate function to accommodate the changes in the leapyear function.
3. Moved the main variable declarations to the top of the script before the function delcarations.

### 27 August 2019
**Version 1.1.3**
1. Changed variable names to all capital letters.
2. In the checkdate function, renamed MONTH variable to CURMONTH to better describe it.
3. In the main execution block, added a new variable, CURDATE, to display the current date (day and full month) to display the current date.

### 21 August 2019
**Version 1.1.1**
1. Added `./` to line 229 to prevent file names beginning with dash from becoming options (not likely to happen but good coding practice)
```
# Old code:
if zip -mtt "$refdate" "archive/$hbarchive" *.bak 2>/dev/null
# New code:
if zip -mtt "$refdate" "archive/$hbarchive" ./*.bak 2>/dev/null
```
2. Added copyright information to hba_version().
3. Changed '--help' to '--info' in hba_info()

### 2 August 2019
1. Corrected a typo in line 186. The string should have begun with a back slash rather than a forward slash.
```
# Old code:
echo -e "/e[1;33mOnly '--info' and '--version' are acceptable arguments.\e[0m" >&2
# New code:
echo -e "\e[1;33mOnly '--info' and '--version' are acceptable arguments.\e[0m" >&2
```

### 14 Jul 2019
1. Eliminated the need for a temporary reference file and a temporary directory to hold files to be archived by changing the method used in executing the zip command. Now using the `-tt` option to move files created before the reference date. This change also elimiates the need for the trap commnad and the cleaup function.
```
# Old code:
zip -m "archive/$hbarchive" "$backup_dir/*.bak"
# New code:
if zip -mtt "$refdate" "archive/$hbarchive" *.bak 2>/dev/null
```
2. Changed the method to set the reference date so it can by used by `zip -mtt`.
```
# Old code:
# Set reference date to 12:01 AM on 1st day of the current month
rd=$(date +"%Y%m")
rd+="010001"
# New code:
# Set reference date to the first day of the current month
refdate=$(date -d "$(date +%Y-%m-01)" +%m%d%Y)
```
3. Changed the method to determine previous month.
```
# Old code:
prevmonth=$(date --date="-1 month" +"%B %Y")
# New code:
prevmonth=$(date -d "$(date +%Y-%m-01) - 1 day" +"%B %Y")
```
4. Changed method for naming previous month's archive file.
```
# Old code:
hbarchive=$(date --date="-1 month" +"%Y-%m")
hbarchive+="-backup.zip"
# New code:
hbarchive=$(date -d "$(date +%Y-%m-01) - 1 day" +%Y-%m)-backup.zip
```
5. Added a function to display version information and renamed the hba-help function to hba-info. Also changed the conditional statements that check arguments accordingly.
6. Added a function to determine whether the current year is a leap year. The function returns 0 for a non-leap year and 1 for a leap year.
7. Added a function that incorporates the routines to check the date and determine if the archive operation will execute. If the function returns 0, the archive is created. If it returns 1, the script has determined it is too early in the month, and if 2 is returned, the operation has been canceled by the user.
8. Added a find command to determine if there are backup files that ready for archiving. If no files for the previous month are found, an message is display and the script exits.

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

### 30 April 2019
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

3. Removed the echo command from the code that created the temporary file because it was causing the script to exit.
```
# Old code:
ref_file=$(mktemp) || echo "Error: Reference file not created." >&2; exit 1
New code:
ref_file=$(mktemp) || exit 1
```
4. Added code to create a temporary directory to hold the backup files to be archived.
```
backup_dir=$(mktemp -d) || exit 1
```
5. Changed the find command that copies the backup files to be archived to the created temporary directory instead of the backup folder.
```
# Old code:
find ./ -maxdepth 1 -type f -iname "*.bak" -not -newer $ref_file -exec mv '{}' backup/ \;
# New code:
find ./ -maxdepth 1 -type f -iname "*.bak" -not -newer $ref_file -exec mv '{}' $backup_dir/ \;
```
6. Removed the code that created the backup folder if it didn't exist.
```
# Old code:
[ -d ~/Documents/HomeBank/backup ] || mkdir -p ~/Documents/HomeBank/backup
```
7. Updated cleanup function to also remove the temporary directory upon exit.
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
