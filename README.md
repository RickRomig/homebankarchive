# HomeBank Archive

### Description
1. HomeBank Archive (`hb-archive`) is a script to create a monthly archive of backup files created by HomeBank. I've used this script with HomeBank version 5.2.3 and later but it should work with any version of the program that creates a daily backup with the .bak extension on Ubuntu/Debian-based Linux systems.
2. The script is intended to be run on the last day of the month to archive the previous month's backup files. For instance, running the script on March 31 will archive February's backup files. However, the script can be forced to run as early as the 21st of the month.
3. Should you forget to run the script at the end of the month, `hb-late` can be run to archive the backup files from two calendar months prior. For example, if you realize on October 1 that you forgot to run `hb-archive` at the end of September, `hb-late` will archive the August files. Alternatively, the backup files can be archived manually from the terminal:
```
cd ~/Documents/HomeBank
zip -mtt mm01yyyy archive/yyy-mm-backup.zip
```
  * The reference date is the first day of the previous month. For example, 06012019.
  * The date for the archive file is the year and month of the month preceding the previous month (2 calendar months). For example, 2019-05-backup.zip.
4. Backup (\*.bak) files in the the `$HOME/Documents/HomeBank` directory created before the first day of the current calendar month will be moved to a compressed archive for the preceding month in the archive folder. If there are no backup files meeting the criteria, no archive file will be created and the script will exit.
5. The archive folder will be created in `$HOME/Documents/HomeBank` if it doesn't already exist.
6. `hb-cron.sh` is a minimal version of `hb-late` intended to be run as a cron job scheduled by crontab. If you wish to automate the process of backing up the HomeBank backup files, I recommended running this script on the first of every month.
7. These scripts are licensed under the GNU General Public License, version 2.0.

### Installation
Download [homebankarchive-master.zip](https://github.com/RickRomig/homebankarchive/archive/master.zip) from my GitHub repository and extract it. Copy the script to a folder in your PATH; `$HOME/bin` is recommended. It can also be placed in `/usr/local/bin`, however, it could be run by any user on the system.

### Running the Script
1. Run the script from a terminal.
```
hb-archive
# Or, if the script is in a directory not in your PATH:
./hb-archive
```
2. The script does not require root (sudo) access. No command line arguments are necessary except to bring up the info page or the version information. Any other arguments will result in an error message and the script will exit.
```
$ hb-archive --info
$ hb-archive --version
```

### Feedback
Feel free to contact me with comments and suggestions. I can be reached through my blog, Twitter, and email.
* [GitHub](https://github.com/RickRomig/homebankarchive)
* [Rick's Tech Stuff](https://ricktech.wordpress.com)
* [Twitter (@ludditegeek)](https://twitter.com/ludditegeek)
* Email: <rick.romig@gmail.com> or <rb_romig@twc.com>

Richard Romig
21 January 2020

### DISCLAIMER
THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL I BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS AND SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
