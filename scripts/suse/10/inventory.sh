#!/bin/bash

case "$1" in

	os)
		lsb_release -i | awk -F":" '{ print $2 }' | sed 's/^\t//g'
	;;
	osFull)
		FULL=$(lsb_release -d | awk -F":" '{ print $2 }' | sed 's/^\t//g')
		echo -e ${FULL}
	;;
	osShort)
		lsb_release -r | awk -F":" '{ print $2 }' | sed 's/^\t//g'
	;;
	networks)
		#hostname -i
                IPS=$(ip a | grep -w inet | grep -v "127.0.0." | awk '{ print $2 }')
                for IP in ${IPS}; do echo -ne "${IP}\t";done
                echo
	;;
	gateway)
		ip route | tail -n1 | awk '{ print $3 }'
	;;
        hostShort)
                hostname -s
        ;;
        hostFull)
                hostname -f
        ;;
	*)
		echo -e "Try:\n\t$0 [os|osFull|osShort|networks|gateway|mac{eth0|eth1}]"


esac
