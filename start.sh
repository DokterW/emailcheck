#!/bin/bash
# emailcheck v0.3
# Made by Dr. Waldijk
# Check if an email exists or not.
# Read the README.md for more info.
# By running this script you agree to the license terms.
# Standard --------------------------------------------------------------------------
EMCHNAM="emailcheck"
EMCHVER="0.3"
# Config ----------------------------------------------------------------------------
EMCHYOU=$1
EMCHCHK=$2
# If you create a file called as seen below, that will be the default save location.
if [ -f /home/$USER/.dokter/emailcheck/EMCHLOC ]; then
    EMCHLOC=$(cat /home/$USER/.dokter/emailcheck/EMCHLOC)
elif [ -n "$3" ]; then
    EMCHLOC=$3
fi
# -----------------------------------------------------------------------------------
# telnet smtp.domain.com 25 << EOF
# echo "HELO domain.com"
# echo "MAIL FROM: <your@domain.com>"
# echo "RCPT TO: <check@domain.com>"
# echo "quit"
# EOF
if [ -n "$EMCHYOU" ] && [ -n "$EMCHCHK" ]; then
    EMCHHEL=$(echo $EMCHYOU | sed -r 's/.*@(.*)/\1/')
    EMCHDOM=$(echo $EMCHCHK | sed -r 's/.*@(.*)/\1/')
#    EMCHSMTP=$(nslookup -type=MX $EMCHDOM | grep ' 5 ' | sed -r 's/.*\s5\s(.*)\./\1/')
    EMCHSMTP=$(nslookup -type=MX $EMCHDOM | grep 'mail exchanger' | sed -r 's/.*=\s(.*)/\1/g' | sort -n | sed -r 's/.*\s(.*)/\1/g' | sed -n '1p')
    EMCHFIL=$(echo "$EMCHCHK" | sed -r 's/@//' | sed -r 's/\.//g' | sed -r 's/-//g' | sed -r 's/_//g')
#    echo "[$EMCHCHK]" | tee -a -i $EMCHFIL.log
    {
        sleep 3
        echo "HELO $EMCHHEL"
        sleep 1
        echo "MAIL FROM: <$EMCHYOU>"
        sleep 1
        echo "RCPT TO: <$EMCHCHK>"
        sleep 1
        echo "QUIT"
    } | tee -a -i $EMCHLOC$EMCHFIL.log | telnet $EMCHSMTP 25 | tee -a -i $EMCHLOC$EMCHFIL.log
else
    echo "$EMCHNAM v$EMCHVER"
    echo "emailcheck <your email address> <email address you want to verify> <location of file>"
fi
