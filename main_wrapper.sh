#!/bin/bash
# main_wrapper.sh
# This shell script is the one which controls the container's activity
# This script is used to process an MSAccess 2016 database
# and load selected table data into a web-hosted MySQL database
# for reporting purposes
#set -x

# Check required environment variables
misvar () {
  echo "ERROR: $1 Environment variable missing - exiting"
  exit 1
}
if [ ! -v SSHKEY ];  then misvar SSHKEY;fi
if [ ! -v SSHUSER ]; then misvar SSHUSER;fi
if [ ! -v SSHHOST ]; then misvar SSHHOST;fi
if [ ! -v MAILUSER ];then misvar MAILUSER;fi
if [ ! -v MAILPASS ];then misvar MAILPASS;fi
if [ ! -v MAILHOST ];then misvar MAILHOST;fi
if [ ! -v DBNAME ];then misvar DBNAME;fi
if [ ! -v DBUSER ];then misvar DBUSER;fi
if [ ! -v DBPASS ];then misvar DBPASS;fi

# hostname lookups
for chkhost in $SSHHOST $MAILHOST
do
  getent hosts $chkhost
  if [ $? -ne 0 ]
    then echo "ERROR: cannot resolve hostname $chkhost - exiting"
    exit 1
  fi
done

# start looping here
#while true
#do

# collect incoming data via email attachment
/usr/bin/php imapfetch.php

# only do if attachment presents itself
if [ -f BSSDATA*.zip ]
then
  unzip -o BSSDATA*.zip && rm BSSDATA*.zip
  # check ACCDB file
  if [ -f BSSDATA.accdb ]
  then
    # sanity test the ACCDB file
    # list of required tables
    chktable () {
      mdb-tables -1 BSSDATA.accdb | grep "$1" >/dev/null
      if [ $? -ne 0 ];then echo "WARNING: $1 table missing";fi
      ROWS=`mdb-export -H BSSDATA.accdb "$1" | wc -l`
      if [ $ROWS -lt 2 ];then echo "WARNING: $1 table has $ROWS rows";fi
    }
    chktable "Members"
    chktable "Membership types"
    chktable "Flight log"
    chktable "Member transactions"
    chktable "Glider List"
    chktable "Tug List"
  fi
  # set up mysql connection
  # ssh -f -i $SSHKEY -l $SSHUSER -L 3306:localhost:3306 -o StrictHostKeyChecking=no $SSHHOST "sleep infinity"
  # copy data into mysql
  /usr/bin/php accdbtomysql.php
  if [ $? -ne 0 ]
    then echo "ERROR: running accdbtomysql"
    exit 1
  fi
  # pkill ssh tunnel? only if inside docker otherwise...oops
  # mysqldump local db (overwrite preexisting with >)
  mysqldump -u $DBUSER --single-transaction --password=$DBPASS $DBNAME | \
  sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' | gzip -9 > bssdata.sql.gz
  # sftp dumpfile to web host
  echo "cd /home/beverle1/tmp
        -rm bssdata.sql.gz
        put bssdata.sql.gz
        quit" | sftp -i $SSHKEY -b - $SSHUSER@$SSHHOST
  # remote execution of SQL on web host
  # authentication is by $HOME/.my.cnf file
  ssh -i $SSHKEY -l $SSHUSER -o StrictHostKeyChecking=no $SSHHOST "gunzip -c /home/beverle1/tmp/bssdata.sql.gz|mysql -u beverle1_bssdata beverle1_bssdata"
fi

#sleep 20
#end main loop
#done
