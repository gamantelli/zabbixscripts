#!/bin/bash

if [ -e /etc/SuSE-release ]; then
        OS=suse

elif [ -e /etc/debian_version ]; then
        OS=debian
else
        OS=redhat
fi


case "$1" in
	auditd)
			/etc/init.d/auditd restart
	;;

	amavisd)
			/etc/init.d/amavisd restart
	;;
	apache)
			/etc/init.d/httpd restart
	;;
	apcupsd)
			/etc/init.d/apcupsd restart
	;;
	clamd)
			/etc/init.d/clamd restart
	;;
	crond)
			if [ "$OS" = "redhat" ]; then
				/etc/init.d/crond restart
			else
				/etc/init.d/cron restart
			fi
	;;
	dhcpd)
			/etc/init.d/dhcpd restart
	;;
	dovecot)
			/etc/init.d/dovecot restart
	;;
	dsmcad)
			/etc/init.d/dsmcad restart
	;;
	fail2ban)
			/etc/init.d/fail2ban restart
	;;
	hylafax)
			/etc/init.d/hylafax restart
	;;
	luci)
			/etc/init.d/luci restart
	;;
	kserver)
			/etc/init.d/kserver restart
	;;
	lin_tape)
			/etc/init.d/lin_tape restart
	;;
	mailman)
			/etc/init.d/mailman restart
	;;
	named)
			/etc/init.d/named restart
	;;
	ntop)
			/etc/init.d/ntop restart
	;;
	ntpd)
			if [ "$OS" = "redhat" ]; then
				/etc/init.d/ntpd restart
			else
				/etc/init.d/ntp restart
			fi
	;;
	openmanager)
			/etc/init.d/dataeng restart
	;;
	proftp)
			/etc/init.d/proftpd restart
	;;
	raidman)
			/etc/init.d/raid_agent restart
	;;
	samba)
			if [ "$OS" = "redhat" ]; then
				/etc/init.d/smb restart
			else
				/etc/init.d/smb restart
				/etc/init.d/smbfs restart
			fi
	;;
	saslauthd)
			/etc/init.d/saslauthd restart
	;;
	snmpd)
			/etc/init.d/snmpd restart
	;;
	spamassassin)
			/etc/init.d/spamassassin restart
	;;
	smsd)
			/etc/init.d/smsd restart
	;;
	squid)
			/etc/init.d/squid restart
	;;
	sshd)
			if [ "$OS" = "debian" ]; then
				/etc/init.d/ssh restart
			else
				/etc/init.d/sshd restart
			fi
	;;
	sssd)
			/etc/init.d/sssd restart
	;;
	syslog)
			if [ "$OS" = "debian" ]; then
				/etc/init.d/sysklogd restart
			else
				/etc/init.d/syslogd
			fi
	;;
	vmcli)
			/etc/init.d/vmcli restart
	;;
	xinetd|rsync)
			/etc/init.d/xinetd restart
	;;
	yum-updatesd)
			/etc/init.d/yum-updatesd restart
	;;
	zabbix)
			if [ "$OS" = "suse" ]; then
				/etc/init.d/zabbix-agentd restart
			else
				/etc/init.d/zabbix-agent restart
			fi
	;;
	OS)
                        echo "$OS"
        ;;
	*)
		echo "Service not found!"
	;;

esac
