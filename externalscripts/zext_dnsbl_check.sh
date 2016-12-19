#! /bin/sh

# Variaveis
	HOST=$1
	IP=$2
	RBLDNS=/etc/zabbix/externalscripts/zext_dnsbl.txt
	DEBUG=0

if [ "$DEBUG" -gt 0 ]
then
    exec 2>>/tmp/zext_dnsbl_check.log
    set -x
fi
shift

# Definindo o ip reverso do host
REV_IP=$(echo $IP | sed -r 's/([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)/\4.\3.\2.\1/')


	RESULT=0
	for DNSBL in `cat $RBLDNS`; do
	    if host -W 1 -t a $REV_IP.$DNSBL > /tmp/zext_dnsbl_check.log; then
	    #if host -W 1 -t a $REV_IP.$DNSBL >/dev/null 2>&1; then
		echo $HOST zext_dnsbl_blacklists $IP blacklisted on $DNSBL
		host -t txt $REV_IP.$DNSBL | sed "s/^/$HOST zext_dnsbl_details /" 
		RESULT=`expr $RESULT + 1`
	    fi
	done

	echo $RESULT	
exit 0
