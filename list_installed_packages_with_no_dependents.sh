#!/bin/bash

# Define output filename
filename=packages_no_dependents.txt

# Write heading to file
echo "The following packages are not a dependency to any installed package:" > $filename

# Get all installed packages that do not have a 'Priority' of 'required', 'important' or 'standard' and do not have packages that depend on them
dpkg-query -Wf '${Package} ${Status;-26}${Priority}\n' | grep -v 'required\|important\|standard' | grep 'installed' | awk '{ print $1 }' |
xargs apt-cache rdepends --installed |
awk '! /Reverse Depends:/ {
    tp = $0
    n++
}

/Reverse Depends:/ {
    if (n == 1 && NR != 2) {
        print p
    }
    n = 0
    p = tp
}

END {
    if (n == 0) {
        print p
    }
}
' | tee -a $filename

# Remove leading white-space in file
sed -i '3,$s/\s*//' $filename
