#!/bin/bash

## Giovanni A. Mantelli 
## 2016-08-09
## http://blog.penumbra.be/2010/02/zabbix-monitor-dns-blacklists/


# Site 
#	http://reverseip.domaintools.com

# Site com variavel:
#   	http://reverseip.domaintools.com/search/?q=200.194.232.124


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
