#!/bin/sh

if [ "$(which tput)" != "" ];then
	bold=$(tput bold)
	normal=$(tput sgr0)
else
	bold=""
	normal=""
fi

better_ping=99999
better_datacenter=''
better_datacenter_name=''
max_ping=$1

while read -r line;
do
	if [ "$(uname)" == "Darwin" ];then
		ping_avg=`ping -W 2 -c $max_ping $line | tail -n1 | cut -d'=' -f2 | cut -d'/' -f2`
		echo "Ping ${bold}${line}${normal}: $ping_avg ms"
	elif [ "$(uname)" == "Linux" ];then
		echo -n "Ping ${bold}${line}${normal}: "
		ping_avg=`ping -W 2 -c $max_ping $line | tail -n1 | cut -d'=' -f2 | cut -d'/' -f2`
		echo "$ping_avg ms"
	fi
	if [ $(echo "$ping_avg"|cut -d'.' -f1) -lt $better_ping ];then
		better_ping=$(echo "$ping_avg"|cut -d'.' -f1)
		better_datacenter=$line
		better_datacenter_name=`echo $line | cut -d'.' -f1 | cut -d'-' -f2`
	fi
done < "$2"

echo ""
echo "${bold}---------------------- Better Datacenter is -----------------------------------${normal}"
echo "${bold}Domain${normal}: $better_datacenter"
echo "${bold}Ping AVG${normal}: $better_ping ms"
echo "${bold}Name${normal}: $better_datacenter_name"
echo "${bold}-------------------------------------------------------------------------------${normal}"
echo ""
