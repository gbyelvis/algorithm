#!/bin/bash

counter=0
x=""

MYSQL=`which mysql`

conn=" -u "$1" -p"$2

db="bigData"

userid=""
siteid=""
#datatemptxt=`touch sql.txt`
#datatempcsv=`touch datatemp.csv`

$MYSQL $conn -se 'show databases' | grep $db >/dev/null

if [ $? -ne 0 ]
then
    $MYSQL $conn -e ' create database '$db
fi

conn=$db" -u "$1" -p"$2

sqlpath="./sql/"

sqlls=`ls $sqlpath | grep r*.sql`

sq=`echo $sqlls | gawk '{print $1}'`

head -n 11 $sqlpath$sq | tr '`' ' ' | tr -s ' ' | sed -n '/.*_id/p' > tablehead.txt

u=($(cat tablehead.txt | sed -n '/user_id/p'))
userid=${u[0]}
echo $userid
s=($(cat tablehead.txt | sed -n '/site_id/p'))
siteid=${s[0]}
echo $siteid
rm tablehead.txt


for sqlt in $sqlls
do
    $MYSQL $conn < $sqlpath$sqlt
done


tables=`$MYSQL $conn -se 'show tables'`

echo $tables > tables.txt

if [ $? -ne 0 ]
then
    echo "Uages:mysql show tables error"
    exit
fi

for subT in $tables
do
    $MYSQL $conn -se 'select '$siteid', '$userid' from '$subT > sql.txt

    cat sql.txt | tr -s ' ' | gawk '{$1=$1","; print $1 $2}' >> sql.csv
    
    counter=$(( $counter + 5 ))
    printf "[%-40s]%d%%\r" $x $counter
    x=##$x
done

echo "ZZZZZZZZZZZZZZZZ,ZZZZZZZZZZZZZZZZ" >> sql.csv

rm sql.txt

