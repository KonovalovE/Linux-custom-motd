#!/bin/bash

# =======================================================
#	FILE: custom-motd.sh
#
#	DESCRIPTION: Custom MOTD script 
#
#	AUTHOR: Evgeny Konovalov
#	E-MAIL: kev@modbon.ru
#	WWW: https://modbon.ru
#
#	VERSION: 1.7
#	CREATED: 18/05/2023
# =======================================================

## version
VERSION="MOTD v1.7"

## configuration and logfile
ENVFILE="/opt/.CNTEC/environment.cfg"

## MOTD theme scheme
F1="\033[0;32m"
F2="\033[0;32m"
F3="\033[1;32m"
F4="\033[0;31m"

## create .environment file if not exist
function createenv {

        echo "We want to assign a function name for $(hostname --fqdn)"
        echo
        echo -n "System Function [${1}]: "
        read SYSFUNCTION
    	echo -n "System Environment, like PRD|TST|ITG [${2}]: "
    	read SYSENV
        echo -n "Service Level Agreement, like SLA1|SLA2|SLA3: [${3}] "
        read SYSSLA
        echo -n "Brief description of the system: [${4}] "
        read SYSNOTE
        echo -n "Only for ROOT (Y/N): [${5}] "
        read ONLY_ROOT
        echo -n "Show system information (Y/N): [${6}] "
        read SYSTEM_INFO
        echo -n "Show environement information (Y/N): [${7}] "
        read ENVIRONMENT_INFO
        echo -n "Show storage information (Y/N): [${8}] "
        read STORAGE_INFO
        echo -n "Show some user infomration (Y/N): [${9}] "
        read USER_INFO
        rm -rf $ENVFILE
        mkdir -p $(dirname $ENVFILE)
        touch $ENVFILE
        chmod 644 $ENVFILE
       	echo "SYSENV=\"$SYSENV\"" >> $ENVFILE
       	echo "SYSFUNCTION=\"$SYSFUNCTION\"" >> $ENVFILE
        echo "SYSSLA=\"$SYSSLA\"" >> $ENVFILE
        echo "SYSNOTE=\"$SYSNOTE\"" >> $ENVFILE
        echo "ONLY_ROOT=\"$ONLY_ROOT\"" >> $ENVFILE
        echo "SYSTEM_INFO=\"$SYSTEM_INFO\"" >> $ENVFILE
        echo "ENVIRONMENT_INFO=\"$ENVIRONMENT_INFO\"" >> $ENVFILE
        echo "STORAGE_INFO=\"$STORAGE_INFO\"" >> $ENVFILE
        echo "USER_INFO=\"$USER_INFO\"" >> $ENVFILE
}

if [ ! -f $ENVFILE ]; then
	createenv ;
fi
source $ENVFILE
if [ -z "${SYSFUNCTION}" ] || [ -z "${SYSENV}" ] || [ -z "${SYSSLA}" ] || [ -z "${SYSNOTE}" ] || [ -z "${ONLY_ROOT}" ] || [ -z "${SYSTEM_INFO}" ] || [ -z "${ENVIRONMENT_INFO}" ] || [ -z "${STORAGE_INFO}" ] || [ -z "${USER_INFO}" ]; then
	rm $ENVFILE
	createenv ;	
fi

## don't start as root
if [[ "$ONLY_ROOT" = "Y" || "$ONLY_ROOT" = "y" ]]; then

	if [ $(whoami) != root ]; then
		cat /etc/motd
		exit 0
	fi
fi

## System Info
function show_system_info () {

    if [[ "$SYSTEM_INFO" = "Y" || "$SYSTEM_INFO" = "y" ]]; then

        HOSTNAME=$(hostname --fqdn)
        IP=$(/sbin/ip -o -4 addr list ens18 | awk '{print $4}' | cut -d/ -f1)
        UNAME=$(uname -r)
        DISTRIBUTION=$(lsb_release -s -d)
        PLATFORM=$(uname -m)
        UPTIME=$(uptime |cut -c2- |cut -d, -f1)
        CPUS=$(cat /proc/cpuinfo|grep processor|wc -l)
        CPUMODEL=$(cat /proc/cpuinfo |egrep 'model name' |uniq |awk -F ': ' {'print $2'})
        MEMFREE=$(echo $(cat /proc/meminfo |egrep MemFree |awk {'print $2'})/1024 |bc)
        MEMMAX=$(echo $(cat /proc/meminfo |egrep MemTotal |awk {'print $2'})/1024 |bc)
        SWAPFREE=$(echo $(cat /proc/meminfo |egrep SwapFree |awk {'print $2'})/1024 |bc)
        SWAPMAX=$(echo $(cat /proc/meminfo |egrep SwapTotal |awk {'print $2'})/1024 |bc)
        PROCCOUNT=$(ps -Afl |egrep -v 'ps|wc' |wc -l)
        PROCMAX=$(ulimit -u)

## display system information
echo -e "
${F2}============[ ${F1}System Info${F2} ]================================[ ${F1} $VERSION ${F2} ]=====
${F1}        Hostname ${F2}= ${F3}$HOSTNAME
${F1}         Address ${F2}= ${F3}$IP
${F1}          Kernel ${F2}= ${F3}$UNAME
${F1}    Distribution ${F2}= ${F3}$DISTRIBUTION ${PLATFORM}
${F1}          Uptime ${F2}= ${F3}$UPTIME
${F1}             CPU ${F2}= ${F3}$CPUS x $CPUMODEL
${F1}          Memory ${F2}= ${F3}$MEMFREE MB Free of $MEMMAX MB Total
${F1}     Swap Memory ${F2}= ${F3}$SWAPFREE MB Free of $SWAPMAX MB Total
${F1}       Processes ${F2}= ${F3}$PROCCOUNT of $PROCMAX MAX${F1}"

    fi
}

## Storage Informations
function show_storage_info () {

    if [[ "$STORAGE_INFO" = "Y" || "$STORAGE_INFO" = "y" ]]; then

        STORAGE=$(df -hT |sort -r -k 6 -i |sed -e 's/^File.*$/\x1b[0;37m&\x1b[1;32m/' |sed -e 's/^Datei.*$/\x1b[0;37m&\x1b[1;32m/' |egrep -v docker )

## display storage information
echo -e "
${F2}============[ ${F1}Storage Info${F2} ]===================================================
${F3}${STORAGE}${F1}"

    fi
}

## User Informations
function show_user_info () {

    if [[ "$USER_INFO" = "Y" || "$USER_INFO" = "y" ]]; then

        WHOIAM=$(whoami)
        GROUPZ=$(groups)
        ID=$(id)
        SESSIONS=$(who |wc -l)
        LOGGEDIN=$(echo $(who |awk {'print $1" " $5'} |awk -F '[()]' '{ print $1 $2 '}  |uniq -c |awk {'print "(" $1 ") "$2" " $3","'} ) |sed 's/,$//' |sed '1,$s/\([^,]*,[^,]*,[^,]*,\)/\1\n\\033[1;32m\t          /g')
        SYSTEMUSERCOUNT=$(cat /etc/passwd |egrep '\:x\:10[0-9][0-9]' |grep '\:\/bin\/bash' |wc -l)
        SYSTEMUSER=$(cat /etc/passwd |egrep '\:x\:10[0-9][0-9]' |egrep '\:\/bin\/bash|\:\/bin/sh' |awk '{if ($0) print}' |awk -F ':' {'print $1'} |awk -vq=" " 'BEGIN{printf""}{printf(NR>1?",":"")q$0q}END{print""}' |cut -c2- |sed 's/ ,/,/g' |sed '1,$s/\([^,]*,[^,]*,[^,]*,[^,]*,[^,]*,\)/\1\n\\033[1;32m\t          /g')
        SUPERUSERCOUNT=$(cat $HOME/.ssh/authorized_keys |egrep '^ssh-' |wc -l)
        SUPERUSER=$(cat $HOME/.ssh/authorized_keys |egrep '^ssh-' |awk '{print $NF}' |awk -vq=" " 'BEGIN{printf""}{printf(NR>1?",":"")q$0q}END{print""}' |cut -c2- |sed 's/ ,/,/g' |sed '1,$s/\([^,]*,[^,]*,[^,]*,\)/\1\n\\033[1;32m\t          /g' )
        KEYUSERCOUNT=$(for i in $(cat /etc/passwd |egrep '\:x\:10[0-9][0-9]' |awk -F ':' {'print $6'}) ; do cat $i/.ssh/authorized_keys  2> /dev/null |grep ^ssh- |awk '{print substr($0, index($0,$3)) }'; done |wc -l)
        KEYUSER=$(for i in $(cat /etc/passwd |egrep '\:x\:10[0-9][0-9]' |awk -F ':' {'print $6'}) ; do cat $i/.ssh/authorized_keys  2> /dev/null |grep ^ssh- |awk '{print substr($0, index($0,$3)) }'; done |awk -vq=" " 'BEGIN {printf ""}{printf(NR>1?",":"")q$0q}END{print""}' |cut -c2- |sed 's/ , /, /g' |sed '1,$s/\([^,]*,[^,]*,[^,]*,\)/\1\n\\033[1;32m\t          /g'  )

## show user information
echo -e "
${F2}============[ ${F1}User Data${F2} ]======================================================
${F1}    Your Username ${F2}= ${F3}$WHOIAM
${F1}  Your Privileges ${F2}= ${F3}$ID
${F1} Current Sessions ${F2}= ${F3}[$SESSIONS] $LOGGEDIN
${F1}      SystemUsers ${F2}= ${F3}[$SYSTEMUSERCOUNT] $SYSTEMUSER
${F1}  SshKeyRootUsers ${F2}= ${F3}[$SUPERUSERCOUNT] $SUPERUSER
${F1}      SshKeyUsers ${F2}= ${F3}[$KEYUSERCOUNT] $KEYUSER${F1}"

    fi
}

## Environment Informations
function show_environment_info () {

    if [[ "$ENVIRONMENT_INFO" = "Y" || "$ENVIRONMENT_INFO" = "y" ]]; then

## display environment information
echo -e "
${F2}============[ ${F1}Environment Data${F2} ]===============================================
${F1}        Function ${F2}= ${F3}$SYSFUNCTION
${F1}     Environment ${F2}= ${F3}$SYSENV
${F1}   Service Level ${F2}= ${F3}$SYSSLA${F1}
${F1}            NOTE ${F2}= ${F3}$SYSNOTE${F1}"

    fi
}

## Environment Informations
function show_end () {

## display environment information
echo -e "
${F2}============[ ${F1}END${F2} ]============================================================
${F1} 
${F1}" 

}

## Display Output
function show_info () {
clear
    show_system_info
    show_environment_info
    show_storage_info
    show_user_info
    show_end
}

#### Main Part

## if no parameter is passed then start show_info
if [ -z "$1" ]; then
    show_info
fi
