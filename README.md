# bss-webdata
Scripts to upload logkeeping db to web hosting

## Setup
### Virtual Machine
* Latest Ubuntu Server (tested with 16.04) and the following packages installed:
> apt-get install -y openssh-client php7.0-cli php7.0-common php7.0-curl php7.0-mysql php7.0-imap php7.0-zip
> apt-get install -y mdbtools zip python git
* Set up a new MySQL DB (DBNAME) and user (DBUSER) - refer **initialise_database.sql** and change the password! (DBPASS)
* Create the tables in the new database - refer **beverle1_bssdata.sql**
### Web Hosting Service
* Enable SSH at the web hosting end
* Generate an RSA key for authentication
> ssh-keygen -b 2048 -t rsa -C "your comment here" -f KEYFILE
* Configure web host to permit passwordless login using generated key (SSHHOST, SSHUSER, SSHKEY)
* Create a new MySQL database and user/password - make a **$HOME/.my.cnf** file to enable passwordless login
* Create a new email account (MAILUSER, MAILHOST, MAILPASS) to enable delivery of weekly zip file

## Operation
TBA
