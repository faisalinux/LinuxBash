#!/bin/sh
# MySQL backup script ..... Faisal Khan
# ---------------------------------------------------------------------

### System Setup ###
BACKUP="/home/tmp"
NOW=$(date +"%d-%m-%Y--%T")
FILE="backup-$NOW.tar.gz"


### MySQL Setup ###
MUSER="backupuser"
MPASS="backup789"
MHOST="10.0.0.30"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"
db="ird"

### FTP server Setup ###
FTPMD="backupuser/dms/database"
FTPU="backupuser"
FTPP="789Khi"
FTPS="10.0.0.57"
NCFTP="$(which ncftpput)"

##MYSQL Backup start##
FILE=$BACKUP/mysql-$db.$NOW.gz
$MYSQLDUMP -u $MUSER -p$MPASS -h $MHOST -P 3306 --skip-lock-tables $db | $GZIP -9 > $FILE

### Dump Backup using FTP ###
#Start FTP backup using ncftp
ncftp -u $FTPU -p $FTPP $FTPS <<EOF
cd $FTPMD
mkdir $NOW
cd $NOW
lcd $BACKUP
mput *
quit
EOF

## Removing backup from sript server -not from FTP##
rm -r $BACKUP/*

ssh root@10.0.0.30 '/home/FL_Script.sh'
