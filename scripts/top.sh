#!/bin/bash

CPU(){
	# set limit to 1st argument, or 2% if not specified
	lim="$min"
	test -z $lim && lim=2

	# run 2 iterations of top in batch mode with 1 s delay
	top -b -d1 -n3 |\
	gawk --assign lim=$lim  'BEGIN { reply=""}
		END { print reply, "-" }
		# if reply is empty, at least a period is returned

		# in 2nd iteration, first 3 lines
		# add columns 9 (%cpu) and 12 (process name)
		# to reply string, if cpu at least lim%
		#itr == 2 && NR <= 3 && $9 >= lim { reply=reply " " $9 "%" $12 }
		itr == 2 && NR <= 3 && $9 >= lim { reply=reply "- " "cpu: "$9"% ""[proc:"$12"|uid:"$2"|pid:"$1"] " }

		# count iterations by header lines beginning with "PID"
		# reset linenumber
		$1 == "PID" { NR=0 ; itr +=1 }
	       '
}
MEM(){
        # set limit to 1st argument, or 2% if not specified
        lim="$min"
        test -z $lim && lim=2

        # run 2 iterations of top in batch mode with 1 s delay
        top -b -d1 -n3 |\
        gawk --assign lim=$lim  'BEGIN { reply=""}
                END { print reply, "-" }
                # if reply is empty, at least a period is returned

                # in 2nd iteration, first 3 lines
                # add columns 9 (%cpu) and 12 (process name)
                # to reply string, if cpu at least lim%
                #itr == 2 && NR <= 3 && $9 >= lim { reply=reply " " $9 "%" $12 }
                itr == 2 && NR <= 3 && $10 >= lim { reply=reply "- " "mem: "$10"% ""[proc:"$12"|uid:"$2"|pid:"$1"] " }

                # count iterations by header lines beginning with "PID"
                # reset linenumber
                $1 == "PID" { NR=0 ; itr +=1 }
               '
}

case "$1" in

	cpu)
		min="$2"
		CPU
	;;
	mem)
		min="$2"
		MEM
	;;
	*)
		echo "error"
	;;
esac
