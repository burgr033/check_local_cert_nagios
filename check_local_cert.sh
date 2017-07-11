#!/bin/bash
file=$1
if [ -a "$file" ]
then
	dest_date=`date --date="$(openssl x509 -in $file -noout -enddate | cut -d= -f 2)" --iso-8601`
	diff=$(( ($(date '+%s' -d "$dest_date") - $(date '+%s')) / 86400 ))

	if (( $diff > 90 ))
	then
		echo "OK, Certificate expires in $diff days."
		exit 0
	elif (( $diff > 30 ))
	then
		echo "WARNING, Certificate expires in $diff days."
		exit 1
	else
		echo "CRITICAL, Certificate expires in $diff days."
		exit 2
	fi
	else
		echo "UNKNOWN, Certificate not found"
		exit 3
fi