#!/bin/bash

if [ $# -ne 2 ]; then
        echo "Not enough arguments"; exit 1;
fi

created_file="${1}"
if [ ! -f $created_file ]; then
        touch $created_file
fi

echo "hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,VLAN Trunk Ports,license,SN,key" > $created_file
if [ -d "${2}" ]; then
        files=$( find $2 -type f -name "*.log")
        for file in $files
        do
                #delete everywhere whiotespaces
                hostname=$(echo "$file" | cut -d '.' -f1| cut -d '/' -f 2 | tr -d ' ')
                phy=$(cat $file | sed -n 2p | cut -d ':' -f2| tr -d ' ')
                vlans=$(cat $file| sed -n 3p | cut -d ':' -f2| tr -d ' ')
                hosts=$(cat $file| sed -n 4p | cut -d ':' -f2| tr -d ' ')
                failover=$(cat $file| sed -n 5p | cut -d ':' -f2| tr -d ' ')
                vpn=$(cat $file| sed -n 6p | cut -d ':' -f2| tr -d ' ')
                peers=$(cat $file| sed -n 7p | cut -d ':' -f2| tr -d ' ')
                vlan=$(cat $file| sed -n 8p | cut -d ':' -f2| tr -d ' ')
                licence=$(cat $file | sed -n 9p | cut -d ' ' -f 5- | sed  's/ license.//g' )
                sn=$(cat $file| sed -n 10p | cut -d ':' -f2| tr -d ' ')
                key=$(cat $file| sed -n 11p | cut -d ':' -f2| tr -d ' ')

                echo "$hostname,$phy,$vlans,$hosts,$failover,$vpn,$peers,$vlan,$licence,$sn,$key" >> $created_file
        done
fi
