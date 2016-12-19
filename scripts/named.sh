#!/bin/bash

RNDC="/usr/sbin/rndc"

SERIAL_ZONE() {

	#MASTER=$(dig -t soa @ns.prosul.com "$ZONE" | grep -A 1 "ANSWER SECTION:" | tail -n1 | awk '{ print $7 }')
	MASTER=$(dig +short -t soa @ns."$ZONE" "$ZONE" | awk '{ print $3 }')
	SLAVE=$(dig +short -t soa @localhost "$ZONE" | awk '{ print $3 }')
	#SLAVE=$(dig @localhost "$ZONE" | grep SOA | awk '{ print $7 }')

	if [ "$MASTER" -ne "$SLAVE" ]; then
		echo 0
		exit 1
	else
		echo 1
		exit 0
	fi
}

WHOIS_QUERY() {
        Expire=$(date -d `whois $Dominio | grep -i "expires:\|expires on\|expiration date:" | awk -F":" '{print $2}' | awk -F" " '{print $1}'` "+%s")
        Atual=$(date "+%s")
        Falta=$(expr $Expire - $Atual)
        Dias=$(expr $Falta / 86400)

#        if [ "$Dias" -lt "$Faltam" ]; then
#                echo 0
#                exit 1
#        else
#                echo 1
#                exit 0
#        fi
	echo "$Dias"
}


#PROPAGATION_QUERY() {
#	dnsSERVERS="208.67.222.222 208.67.220.220 205.210.42.205 64.68.200.200 156.154.70.1 156.154.71.1 189.38.95.95 189.38.95.96 8.8.4.4"
#	IP=$(dig +short @8.8.8.8 $NS)
#
#	for serv in $dnsSERVERS; do
#		ipTEST=$(dig +short @$serv $NS)
#		if [ "$ipTEST" != "$IP" ]; then
#			echo 0
#			exit 1
#		fi
#	done
#
#	echo 1
#	exit 0	
#
#}

case $1 in

        zones)
               "$RNDC" status | grep "number of zones" | awk -F":" '{ print $2 }' | sed 's/ //g'
        ;;
        xfers-running)
               "$RNDC" status | grep "xfers running" | awk -F":" '{ print $2 }' | sed 's/ //g'
        ;;
        xfers-deferred)
               "$RNDC" status | grep "xfers deferred" | awk -F":" '{ print $2 }' | sed 's/ //g'
        ;;
        soa-queries)
               "$RNDC" status | grep "soa queries in progress" | awk -F":" '{ print $2 }' | sed 's/ //g'
        ;;
        recursive-clients)
               "$RNDC" status | grep "recursive clients" | awk -F":" '{ print $2 }' | awk -F'/' '{ print $1 }' |  sed 's/ //g'
        ;;
        tcp-clients)
               "$RNDC" status | grep "tcp clients" | awk -F":" '{ print $2 }' | awk -F'/' '{ print $1 }' |  sed 's/ //g'
        ;;
	serial)
		ZONE="$2"
		SERIAL_ZONE
	;;
	expiration)
		Dominio="$2"
		Faltam="$3"
		WHOIS_QUERY
	;;
	propagation)
		NS="$2"
		PROPAGATION_QUERY
	;;
        *)
                echo "Try: $0 [propagation|zones|xfers-running|xfers-deferred|soa-queries|recursive-clients|tcp-clients|serial + zone|expiration + zone + days]"
		
        ;;
esac


