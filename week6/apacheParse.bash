#!/bin/bash

# Eric Burdick 10/7/2023
# Story: Create a script that parses apache logs and creates an IPtable ruleset with the file

# Argument, allows us to plugin access.log by including it after the bash run command

APACHE_LOG="$1"


# Check block to see if the apache file even exist before doing anything else

if [[ ! -f ${APACHE_LOG} ]]
then
	echo "I cannot see the file you are trying to parse, please try again!"
	exit 1
fi


# Look for webscanners using sed followed by an egrep and awk to filter the log file to give a more clean result as well as organizing it into labeled rows and columns

sed -e 's/\[//g' -e 's/\"//g' ${APACHE_LOG} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
awk ' BEGIN { format = "%-15s %-20s %-7s %-6s %-10s %s\n"
		printf format, "IP", "Date", "Method", "Status", "Size", "URI"
		printf format, "--", "----", "------", "------", "----", "---" }

{ printf format, $1, $4, $6, $9, $10, $7 }'


# This function will look through the list of IP addresses and if it notices any duplicates, properly deletes them

function DupIP() {

	cat ${APACHE_LOG} | awk '{print $1}' | sort -u | tee badIPs.txt

}



# The following function will create a iptable ruleset aswell as checking if a badip file exist, making one if there isnt anything

function IPtables() {

if [[ -f badIPs.txt ]]
then
	for ip in $(cat badIPs.txt)
	do
		echo "iptables -A INPUT -s ${ip} -j DROP" | tee -a badIPs.iptables
	done
else
	DupIP
	for ip in $(cat badIPs.txt)
	do 
		echo "iptables -A INPUT -s ${ip} -j DROP" | tee -a badIPs.iptables
	done
fi

}


# Function call to make it all work

IPtables
