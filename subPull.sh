#!/bin/bash

TARGET=/home/user/dir/subPull/targets.txt #targets file
d=$(date +"%m-%d-%Y") #today
y_date=$( date -d "yesterday" '+%m-%d-%Y' ) #Yesterday
LSCAN=subdomains_$y_date.txt #Last scan

#COLORS     
Red=$'\e[1;31m'
Green=$'\e[1;32m'
Blue=$'\e[1;34m'

#  Telegram Variables

user_telegram="[USER_TELEGRAM_ID]"
key_telegram="[TELEGRAM_KEY]"
telegram_alert="/usr/local/sbin/telegram-notify --quiet --user $user_telegram --key $key_telegram"

#  Tools for Subdomain enumeration

subfinder='/home/user/go/bin/subfinder'
sublist3r='python3 /home/user/dir/of/Sublist3r/sublist3r.py'
assetfinder='/home/user/go/bin/assetfinder'


for t in $(cat $TARGET)
    do
        DIR=/home/user/dir/subPull/$t
        if [ ! -d "$DIR" ];
            then
            mkdir $DIR
        fi
        $telegram_alert --warning --title "SUBDOMAINS ENUMERATION ON $t" 
        echo "$Blue[   [+] =====  SUBDOMAINS ENUMERATION ON $t  =====  ]"
        echo "$Green[   [+] FINDING SUBDOMAINS WITH SUBFINDER   ]"
        $subfinder -d $t -silent -o $DIR/subfinder_$d.txt --silent
        echo "$Green[   [+] FINDING SUBDOMAINS WITH SUBLIST3R   ]"
        $sublist3r -d $t -o $DIR/sublist3r_$d.txt
        echo "$Green[   [+] FINDING SUBDOMAINS WITH ASSETFINDER   ]"
        $assetfinder $t |grep ${TARGET%%\.*}|tee -a $DIR/assetF_$d.txt

        cat $DIR/*_$d.txt|sort -u|tee -a $DIR/subdomains_$d.txt #all subdomains

        if [ -f "$DIR/$LSCAN" ];
            then
            comm -13 <( sort $DIR/$LSCAN ) <( sort $DIR/subdomains_$d.txt ) > $DIR/newsubds_on_$d.txt
            echo "$Blue [   TOTAL SUBDOMAINS => $Red $(cat $DIR/subdomains_$d.txt|wc -l) $Blue    ]"
            echo ""
            echo "$Blue[    NEW SUBDOMAINS => $Red $(cat $DIR/newsubds_on_$d.txt|wc -l) $Blue  ]"
            echo ""
            sleep 3.5
            cat newsubds_on_$d.txt
            $telegram_alert --text "$(cat $DIR/subdomains_$d.txt|wc -l) SUBDOMAINS ON $t!" --success 
            $telegram_alert --file $DIR/newsubds_on_$d.txt --WARNING --title "$(cat $DIR/newsubds_on_$d.txt|wc -l) NEW SUBDOMAINS!!"
            $telegram_alert --title "=============================="

            rm $DIR/subfinder_$d.txt $DIR/sublist3r_$d.txt $DIR/assetF_$d.txt

        else
            echo "$Blue [   TOTAL SUBDOMAINS => $Red $(cat $DIR/subdomains_$d.txt|wc -l) $Blue    ]"
            echo ""
            $telegram_alert --text "$(cat $DIR/subdomains_$d.txt|wc -l) SUBDOMAINS ON $t!" --success 
            $telegram_alert --document $DIR/subdomains_$d.txt
            $telegram_alert --title "=============================="
            rm $DIR/subfinder_$d.txt $DIR/sublist3r_$d.txt $DIR/assetF_$d.txt
        fi
    done