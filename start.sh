#!/bin/bash
# emailcheck v0.2
# Made by Dr. Waldijk
# Check if an email exists or not.
# Read the README.md for more info.
# By running this script you agree to the license terms.
# Standard --------------------------------------------------------------------------
EMCHNAM="emailcheck"
EMCHVER="0.2"
# Config ----------------------------------------------------------------------------
EMCHYOU=$1
EMCHCHK=$2
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
    } | tee -a -i $EMCHFIL.log | telnet $EMCHSMTP 25 | tee -a -i $EMCHFIL.log
else
    echo "$EMCHNAM v$EMCHVER"
    echo "emailcheck <your email address> <email address you want to verify>"
fi
