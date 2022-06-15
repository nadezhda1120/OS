#!/bin/bash

F=$(mktemp)

cat $@ | while read line
do
echo "$line"
#egrep "^\-?[0-9]+$" $line >> $F
done
echo "$F"
max_value=$(cat $F| sort -rn |uniq | head -n 1)
A=$(cat $F| sort -nr | uniq | egrep "^\-?${max_value$}")

max=-1
B=0
while read line; do
        sum=$(cat $line | sort -n | uniq | tr -d '-' | sed 's/\([0-9]\)/+\1/g' | cut -d '+' -f2- | bc)
        if [  $sum -gt $max ]; then
                max=$sum
                B=$line
        fi
done<(cat "$F" | sort -n)

echo "$A \n"
echo "$B"


rm -f -- $F
