#! /bin/bash
#
# Name: zimbra 
#
# Checks zimbra activity.
#
# Author: Giovanni Antonio Mantelli 
#
# Version: 1.0
#
 
zimbraver="8.0.6"
rval=0
data=$(date +%s)
file="/etc/zabbix/tmp/status.txt"
FILEMAIL="/etc/zabbix/tmp/contas.txt"

function usage()
{
    echo "zimbra version: $zimbraver"
    echo "usage:"
    echo "    $0 antispam "
    echo "    $0 antivirus"
    echo "    $0 ldap     "
    echo "    $0 logger   "
    echo "    $0 mailbox  "
    echo "    $0 memcached"
    echo "    $0 mta      "
    echo "    $0 opendkim "
    echo "    $0 proxy    "
    echo "    $0 snmp     "
    echo "    $0 spell    "
    echo "    $0 stats    "
    echo "    $0 zmconfigd"
    echo "    $0 contas"
    echo "    $0 licenses"
    echo "    $0 licenses_expired"
    echo "    $0 queue"
    echo "    $0 msg_received"
    echo "    $0 msg_delivered"

}

########
# Main #
########


if [[ $# != 1 ]];then
    usage
    echo
    exit 1
fi

# Pegando valor do primeiro parametro
check=$1

if [ $check = "contas" ]; then
  totCount=$(cat $FILEMAIL)
  echo $totCount
  exit 
fi

if [ $check = "licenses" ]; then
  ZMLICENSE=$(sudo -u zimbra /opt/zimbra/bin/zmlicense --check)
  if [ "$ZMLICENSE" = "license is OK" ]; then 
	echo "1"; 
	exit
  else 
        echo "0"; 
  fi
	exit
fi

if [ $check = "licenses_expired" ]; then
  LICENCA=$(/opt/zimbra/bin/zmlicense --print | grep ValidUntil | awk -F"=" '{print $2}' | awk '{print substr($0,1,8)}')
  HOJE=$(date +%Y%m%d)
  FALTAM=$(expr $LICENCA - $HOJE)
  echo $FALTAM
  exit
fi


if [ $check = "queue" ]; then
	RETURN=$(/opt/zimbra/postfix/sbin/mailq)
	if [ "$RETURN" == "Mail queue is empty" ]; then
		RETURN=0
		echo "0"
		exit
	else
		RETURN=$(/opt/zimbra/postfix/sbin/mailq | grep Requests | awk -F"Requests" ' { print $1 }' | awk -F"in " '{ print $2 }')
		echo "$RETURN"
		exit
	fi
fi

if [ $check = "msg_received" ]; then
	RETURN=$(/opt/zimbra/libexec/zmdailyreport | grep "   received$" | awk '{print $1}')
	echo "$RETURN"
	exit
fi

if [ $check = "msg_delivered" ]; then
	RETURN=$(/opt/zimbra/libexec/zmdailyreport | grep "   delivered$" | awk '{print $1}')
	echo "$RETURN"
	exit
fi




#sudo -u zimbra /opt/zimbra/bin/zmcontrol status > $file
#sleep 15 
status=$(cat $file | grep $check | awk '{ print $2 }')
[ -z $status ] && sleep 5; status=$(cat $file | grep $check | awk '{ print $2 }')
	
# Verificando status
if [[ $status != "Running" ]]; then
	echo 0
else
	echo 1
fi
