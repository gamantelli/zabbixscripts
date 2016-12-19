#!/bin/bash

case "$1" in

	file-descriptors)
		cat /proc/sys/fs/file-nr | cut -f 1
	;;
	*)
		echo "error"
	;;
esac
