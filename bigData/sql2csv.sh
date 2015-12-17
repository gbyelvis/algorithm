#!/bin/bash

counter=0
x=""

MYSQL=`which mysql`

conn=" -u "$1" -p"$2

db="bigData"

userid=""
siteid=""
datatemptxt=`mktemp temptxt.XXXX`
datatempcsv=`touch datatemp.csv`

$MYSQL $conn -se 'show databases' | grep $db >/dev/null

if [ $? -ne 0 ]
then
    $MYSQL $conn -e ' create database '$db
fi

conn=$db" -u "$1" -p"$2

sqlpath="./sql/"

sqlls=`ls $sqlpath | grep *.sql`

sq=`echo $sqlls | grep *1.sql`

head -n 11 $sq | tr '`' ' ' | tr -s ' ' | sed -n '/.*_id/p' > tablehead.txt

u=($(cat tablehead.txt | sed -n '/user_id/p'))
userid=${u[0]}

s=($(cat tablehead.txt | sed -n '/site_id/p'))
siteid=${s[0]}

rm tablehead.txt

for sqlt in $sqlls
do
    $MYSQL $conn < $sqlpath$sqlt
done

tables=`$MYSQL $conn -se 'show tables'`

cat $tables > tables.txt

if [ $? -ne 0 ]
then
    echo "Uages:mysql show tables error"
    exit
fi

for subT in $tables
do
    $MYSQL $conn -se 'select '$siteid', '$userid' from '$subT > $datatemptxt
    cat $datatemptxt | tr -s ' ' | gawk '{$1=$1","; print $1 $2}' | sort -t ',' -k1 -k2 -u >> $datatempcsv
    counter=$(( $counter + 5 ))
    printf "[%-40s]%d%%\r" $x $counter
    x=##$x
done

echo "ZZZZZZZZZZZZZZZZ,ZZZZZZZZZZZZZZZZ" >> $datatempcsv

rm $datatemptxt

