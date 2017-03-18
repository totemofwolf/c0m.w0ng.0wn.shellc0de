#!/bin/bash

mysql_secure_installation << EOF
`tail -n1 account.log | awk -F ':' '{print $2}'`
n
y
y
y
y

EOF
