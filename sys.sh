#!/bin/bash
# sys shell script, shows system info
# By Fares, Aug 2017
# version 1.0 - fares.net 4
#################################

a=`tput setaf 1`
r=`tput setaf 8`
g=`tput setaf 2`
b=`tput setaf 3`
z=`tput sgr0` # no color

upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
secs=$((${upSeconds}%60))
mins=$((${upSeconds}/60%60))
hours=$((${upSeconds}/3600%24))
days=$((${upSeconds}/86400))

IFS=$'\n'
USERS=`users`
DATE=`date`
KERNEL=`uname -srn`
CPWD=`pwd`
ME=`whoami`
MYIP=`curl -s ipinfo.io/ip`
PL=`uname -m`
UPTIME=`printf "%d days, %02dh %02dm %02ds" "$days" "$hours" "$mins" "$secs"`

function serviceStatus () {
if /etc/init.d/$1 status > /dev/null 
then
printf "  ${z}$1:\t${g}Running "
service $1 status | grep "Active" | cut -d ";" -f2 
else
printf "  $1:\t${a}NO RUNNING${z}\n"
fi
} 

printf "\n"
clear
printf "${r}============ SYSTEM ${z}\n"
printf "\n\n"
printf "${r}============ SYSTEM ${z} ${a}==> "$HOSTNAME" <==${z}\n"
printf "  Date:\t\t${b}"$DATE"${z}\n"
printf "  Kernel:\t"$KERNEL" ("$PL")\n"
printf "  Uptime:\t"$UPTIME"\n"
printf "  Used Space:\t"
df -H / |  awk '{print $5 " ("$3") of "$2}' | sed -e /^Use/d
printf '  Load:\t\t'; uptime | awk '{print $10,$11,$12}';
printf "  Who is on:\t"$USERS"\n"

printf "\n${r}============ USER ${z}\n"
printf "  User:\t\t"$ME" (uid:"$UID")\n"
printf "  Working dir:\t"$CPWD"\n"
printf "  Home dir:\t"$HOME"\n"

printf "\n${r}============ NETWORK ${z}\n"
printf "  Hostname:\t"$HOSTNAME"\n"
printf "  External IP:\t${b}"$MYIP"${z}\n"
printf "  Local IP:\t"
ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' | cut -d ":" -f2 
cat /etc/resolv.conf | awk '/^nameserver/{ printf "  Name Server:\t" $2 "\n"}'
printf "\n"


printf "${r}============ SERVICES ${z}\n"
serviceStatus apache2
serviceStatus mysql
serviceStatus bind9
#serviceStatus "ufw    "

printf "\n"
printf "\n"


exit 0
