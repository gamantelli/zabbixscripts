#!/bin/bash
#
#
# Se status=0, ip limpo
# Se status <>0, ip sujo

# Teste dos parametros iniciais
if [[ $# != 2 ]];then
    echo "Error! Usage $0 <param> <ip>"
    exit 1
fi


# Variaveis 
	DIR=$(dirname $0)
	. $DIR/rbl.lst
	IP=$2
	OPT=$1
	set ${IP//./ } > /dev/null
	STATUS=0

# Opcoes
case $OPT in
	check)
		for i in $LIST; do
			#echo "*********STATUS: $STATUS"
			RESULT=$( host -ta -W2 $4.$3.$2.$1.$i. 2>&1 )
			if echo "$RESULT" | grep -q ' 127\.' ; then
				STATUS=$(expr $STATUS + 1)
				#let STATUS=0
			fi
		done
		echo $STATUS
	;;
	*)
		echo "Invalid Option!"
	;;
esac	
