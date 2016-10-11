#!/bin/bash

# PASS LIST OF IPS AS THE FIRST PARAMETER SEPARATED BY INDIVIDUAL LINES
# This script collects 'uname' data from a set of linux machines.
# A list of IPs are listed in a text file are given via arguement.
# The script connects via ssh and gathers 'uname' data from each IP.
# Assume the person running the script has ssh access setup, ssh keys setup with the given servers, and the names of the accounts are root

#Alex Shell 5/15/2016


# List of IPs is the first argument

IPLIST="$1"

# If list is empty or no argument is given exit program

if [ -z "$1" ]; then 
	echo "A path to list of ips was not set or is empty."
	echo "Specify a path to a text file with ips on each line."
	exit
fi

# Refresh unamedata folder and create files

rm -rf unamedata
mkdir unamedata


# Collect uname data into files for each ip 

IFS=$'\n'
fileID=0

while read ip; do
	ssh root@$ip "uname -s >> hold.txt && uname -n >> hold.txt && uname -r >> hold.txt && uname -v >> hold.txt && uname -m >> hold.txt && cat hold.txt && rm hold.txt" > ./unamedata/$fileID
	let "fileID = $fileID + 1"
done < $IPLIST

# Refresh results folder and create files

rm -rf results
mkdir results
touch ./results/0
touch ./results/1
touch ./results/2
touch ./results/3
touch ./results/4


# Append to files if uname value is unique
# resultsCursor is to remember the ID for the results

resultsCursor=0

for ((ip=0; ip<$fileID; ip++))
	do
		while read unamepiece; do
			if ! grep -q $unamepiece ./results/$resultsCursor;
			then
				echo $unamepiece >> ./results/$resultsCursor

			fi
			let "resultsCursor = $resultsCursor + 1" 
		done < ./unamedata/$ip
		let "resultsCursor = 0" 	
	done

# Print unique results
echo "-----------------------"
echo "Unique kernel names"
echo "-----------------------"
cat ./results/0

echo "-----------------------"
echo "Unique hostnames"
echo "-----------------------"
cat ./results/1

echo "-----------------------"
echo "Unique kernel versions"
echo "-----------------------"
cat ./results/2

echo "-----------------------"
echo "Unique machine hardware names"
echo "-----------------------"
cat ./results/3

echo "-----------------------"
echo "Unqiue operating systems"
echo "-----------------------"
cat ./results/4
