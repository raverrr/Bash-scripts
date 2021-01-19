#!/bin/bash

##
##TODO:ad output
##
echo "==========================================================="
echo "                Finds lots of endpoints."
echo "Single mode will extract endpoints from a single website"
echo "Mass mode will enumerate subdomains and extract for each"
echo "==========================================================="
echo ""
while true; do
    read -p "Do you want to work in 'single mode' or 'mass mode'(S/M)?" sm
    case $sm in
        [Ss]* ) read -p "Enter URL: " SURL
                echo "********** $SURL **********"
                curl -Lks $SURL | tac | sed "s#\\\/#\/#g" | egrep -o "src['\"]?\s*[=:]\s*['\"]?[^'\"]+.js[^'\"> ]*" | sed -r "s/^src['\"]?[=:]['\"]//g" | awk -v url=$URL '{if(length($1)) if($1 ~/^http/) print $1; else if($1 ~/^\/\//) print "https:"$1; else print url"/"$1}' | sort -fu | xargs -I '%' sh -c "echo \"'##### %\";curl -k -s \"%\" | sed \"s/[;}\)>]/\n/g\" | grep -Po \"('#####.*)|(['\\\"](https?:)?[/]{1,2}[^'\\\"> ]{5,})|(\.(get|post|ajax|load)\s*\(\s*['\\\"](https?:)?[/]{1,2}[^'\\\"> ]{5,})\" | sort -fu" | tr -d "'\""
               echo ""
                 break;;
        [Mm]* ) read -p "Enter domain only: " MURL
                ~/go/bin/assetfinder --subs-only $MURL | ~/go/bin/httprobe | tee -a TEMP.txt | while read line
                do
               echo ""
               echo "*********** $line ************" 
               curl -Lks $line | tac | sed "s#\\\/#\/#g" | egrep -o "src['\"]?\s*[=:]\s*['\"]?[^'\"]+.js[^'\"> ]*" | sed -r "s/^src['\"]?[=:]['\"]//g" | awk -v url=$URL '{if(length($1)) if($1 ~/^http/) print $1; else if($1 ~/^\/\//) print "https:"$1; else print url"/"$1}' | sort -fu | xargs -I '%' sh -c "echo \"'##### %\";curl -k -s \"%\" | sed \"s/[;}\)>]/\n/g\" | grep -Po \"('#####.*)|(['\\\"](https?:)?[/]{1,2}[^'\\\"> ]{5,})|(\.(get|post|ajax|load)\s*\(\s*['\\\"](https?:)?[/]{1,2}[^'\\\"> ]{5,})\" | sort -fu" | tr -d "'\""
               echo ""
               done 
               rm TEMP.txt
               break;;
        * ) echo "S=Single mode, M=Mass mode. Choose one";;
    esac
done 

