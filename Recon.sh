#!/bin/bash

TARGET=/home/user/dir/subPull/targets.txt #targets file
d=$(date +"%m-%d-%Y") #today
y_date=$( date -d "yesterday" '+%m-%d-%Y' ) #Yesterday
LSCAN=subdomains_$y_date.txt #Last scan

# Tools for Subdomain enumeration

subfinder='/home/user/go/bin/subfinder'
sublist3r='python3 /home/user/dir/of/Sublist3r/sublist3r.py'
assetfinder='/home/user/go/bin/assetfinder'

for t in $(cat $TARGET)
do
    DIR=/home/user/dir/subPull/$t
    if [ ! -d "$DIR" ]
    then
        mkdir $DIR
    fi

    echo "[   [+] =====  SUBDOMAINS ENUMERATION ON $t  =====  ]"
    echo "[   [+] FINDING SUBDOMAINS WITH SUBFINDER   ]"
    $subfinder -d $t -silent -o $DIR/subfinder_$d.txt --silent
    echo "[   [+] FINDING SUBDOMAINS WITH SUBLIST3R   ]"
    $sublist3r -d $t -o $DIR/sublist3r_$d.txt
    echo "[   [+] FINDING SUBDOMAINS WITH ASSETFINDER   ]"
    $assetfinder $t |grep ${TARGET%%\.*}|tee -a $DIR/assetF_$d.txt

    cat $DIR/*_$d.txt|sort -u|tee -a $DIR/subdomains_$d.txt #all subdomains

    if [ -f "$DIR/$LSCAN" ]
    then
        comm -13 <( sort $DIR/$LSCAN ) <( sort $DIR/subdomains_$d.txt ) > $DIR/newsubds_on_$d.txt
        echo "[   TOTAL SUBDOMAINS => $(cat $DIR/subdomains_$d.txt|wc -l)    ]"
        echo ""
        echo "[    NEW SUBDOMAINS => $(cat $DIR/newsubds_on_$d.txt|wc -l)  ]"
        echo ""
        sleep 3.5
        cat newsubds_on_$d.txt
        rm $DIR/subfinder_$d.txt $DIR/sublist3r_$d.txt $DIR/assetF_$d.txt

    else
        echo "[   TOTAL SUBDOMAINS => $(cat $DIR/subdomains_$d.txt|wc -l)    ]"
        echo ""
        rm $DIR/subfinder_$d.txt $DIR/sublist3r_$d.txt $DIR/assetF_$d.txt
    fi
done

# Merge all subdomain files into a single file and remove duplicates
cat /home/user/dir/subPull/*/*/subdomains_$d.txt | sort -u > /home/user/dir/subPull/domains.txt
