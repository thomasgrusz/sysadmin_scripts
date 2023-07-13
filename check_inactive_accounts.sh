#!/bin/bash
# This script checks which accounts have not logged in within a specified number of days.

# set inactivity threshold in days
read -p "Set number of days without login (default=30): " threshold
# set default of 30 days of user input is empty
threshold=${threshold:-30}
# check user input to be numeric or exit with error
[[ "$threshold" =~ ^[0-9]+$ ]] || exit 1

echo

# print accounts and login date/time in the inactivity period
echo "These accounts have not logged into the system within the last $threshold days:"
echo "---------------------------------------------------------------------------"
grep -Ev '(nologin$|false$)' /etc/passwd | cut -d: -f 1 | xargs -Iaccountname lastlog -b ${threshold} -u accountname | sed '/^Username/d'

exit 0
