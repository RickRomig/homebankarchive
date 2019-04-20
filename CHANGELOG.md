# Changelog
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
