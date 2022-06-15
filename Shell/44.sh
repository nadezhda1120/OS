#!/bin/bash

echo "#include <stdint.h>" >> $2

size=$(stat -c "%s" $1)
elements=$(echo "$size/2" | bc)
k=$(echo "$e*2"| bc)
if [ $k -ne $size]; then
        exit 1
fi

echo "uint32_t arrN = $e;" >> $2
echo "uint16_t arr[] = { " >> $2
xxd $1 | cut -c 6-48 | sed -E 's/([0-9a-f]{2})([0-9a-f]{2})/\2\1/g' | \
        tr ' ' '\n' | tr -s '\n' | sed -E 's/^(.{4})$/0x\1,/g' >> $2
echo "}" >> $2
