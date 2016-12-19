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
${NEG}${0}${COR} ${BLUE} os${COR}\n\t\tShow OS name\n
${NEG}${0}${COR} ${BLUE} osFull${COR}\n\t\tShow Full OS name\n
${NEG}${0}${COR} ${BLUE} osShort${COR}\n\t\tShow Short OS name\n
${NEG}${0}${COR} ${BLUE} networks${COR}\n\t\tShow networks\n
${NEG}${0}${COR} ${BLUE} gateway${COR}\n\t\tShow Gateway of host\n
${NEG}${0}${COR} ${BLUE} hostShort${COR}\n\t\tShow Short Hostname\n
${NEG}${0}${COR} ${BLUE} hostFull${COR}\n\t\tShow Full Qualified Name\n
${NEG}${0}${COR} ${BLUE} hwFull${COR}\n\t\tShow Hardware\n
"
}

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
        hwFull)
                CPU=`cat /proc/cpuinfo | grep "model name" | uniq | awk -F":" '{ print $2 }' | sed 's/^[ ]*//g' | sed 's/  */ /g'`
                CORES=`cat /proc/cpuinfo | grep "cpu cores" | sort | uniq | awk -F":" '{ print $2 }' | sed 's/^ //g'`
                SCPU=`cat /proc/cpuinfo | grep "physical id" | sort -n | uniq | wc -l`
                MEM=`free -mo | grep "^Mem:" | awk '{ print $2 }'`
                SMEM=`[ -f /usr/local/etc/hardware.txt ] && cat /usr/local/etc/hardware.txt | grep "^Memory Device"$ | wc -l`
                SWAP=`free -mo | grep "^Swap:" | awk '{ print $2 }'`
                DISKS=`ls -1 /dev/sd? | awk -F"/" '{ print $3 }'`

                echo -e "Model\t: ${CPU}\nCores\t: ${CORES}\nCpus\t: ${SCPU}\nMem\t: ${MEM} MB\nSlots\t: ${SMEM}\nSwap\t: ${SWAP}"
                for DISK in ${DISKS}; do
                        SIZE=$(echo $[ $(grep -w ${DISK} /proc/partitions | awk '{ print $3 }') / 1024 / 1024 ])
                        echo -e "Disk\t: /dev/${DISK}\t${SIZE}\t GB"
                done
        ;;
        *)
                OPTIONS

esac

