
```
#!/bin/bash

if [ $# -gt 2 ] || [ $# -lt 1 ]; then
        echo "wrong number of arguments";
        exit 1;
fi

if [ ! -d $1 ]; then
        echo "First argumnet should be dir";
        exit 2;
fi

if [ $# -eq 2  ]; then
        if [[  $2 =~ ^[0-9]+$ ]]; then
                find $1 -type f -printf "%p#%n\n"| awk -F '#' -v num=$2 '{if($2>=num)print $1}'
        else
                echo "Second argument should be number";
                exit 3;
        fi
else
        find -L $1 -type l
fi

```
