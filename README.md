# HomeBank Archive

### Description
1. HomeBank Archive (`hb-archive`) is a script to create a monthly archive of backup files created by HomeBank. I've used this script with HomeBank version 5.2.3 but it should work with any version of the program that creates a daily backup with the .bak extension on Ubuntu/Debian-based Linux systems.
2. The script is intended to be run on the last day of the month to archive the previous month's backup files. For instance, running the script on March 31 will archive February's backup files. However, the script can be forced to run as early as the 21st of the month.
3. Backup (\*.bak) files in the the `$HOME/Documents/HomeBank` directory with a timestamp earlier than 12:01 AM on the first day of the current calendar month are moved to a backup folder and a compressed archive is created in the archive folder. The archive file name takes the format `YYYY-MM--backup.zip`. Once the archive file is created, the .bak files in the backup folder are deleted. If there are no available backup files in the backup folder, no archive file is created and the script exits.
4. The archive and backup folders will be created in `$HOME/Documents/HomeBank` if they don't already exist.
5. This script is licensed under the GNU General Public License, version 2.0.

### Installation
Download [homebankarchive-master.zip](https://github.com/RickRomig/homebankarchive/archive/master.zip) and extract it. Copy the script to a folder in your PATH, `$HOME/bin` is recommended. It can be placed in `/usr/local/bin`, however, it could be run by any user on the system.

### Running the Script
1. Run the script from a terminal.
```
hb-archive
# Or, if the script is in a directory in your PATH:
./hb-archive
```
2. The script does not require root (sudo) access. No command line arguments are necessary except to bring up the help page.
```
$ hb-archive --help
# OR
$ hb-archive -h
```
3. Any other arguments will result in an error message and the script will exit.

### Feedback
Feel free to contact me with comments and suggestions. I can be reached through my blog, Twitter, and email.
* [GitHub](https://github.com/RickRomig/homebankarchive)
* [Rick's Tech Stuff](https://ricktech.wordpress.com)
* [Twitter (@ludditegeek)](https://twitter.com/ludditegeek)
* Email: <rick.romig@gmail.com> or <rb_romig@twc.com>

Richard Romig
30 April 2019

### DISCLAIMER
THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL I BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS AND SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
