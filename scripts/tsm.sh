#!/bin/bash

TSMPARM="-id=onix -password=JmJrFln9s"
DSM="/usr/bin/dsmadmc"

SENDEMAIL_SCRATCH() {
	ARRAY_FITAS_TOTAL=$(cat /tmp/fitasTSM.lst)
	FITAS_ROBO=$($DSM $TSMPARM "q vol" | grep F4T0 | awk -F"LTO_" '{ print $1 }')	

	for aux1 in $ARRAY_FITAS_TOTAL; do
	        COUNT=0
	        for aux2 in $FITAS_ROBO; do
	                if [ $aux1 == $aux2 ]; then
	                        COUNT=$(expr $COUNT + 1)
	                fi
	        done
	                if [ $COUNT -eq 0 ]; then
	                        SCRATCHLIST+=" $aux1"
	                fi
	done
	echo "$SCRATCHLIST" > /tmp/resultScratch.lst
	#cat /tmp/resultScratch.lst | mail -s "Lista de Scratch" giovanni.mantelli@f4thint.com.br

}

RESULT_FUNCTION() {
	if [ $RESULT -eq 0 ]; then
		echo 0;
	else
		echo 1;
	fi

}

DRIVE_STATUS(){
        DRIVES=$($DSM $TSMPARM "q path" | grep DRIVE | awk '{ print $5 }')

        for DRIVE in $DRIVES; do
                if [ $DRIVE == 'No' ]; then
                        echo 1
                        exit 1
                fi
        done

        echo 0 
}


INSERT_SCRATCH() {
	$DSM $TSMPARM "q req" | grep "SCRTCH" > /dev/null
	RESULT=$?
	RESULT_FUNCTION
}

INSERT_TAPE(){
        $DSM $TSMPARM "q req" | grep "Mount LTO volume" > /dev/null
	RESULT=$?
        RESULT_FUNCTION
}	

TESTE() {
	$DSM $TSMPARM "q req" | grep "No requests" > /dev/null
        RESULT=$?
        RESULT_FUNCTION
}

case $1 in
	drive-status)
		DRIVE_STATUS;;
	insert-scratch)
		INSERT_SCRATCH
		SENDEMAIL_SCRATCH;;
	insert-tape)
		INSERT_TAPE;;
	teste)
		TESTE;;
        *)
                echo "Error! Usage: [insert-scratch|insert-tape|teste|drive-status]" ;;
esac
