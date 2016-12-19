#!/bin/bash



RBL=$(cat /etc/zabbix/externalscripts/rbl_list.txt)

W=$( echo ${1} | cut -d. -f1 )
X=$( echo ${1} | cut -d. -f2 )
Y=$( echo ${1} | cut -d. -f3 )
Z=$( echo ${1} | cut -d. -f4 )

STATUS=0
> /tmp/rbl.lst

echo $Z.$Y.$X.$W

for i in $RBL
do
    RESULT=$( host -t a $Z.$Y.$X.$W.$i 2>&1 )
    if [ $? -eq 0 ]; then
        STATUS=$(expr $STATUS + 1)
	if [ $STATUS -gt 0 ]; then
		echo "$1 listed in $i" >> /tmp/rbl.lst
	fi
    fi
done

if [ $STATUS -lt 1 ]; then
    echo 0
else
    echo $STATUS
fi
