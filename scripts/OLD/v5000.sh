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
${NEG}${0}${COR} ${BLUE} lsarray storage${COR}\n\t\tStatus of arrays\n
${NEG}${0}${COR} ${BLUE} lsdrive storage${COR}\n\t\tStatus of drives\n
${NEG}${0}${COR} ${BLUE} lsvdisk storage${COR}\n\t\tStatus of virtual disks\n
${NEG}${0}${COR} ${BLUE} lsenclosures storage${COR}\n\t\tStatus enclosure\n
${NEG}${0}${COR} ${BLUE} lsenclosurecanister storage${COR}\n\t\tStatus of canisters\n
${NEG}${0}${COR} ${BLUE} lsenclosurepsu storage${COR}\n\t\tStatus of power supply\n
${NEG}${0}${COR} ${BLUE} lsenclosureslot storage${COR}\n\t\tStatus of enclosures slots\n
${NEG}${0}${COR} ${BLUE} lsrcrelationship storage${COR}\n\t\tStatus mirror\n
"
}



# User and password
USER="f4th.zabbix"
PASS="z4bB1x#"
TMP="/tmp"

# Command
SSHPASS="/usr/bin/sshpass"


# Check command
if [ ! -e ${SSHPASS} ]; then
	echo "File ${SSHPASS} not found!"
	exit 1
fi

# Check number of parameters
if [ "$#" -ne 2 ]; then
	OPTIONS
	exit 1
fi

# Check temporary dir
if [ ! -d ${TMP} ]; then
	echo "Directory ${TMP} not found!"
fi

CHECK_TMP_FILE() {
	if [ ! -e ${TMP}/v7000-${QUERY}-${STORAGE}.txt ]; then
		exit 1
	fi
}

# Query, Storage and Command
QUERY="$2"
STORAGE="$1"
CMD="${SSHPASS} -p '${PASS}' ssh -o StrictHostKeyChecking=no ${USER}@${STORAGE}"

case ${QUERY} in

	lsarray)
		eval "$CMD" ${QUERY} -nohdr > ${TMP}/v7000-${QUERY}-${STORAGE}.txt
		CHECK_TMP_FILE

		ARRAYS=$(cat ${TMP}/v7000-${QUERY}-${STORAGE}.txt | awk '{ print $3 }')
		for ARRAY in ${ARRAYS}; do
			if [ ${ARRAY} != "online" ]; then
				#echo "MDisk offline"
				echo 1
				exit 1
			fi
		done

		# Remove file
		rm -f ${TMP}/v7000-${QUERY}-${STORAGE}.txt
			
		#echo "MDisk online"
		echo 0
		exit 0
	;;
	lsdrive)
		eval "$CMD" ${QUERY} -nohdr > ${TMP}/v7000-${QUERY}-${STORAGE}.txt
                CHECK_TMP_FILE

                DISKS=$(cat ${TMP}/v7000-${QUERY}-${STORAGE}.txt | awk '{ print $2 }')
		for DISK in ${DISKS}; do
                	if [ ${DISK} != "online" ]; then
                        	#echo "Disk offline"
				echo 1
                        	exit 1
                	fi
		done

		# Remove file
		rm -f ${TMP}/v7000-${QUERY}-${STORAGE}.txt

                #echo "Disk online"
		echo 0
                exit 0
	;;
	lsvdisk)
		eval "$CMD" ${QUERY} -nohdr > ${TMP}/v7000-${QUERY}-${STORAGE}.txt
                CHECK_TMP_FILE

                VDISKS=$(cat ${TMP}/v7000-${QUERY}-${STORAGE}.txt | awk '{ print $5 }')
		for VDISK in ${VDISKS}; do
                	if [ ${VDISK} != "online" ]; then
                        	#echo "Vdisk offline"
				echo 1
                        	exit 1
               		fi
		done

		# Remove file
		rm -f ${TMP}/v7000-${QUERY}-${STORAGE}.txt

                #echo "Vdisk online"
		echo 0
                exit 0
	;;
	lsenclosure)
		eval "$CMD" ${QUERY} -nohdr > ${TMP}/v7000-${QUERY}-${STORAGE}.txt
                CHECK_TMP_FILE

                ENCLOSURES=$(cat ${TMP}/v7000-${QUERY}-${STORAGE}.txt | awk '{ print $2 }')
		for ENCLOSURE in ${ENCLOSURES}; do
                	if [ ${ENCLOSURE} != "online" ]; then
                      #  	echo "Enclosure offline"
				echo 1
                        	exit 1
                	fi
		done

                # Remove file
                rm -f ${TMP}/v7000-${QUERY}-${STORAGE}.txt

#                echo "Enclosure online"
		echo 0
                exit 0
	;;
        lsenclosurecanister)
                eval "$CMD" ${QUERY} -nohdr > ${TMP}/v7000-${QUERY}-${STORAGE}.txt
                CHECK_TMP_FILE

                CANISTERS=$(cat ${TMP}/v7000-${QUERY}-${STORAGE}.txt | awk '{ print $3 }')
		for CANISTER in ${CANISTERS}; do
                	if [ ${CANISTER} != "online" ]; then
                     #   	echo "Canister offline"
				echo 1
                        	exit 1
                	fi
		done

                # Remove file
                rm -f ${TMP}/v7000-${QUERY}-${STORAGE}.txt                   

#	 	echo "Canister online"
		echo 0
                exit 0
        ;;
        lsenclosurepsu)
                eval "$CMD" ${QUERY} -nohdr > ${TMP}/v7000-${QUERY}-${STORAGE}.txt
                CHECK_TMP_FILE

                PSUS=$(cat ${TMP}/v7000-${QUERY}-${STORAGE}.txt | awk '{ print $3 }')
		for PSU in ${PSUS}; do
                	if [ ${PSU} != "online" ]; then
                      #  	echo "PSU offline"
				echo 1
                        	exit 1
                	fi
		done

                # Remove file
                rm -f ${TMP}/v7000-${QUERY}-${STORAGE}.txt

#                echo "PSU online"
		echo 0
                exit 0
        ;;
        lsenclosureslot)
                eval "$CMD" ${QUERY} -nohdr > ${TMP}/v7000-${QUERY}-${STORAGE}.txt
                CHECK_TMP_FILE

                cat ${TMP}/v7000-${QUERY}-${STORAGE}.txt | awk '{ print $3, $4 }' | grep -i offiline
                if [ $? -eq 0 ]; then
                     #   echo "Enclosure slot offline"
			echo 1
                        exit 1
                else
#                        echo "Enclosure slot online"
			echo 0
                        exit 0
                fi

		# Remove file
                rm -f ${TMP}/v7000-${QUERY}-${STORAGE}.txt
        ;;
        lsrcrelationship)
                eval "$CMD" ${QUERY} -nohdr > ${TMP}/v7000-${QUERY}-${STORAGE}.txt
                CHECK_TMP_FILE

                cat ${TMP}/v7000-${QUERY}-${STORAGE}.txt 

                # Remove file
                rm -f ${TMP}/v7000-${QUERY}-${STORAGE}.txt
        ;;
esac
