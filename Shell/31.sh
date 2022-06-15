#!/bin/bash

if [ $# -ne 2 ] || [ ! -d $2  ] || [ ! -f $1 ]; then
        echo "Invalid argments";
        exit 1 ;
fi


check=$(find $2 -empty -exec echo {}  empty \;)

if [[ ! $check =~ .*empty$ ]]; then
        echo "dir is not empty"
        exit 2
fi

touch ./$2/dist.txt

cat $1 | sort | uniq | cut -d ':' -f 1 | cut -d '(' -f1 | awk 'BEGIN{total=0}{print $0";"total; total+=1}' > ./$2/dist.txt


while read line; do
        filename=$(echo "$line" | cut -d ';' -f2)
        touch ./$2/$filename

        cat $1 | egrep "$(echo "$line" | cut -d ';' -f1)" > ./$2/$filename

done < <(cat ./$2/dist.txt)
