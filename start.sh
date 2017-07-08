#!/bin/bash
# emailcheck v0.1
# Made by Dr. Waldijk
# Check if an email exists or not.
# Read the README.md for more info.
# By running this script you agree to the license terms.
# -----------------------------------------------------------------------------------
EMCHNAM="emailcheck"
EMCHVER="0.1"
# telnet smtp.domain.com 25 << EOF
# echo "HELO domain.com"
# echo "MAIL FROM: <your@domain.com>"
# echo "RCPT TO: <check@domain.com>"
# echo "quit"
# EOF
{
#    sleep 3
    echo "HELO domain.com"
#    sleep 3
    echo "MAIL FROM: <your@domain.com>"
#    sleep 3
    echo "RCPT TO: <check@domain.com>"
#    sleep 3
    echo "quit"
} | telnet smtp.domain.com 25 | tee -a -i test.log
