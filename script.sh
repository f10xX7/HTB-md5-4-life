#!/bin/bash
if [ -z $1 ]; then
  echo "Error: no URL specified!"
  echo "Usage: ./script.sh url"
  echo "Example: ./script.sh http://165.227.230.220:32568"
  exit 1
fi
# Get website and save it to site.txt
printf "$(curl -s ${1} -D -)" > site.txt
# extract cookie and md5 string
cookie="$(cat site.txt | sed '4!d' | cut -c 12-48)"
md5string="$(cat site.txt | sed '17!d' | cut -c 67-86)"
echo "md5 string is:" $md5string
echo "cookie is:" $cookie
# Get the hash of the md5 string
md5hash="$(echo -n $md5string | md5sum | cut -d' ' -f1)"
echo "md5 hash is:" $md5hash
# Pass the hashed string to the app and get flag
flag="$(curl -s -X POST -d "hash=$md5hash" ${1} -b "$cookie" | sed '6!d' | cut -c 110-133)"
echo "flag is:" $flag
