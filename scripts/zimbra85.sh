#! /bin/bash
#
# Name: zimbra 
#
# Checks zimbra activity.
#
# Author: Giovanni Antonio Mantelli 
#
# Version: 2.0
#
 
zimbraver="8.5.0"
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
    echo "    $0 queue"
    echo "    $0 msg_received"
    echo "    $0 msg_delivered"
}


function checkStatus()
{
	if [[ $status != "Running" ]]; then
		echo 0
	else
		echo 1
	fi
}

########
# Main #
########

# Se parametro diferente de 1 (um), aborta
if [[ $# != 1 ]];then
    usage
    echo
    exit 1
fi

# Pegando valor do primeiro parametro
check=$1

# Verificacoes com CASE:
case $check in
	"contas")
		totCount=$(cat $FILEMAIL)
		echo $totCount
	;;

	"queue")
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
	;;

	"msg_received")
		RETURN=$(/opt/zimbra/libexec/zmdailyreport | grep "   received$" | awk '{print $1}')
		echo "$RETURN"
	;;

	"msg_delivered")
	        RETURN=$(/opt/zimbra/libexec/zmdailyreport | grep "   delivered$" | awk '{print $1}')
	        echo "$RETURN"
	;;

	"servicewebapp")
		status=$(cat $file | grep "service "  | awk '{print $3}')
		checkStatus
	;;

	"zimletwebapp")
		status=$(cat $file | grep "zimlet "  | awk '{print $3}')
		checkStatus
	;;

	"zimbraAdminwebapp")
		status=$(cat $file | grep "zimbraAdmin "  | awk '{print $3}')
		checkStatus
	;;
	
	"zimbrawebapp")
		status=$(cat $file | grep "zimbra "  | awk '{print $3}')
		checkStatus
	;;

	*)
		status=$(cat $file | grep $check | awk '{ print $2 }')
		[ -z $status ] && sleep 5; status=$(cat $file | grep $check | awk '{ print $2 }')
		checkStatus

	;;
esac
