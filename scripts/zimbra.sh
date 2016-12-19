#! /bin/bash
#
# Name: zimbra 
#
# Checks zimbra activity.
#
# Author: Giovanni Antonio Mantelli 
#
# Version: 1.0
#
 
zimbraver="8.0.6"
rval=0
now=`date +%s`
file="/tmp/zimbra/zimbra_status_$now"
file_new="/tmp/zimbra/zimbra_status_new_$now"
 
function usage()
{
    echo "zimbra version: $zimbraver"
    echo "usage:"
    echo "    $0 antispam "
    echo "    $0 antivirus"
    echo "    $0 ldap     "
    echo "    $0 logger   "
    echo "    $0 mailbox  "
    echo "    $0 memcached"
    echo "    $0 mta      "
    echo "    $0 opendkim "
    echo "    $0 proxy    "
    echo "    $0 snmp     "
    echo "    $0 spell    "
    echo "    $0 stats    "
    echo "    $0 zmconfigd"
}

########
# Main #
########

# Verificando processos e gerando arquivo:
sudo -u zimbra /opt/zimbra/bin/zmcontrol status > $file_new
#/etc/init.d/zimbra status > $file_new

if [[ $# != 1 ]];then
    usage
    echo
    exit 1
fi


# Pegando valor do primeiro parametro
check=$1
cp $file_new $file
status=$(cat $file | grep $check | awk '{ print $2 }')

# Verificando status
if [[ $status != "Running" ]]; then
	echo 0
else
	echo 1
fi

#rm -f $file_new
#rm -r $file
