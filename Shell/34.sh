#!/bin/bash

if [ "${1}" == "-n" ]; then
        if [[ "${2}" =~ ^[[:digit:]]+$ ]]; then
                for file in "${@:3}"
                do
                        id=$( echo "$file" | cut -d '.' -f 1)
                        #data=$(cat $file |  awk '{$1=$2=""; $0=$0; $1=$1; print}')
                        #size=${#data}
                        cat $file | tail -n $2 | \
                                awk -v id="$id" -v data="$data" -v size="$size" '{print $1, $2, id, substr($0, index($0,$3))}'

                done |  sort -k 1,2

        fi

else
                for file in "${@}"
                do
                        id=$( echo "$file" | cut -d '.' -f 1)
                        #data=$(cat $file |  awk '{$1=$2=""; $0=$0; $1=$1; print}')
                        #size=${#data}
                        cat $file | tail -n 10 | \
                                awk -v id="$id" -v data="$data" -v size="$size" '{print $1, $2, id, substr($0, index($0,$3))}'

                done |  sort -k 1,2

fi

exit 0
