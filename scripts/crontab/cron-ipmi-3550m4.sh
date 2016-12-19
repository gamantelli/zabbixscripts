#!/bin/bash

# Variaveis
	TEMP_DIR="/tmp"
	

/usr/bin/ipmitool -H 172.28.11.111 -U USERID -P 'PASSW0RD' sdr > $TEMP_DIR/s1-fln-flex-esxi01.lst 
/usr/bin/ipmitool -H 172.28.11.112 -U USERID -P 'PASSW0RD' sdr > $TEMP_DIR/s1-fln-flex-esxi02.lst 
/usr/bin/ipmitool -H 172.28.11.113 -U USERID -P 'PASSW0RD' sdr > $TEMP_DIR/s1-fln-flex-esxi03.lst 

/usr/bin/ipmitool -H 172.28.11.114 -U USERID -P 'PASSW0RD' sdr > $TEMP_DIR/s2-fln-flex-esxi01.lst 
/usr/bin/ipmitool -H 172.28.11.115 -U USERID -P 'PASSW0RD' sdr > $TEMP_DIR/s2-fln-flex-esxi02.lst 
/usr/bin/ipmitool -H 172.28.11.116 -U USERID -P 'PASSW0RD' sdr > $TEMP_DIR/s2-fln-flex-esxi03.lst 
