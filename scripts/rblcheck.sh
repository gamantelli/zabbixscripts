#!/bin/bash

## TomDV
## 2010-01-25
## http://blog.penumbra.be/2010/02/zabbix-monitor-dns-blacklists/

#cd /usr/share/zabbix/
#RBL="`cat rbl_list.txt`"

W=$( echo ${1} | cut -d. -f1 )
X=$( echo ${1} | cut -d. -f2 )
Y=$( echo ${1} | cut -d. -f3 )
Z=$( echo ${1} | cut -d. -f4 )

STATUS=0

    RESULT=$( host -t a $Z.$Y.$X.$W.$2 2>&1 )
    if [ $? -eq 0 ]
    then
        let "STATUS += 1"
    fi

if [ $STATUS -lt 1 ]
then
    echo 0
else
    echo $STATUS
fi
