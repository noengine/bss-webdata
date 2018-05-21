drop database if exists beverle1_logstest;
create database beverle1_logstest;
grant all on beverle1_logstest.* to 'beverle1_robot'@'localhost' identified by 'XXXXXXXX';
use beverle1_logstest;
#source schema.sql;
source beverle1_bssdata.sql;
