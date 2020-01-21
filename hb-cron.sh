#!/bin/sh
###############################################################################
# Script Name  : hb-cron.sh
# Description  : Create HomeBank archive on the first of the month.
# Dependencies : date, zip
# Arguments    : none
# Author       : Richard B. Romig, 21 January 2020
# Email        : rick.romig@gmail.com
# Comments     : Run from crontab
#              : Version 1.0.0, Updated 21 Jan 2020
# TODO (rick)  :
###############################################################################

HB_DIR=$HOME"/Documents/HomeBank"
# Set reference date to the first day of the previous month
REF_DATE=$(date -d "$(date +%Y-%m-01) - 1 month" +%m%d%Y)
# Create filename for the archive file for files 2 months prior
ARCHIVE=$(date -d "$(date +%Y-%m-01) - 2 months" +%Y-%m)-backup.zip
# Create monthly archive of backup files from 2 months prior
/usr/bin/zip -mtt "$REF_DATE" "$HB_DIR/archive/$ARCHIVE" "$HB_DIR"/*.bak 2>/dev/null
exit
