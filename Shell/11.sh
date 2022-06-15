#!/bin/bash

directories=$(find /home/students -maxdepth 1 -name "s*" -printf "%P %C@\n" | awk -F ' ' '{if ( $2>=1621168000 && $2<=1627676101){print $0}}' | cut -d ' ' -f1)



while read line
do
        fn=$(cat /etc/passwd | grep "$line" | cut -d ':' -f1 | cut -c 2-)
        name=$(cat /etc/passwd | grep "$line" | cut -d ':' -f5 | grep -o "[[:alpha:]]\+ [[:alpha:]]\+")
        echo "$fn  $name"
done < <(echo "$directories")
