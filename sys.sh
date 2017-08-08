#!/bin/bash
# sys shell script, shows system info
# By Fares, Aug 2017 - fares.net
# version 1.0
#################################

r=`tput setaf 8`
g=`tput setaf 2`
b=`tput setaf 3`
error=`tput setaf 1`
z=`tput sgr0` # no color

IFS=$'\n'
USERS=`users`
DATE=`date`
KERNEL=`uname -srn`
CPWD=`pwd`
ME=`whoami`
MYIP=`curl -s ipinfo.io/ip`
PL=`uname -m`

function serviceStatus () {
if /etc/init.d/$1 status > /dev/null 
then
printf "  $1:\t${g}Running "
service $1 status | grep "Active" | awk 'END {print $(NF-1), $NF}' ; printf "${z}"
else
printf "  $1:\t${error}NO RUNNING${z}\n"
fi
} 

clear
printf "\n\n"
printf "${r}============ SYSTEM ${z}\n"
printf "  Date:\t\t${b}"$DATE"${z}\n"
printf "  Kernel:\t"$KERNEL" ("$PL")\n"
printf "  Uptime:\t"
uptime | awk '{print $2, $3, $4 }' 
printf "  Used Space:\t"
df -H / |  awk '{print $5}' | sed -e /^Use/d
printf '  Load:\t\t'; uptime | awk '{print $10,$11,$12}';
printf "  Who is on:\t"$USERS"\n"

printf "\n${r}============ USER ${z}\n"
printf "  User:\t\t"$ME" (uid:"$UID")\n"
#printf "  Groups:\t"$MYGROUPS"\n"
printf "  Working dir:\t"$CPWD"\n"
printf "  Home dir:\t"$HOME"\n"

printf "\n${r}============ NETWORK ${z}\n"
printf "  Hostname:\t"$HOSTNAME"\n"
printf "  External IP:\t${b}"$MYIP"${z}\n"
printf "  Local IP:\t"
ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' 

cat /etc/resolv.conf | awk '/^nameserver/{ printf "  Name Server:\t" $2 "\n"}'
printf "\n"

printf "${r}============ SERVICES ${z}\n"
serviceStatus apache2
serviceStatus mysql
serviceStatus bind9
#serviceStatus "ufw    "

printf "\n"
printf "\n"
