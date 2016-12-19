#!/bin/bash

# Colors
NEG="\033[1m"
RED="\033[31;1m"
BLUE="\033[34;1m"
GREEN="\033[32;1m"
COR="\033[m"


OPTIONS(){
echo -ne "
Try:
${NEG}${0}${COR} ${BLUE} intrusion   + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} cmosbattery + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} heatsink + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} idrac6 + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} usbcable + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} storadapt + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} riser2 + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} riser1 + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} riserconfig + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} oswatchdog + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} psredundancy + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} fanredundancy + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} poweroptimized + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} drive + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} cablesasa + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} cablesasb + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} dkmstatus + IP_DRAC${COR}\t\tStatus of chassis
${NEG}${0}${COR} ${BLUE} vflash + IP_DRAC${COR}\t\tStatus of chassis
"
}

# User and password
USER="root"
PASS="#JmJrFln9s"
TMP="/tmp"
IPMITOOL="/usr/bin/ipmitool"

# Check number of parameters
if [ "$#" -ne 2 ]; then
	OPTIONS
	exit 1
fi

# Check RESULT
function checkRESULT() {
	if [ ${RESULT} -n ]; then
		RESULT="ok"
	fi

	if [ ${RESULT} != "ok" ]; then
		echo "1"
		exit 1
	else
		echo "0"
		exit 0
fi

}

# Query, Dell iDrac and Command
QUERY="$1"
HOST_DRAC="$2"

CMD="${IPMITOOL} -I lanplus -H ${HOST_DRAC} -U ${USER} -P ${PASS} sdr"

case ${QUERY} in

	intrusion)
		RESULT=$($CMD | grep Intrusion | awk '{print $5}')
		checkRESULT
	;;


	cmosbattery)
		RESULT=$($CMD | grep "CMOS Battery" | awk '{print $6}')
		checkRESULT
        ;;

	heatsink)
		RESULT=$($CMD | grep "Heatsink Pres" | awk '{print $6}')
		checkRESULT

	;;
	idrac6)
		RESULT=$($CMD | grep "iDRAC6" | awk '{print $7}')
                checkRESULT

	;;

	usbcable)
                RESULT=$($CMD | grep "USB Cable" | awk '{print $7}')
                checkRESULT

	;;

	storadapt)
                RESULT=$($CMD | grep "Stor Adap" | awk '{print $7}' )
                checkRESULT

	;;

	riser2)
                RESULT=$($CMD | grep "Riser2 Pres" | awk '{print $6}' )
                checkRESULT

	;;

	riser1)
                RESULT=$($CMD | grep "Riser1 Pres" | awk '{print $6}')
                checkRESULT

	;;

	riserconfig)
                RESULT=$($CMD | grep "Riser Config" | awk '{print $6}')
                checkRESULT

	;;

	oswatchdog)
                RESULT=$($CMD | grep "OS Watchdog  " | awk '{print $6}')
                checkRESULT

	;;

	psredundancy)
                RESULT=$($CMD | grep "PS Redundancy" | awk '{print $6}')
                checkRESULT

	;;

	fanredundancy)
                RESULT=$($CMD | grep "Fan Redundancy" | awk '{print $6}')
                checkRESULT

	;;

	poweroptimized)
                RESULT=$($CMD | grep "Power Optimized" | awk '{print $6}')
                checkRESULT

	;;

	drive)
                RESULT=$($CMD | grep "Drive" | awk '{print $5}')
                checkRESULT

	;;

	cablesasa)
                RESULT=$($CMD | grep "Cable SAS A" | awk '{print $7}')
                checkRESULT

	;;

	cablesasb)
                RESULT=$($CMD | grep "Cable SAS B" | awk '{print $7}')
                checkRESULT

	;;

	dkmstatus)
                RESULT=$($CMD | grep "DKM Status" | awk '{print $6}')
                checkRESULT

	;;

	vflash)
                RESULT=$($CMD | grep "vFlash" | awk '{print $5}')
                checkRESULT

	;;

esac
