#!/bin/bash

cat xs/*.xs | grep -o -E $1'_\w+' | sort | uniq > /tmp/git2-perl.txt
cat /usr/local/include/git2/*.h | grep -o -E $1'_\w+' | sort | uniq > /tmp/git2-c.txt

sdiff /tmp/git2-perl.txt /tmp/git2-c.txt;
echo "----------------------"
cat /tmp/git2-c.txt
