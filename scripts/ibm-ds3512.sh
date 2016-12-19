#!/bin/bash


# Variaveis
	# Colors
	NEG="\033[1m"
	RED="\033[31;1m"
	BLUE="\033[34;1m"
	GREEN="\033[32;1m"
	COR="\033[m"
	SMCLI="/opt/IBM_DS/client/SMcli"
	FILE_STORAGE_SP01="/tmp/storage-SP01.lst"
	FILE_STORAGE_SP02="/tmp/storage-SP02.lst"
	FILE_STORAGE_F4TH01="/tmp/storage-F4TH01.lst"
	PARAMETER="$1"
	STORAGE="$2"


function TESTOPTIMAL() {
	for i in $STATUS; do
		if [ "$i" == "OK" ]; then
			i="Optimal"
		fi
        	if [ "$i" != "Optimal" ]; then
                	 echo "1"
                         exit 1
	        fi
        done
	echo "0"
}


########
# Main #
########

# Testando parametros do script
if [[ $# != 2 ]];then
	echo "Usage: $0 [parameters] [storage]{stgipiranga|stgcaad|stgf4th}"
	exit 1
fi

# Definindo arquivo baseado no nome do storage
case $STORAGE in
	stgipiranga) 
		FILE=$FILE_STORAGE_SP01
	;;
	stgcaad)     
		FILE=$FILE_STORAGE_SP02
	;;
	stgf4th)     
		FILE=$FILE_STORAGE_F4TH01
	;;
	*)
		echo "Invalid Option"
		exit 1
	;;
esac

#echo "**** Usando $FILE e estorage $STORAGE"

case $PARAMETER in
	smw_version) 
		cat $FILE | grep "SMW Version" | awk -F": " '{print $2}' | awk '{print $1}'
	;;
	subsystem_name)
		cat $FILE | grep "Storage Subsystem Nam" | awk -F": " '{print $2}' | awk '{print $1}'
	;;
	battery_status)
		STATUS=$(cat $FILE | grep "Battery status" | awk -F": " '{print $2}' | awk '{print $1}')
		TESTOPTIMAL
	;;
	logical_drivers_status)
		STATUS=$(cat $FILE | grep "Host Group" | grep "Standard" | awk '{print $7}')
		TESTOPTIMAL
	;;
	sfp_status)
		STATUS=$(cat $FILE | grep "SFP status" | awk -F": " '{print $2}' | awk '{print $1}')
		TESTOPTIMAL
	;;		
	power-fan_left_status)
		STATUS=$(cat $FILE | grep "Power-fan CRU/FRU (Left) status" | awk -F": " '{print $2}' | awk '{print $1}')
		TESTOPTIMAL
	;;
	power-fan_rigth_status)
		STATUS=$(cat $FILE | grep "Power-fan CRU/FRU (Right) status" | awk -F": " '{print $2}' | awk '{print $1}')
		TESTOPTIMAL
	;;
	power-suply_status)
		STATUS=$(cat $FILE | grep "Power supply status" | awk -F": " '{print $2}' | awk '{print $1}')
		TESTOPTIMAL
	;;
	fan_status)
		STATUS=$(cat $FILE | grep "Fan Status:" | awk -F": " '{print $2}' | awk '{print $1}')
		TESTOPTIMAL
	;;
	disk_status)
		STATUS=$(cat $FILE | grep "Hard Disk Drive" | grep -v "Media type" | grep -v "Drive media type" | grep -v "Serial Attached" | grep -v "Current" | awk '{print $3}')
		TESTOPTIMAL
	;;
	temperature_sensor)
		STATUS=$(cat $FILE | grep "Temperature sensor status" | awk -F": " '{print $2}' | awk '{print $1}')
		TESTOPTIMAL
	;;
	enclosure_path_redundancy)
		STATUS=$(cat $FILE | grep "Enclosure path redundancy:" | awk -F": " '{print $2}' | awk '{print $1}')
		TESTOPTIMAL
	;;
	esm_card_status)
		STATUS=$(cat $FILE | grep "ESM card status:" | awk -F": " '{print $2}' | awk '{print $1}')
		TESTOPTIMAL
	;;	
	size_nlsas)
		SIZE_SASNL=$(cat $FILE | grep "Array NLSAS_RAID10 (RAID 1)" | awk -F"\\\) \\\(" '{print $2}' | awk -F")" '{print $1}')
		echo $SIZE_SASNL
	;;
	size_sas)
		SIZE_SASNL=$(cat $FILE | grep "Array SAS_RAID10 (RAID 1)" | awk -F"\\\) \\\(" '{print $2}' | awk -F")" '{print $1}')
		echo $SIZE_SASNL
	;;
	size_free_nlsas)
		FREE_NLSAS=$(cat $FILE | grep "NLSAS_RAID10" | grep "Serial Attached SCSI" | awk '{print $7}')
		echo $FREE_NLSAS
	;;
	size_free_sas)
		FREE_SAS=$(cat $FILE | grep " SAS_RAID10" | grep "Serial Attached SCSI" | awk '{print $7}')
		echo $FREE_SAS
	;;
	size_used_nlsas)
		USED_NLSAS=$(cat $FILE | grep "NLSAS_RAID10" | grep "Serial Attached SCSI" | awk '{print $5}')
		echo $USED_NLSAS
	;;
	size_used_sas)
		USED_SAS=$(cat $FILE | grep " SAS_RAID10" | grep "Serial Attached SCSI" | awk '{print $5}')
		echo $USED_SAS
	;;
esac
