
#!/bin/sh
# MySQL backup script
# ---------------------------------------------------------------------
#Author: Faisal Khan

### System Setup ###
DIRS="/home/faisalkhan/Desktop/Script/log/"
BACKUP="/home/faisalkhan/Desktop/Script/data"
NOW=$(date +"%d-%m-%Y")
FILE="backup-$NOW.tar.gz"


### MySQL Setup ###
#Here mention the username for mysql backup
MUSER="backupuser"
#Here Password
MPASS="password"
#Mention the IP of Mysql Server
MHOST="10.0.0.10"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"
#Here mention the Database name which is required to backup
db="DATABASE"

### FTP server Setup ###
#Mention the directory here of FTP location where the backup will be uploaded on FTP Server
FTPMD="dir/dirbackup"
#mention the root directory of FTP Server
FTPD="Database"
#Login username of FTP
FTPU="ftpuser"
#password
FTPP="password"
#ftp server IP address
FTPS="10.0.0.11"
NCFTP="$(which ncftpput)"

FILE=$BACKUP/mysql-$db.$NOW.gz
echo "Connecting My Sql"
$MYSQLDUMP -u $MUSER -p$MPASS -h $MHOST --skip-lock-tables $db | $GZIP -9 > $FILE

### Dump backup using FTP ###
#Start FTP backup using ncftp
echo "DONE Connecting FTP"
ncftp -u $FTPU -p $FTPP $FTPS <<EOF
cd $FTPMD

mkdir $NOW
cd $NOW
lcd $BACKUP
mput *
quit
EOF
echo "DONE Connecting FTP and upload to"
### Find out if ftp backup failed or not ###
if [ "$?" == "0" ] 
then
rm -r $BACKUP/*
echo "********************No error*******************"
else
lcd $DIRS
echo "Date: $(date)">> $NOW.log
echo "Hostname: $(hostname)" >> $NOW.log
echo "Backup upload failed" >> $NOW.log
fi
