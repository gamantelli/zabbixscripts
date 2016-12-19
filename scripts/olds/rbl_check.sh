#!/bin/bash

# Variaveis
	DIRLOGS="/var/log/rbls"
	RBL=$(cat /scripts/zabbix/rbls/sites.txt) 
	#SERVIDORES=$( echo 201.64.109.102-email.floripark.com.br 201.64.109.98-tracker.f4thint.com.br)
	SERVIDORES=$( echo 187.29.33.2-email.floripark.com.br 201.64.109.98-tracker.f4thint.com.br)


checkRBL() {
	# Variaveis do HOST
        W=$( echo $IP | cut -d. -f1 )
        X=$( echo $IP | cut -d. -f2 )
        Y=$( echo $IP | cut -d. -f3 )
        Z=$( echo $IP | cut -d. -f4 )
        IP_REV=$( echo $Z\.$Y\.$X\.$W)
	echo "== Servername: $HOSTNAME $IP" > $DIRLOGS/rbl.log
	for i in $RBL; do
		RESULT=$( host -t a $IP_REV.$i 2>&1 )
		if [ $? -eq 0 ]; then
		        STATUS=$(expr $STATUS + 1)
			if [ $STATUS -gt 0 ]; then
				echo "$HOSTNAME listed in $i" >> $DIRLOGS/rbl.log
			fi
		 fi
	done

	# Testando status result
	if [ $STATUS -lt 1 ]; then
		echo "nao  listado"
	else
		echo listado
		#echo $STATUS
	fi
}

# * * * * * * * * * *
# Main
# * * * * * * * * * *
for hosts in $SERVIDORES; do
	STATUS=0
        IP=$( echo $hosts | cut -d"-" -f1)
        HOSTNAME=$( echo $hosts | cut -d"-" -f2)
	checkRBL $IP $HOSTNAME 
done
