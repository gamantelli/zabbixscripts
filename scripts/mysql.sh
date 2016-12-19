#!/bin/bash

#USER="readonly"
#PASS="r3ad0nly"

USER="dumper"
PASS="19ZDOJrT0Vjmyeao"

CHECK_TABLES() {
	host=`hostname -s`
	retvail=0
	bases=$(mysql -h "$host" -u "$USER" -p"$PASS" -Bse "show databases" | grep -v "lost+found\|information_schema\|mysql")

	for base in $bases;do

		tables=$(mysql -h "$host" -u "$USER" -p"$PASS" "$base" -Bse "show tables")

		for table in $tables; do
			mysql -h "$host" -u "$USER" -p"$PASS" "$base" -Bse "check table $table" > /dev/null
			if [ $? -ne 0 ]; then
                        	retvail=$(expr $retvail + 1)
               	 	fi
		done
	done

	echo $retvail
}

case $1 in

	dbsize)
		mysql -u"$USER" -p"$PASS" -Bse 'show table status\G' -D "$2" | egrep  "(Index|Data)_length" | awk 'BEGIN { rsum = 0 } { rsum += $2 } END { print rsum }'
	;;

	connections)
		mysql -u"$USER" -p"$PASS" -Bse 'show status'  | grep "^Connections" | awk '{ print $2 }'
	;;
	aborted_connections)
                mysql -u"$USER" -p"$PASS" -Bse 'show status'  | grep "^Aborted_connects" | awk '{ print $2 }'
	;;
	successful_connections)
		CONNECTIONS=$(mysql -u"$USER" -p"$PASS" -Bse 'show status'  | grep "^Connections" | awk '{ print $2 }')
		ACONNECTIONS=$(mysql -u"$USER" -p"$PASS" -Bse 'show status'  | grep "^Aborted_connects" | awk '{ print $2 }')
		RESULT=$(expr $CONNECTIONS - $ACONNECTIONS)
		echo $RESULT
	;;
	max_connections)
		mysql -u"$USER" -p"$PASS" -Bse 'show status' | grep "^Max_used_connections" | awk '{ print $2 }'
	;;

	number_process)
		mysql -u"$USER" -p"$PASS" -Bse 'show processlist' | wc -l
	;;
	
	qcache_hits)
		mysql -u"$USER" -p"$PASS" -Bse 'show status'  | grep "^Qcache_hits" | awk '{ print $2 }'
	;;	

	select_full_join)
		mysql -u"$USER" -p"$PASS" -Bse 'show status'  | grep "^Select_full_join" | awk '{ print $2 }'
	;;

	opened_tables)
		mysql -u"$USER" -p"$PASS" -Bse 'show status'  | grep "^Opened_tables" | awk '{ print $2 }'
	;;

	open_tables)
		mysql -u"$USER" -p"$PASS" -Bse 'show status'  | grep "^Open_tables" | awk '{ print $2 }'
	;;

	qps)
		mysqladmin -u"$USER" -p"$PASS" status|cut -f9 -d":" | sed 's/^ //g'
	;;
	
	slowqueries)
		mysqladmin -u"$USER" -p"$PASS" status|cut -f5 -d":"|cut -f1 -d"O" | sed 's/^ //g'
	;;

	questions)
		mysqladmin -u"$USER" -p"$PASS" status|cut -f4 -d":"|cut -f1 -d"S" | sed 's/^ //g'
	;;

	threads)
		mysqladmin -u"$USER" -p"$PASS" status|cut -f3 -d":"|cut -f1 -d"Q" | sed 's/^ //g'
	;;
	check_table)
		CHECK_TABLES
	;;
	*)
		echo "Try: $0 [aborted_connections|check_table|connections|dbsize|max_connections|number_process|opened_tables|open_tables|qcache_hits|qps|questions|select_full_join|slowqueries|successful_connections|threads]"
	;;

esac
