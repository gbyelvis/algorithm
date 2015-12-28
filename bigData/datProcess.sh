#!/bin/bash


#中间变量
userId=""
temold=""
t1=""
t2=""
count=0
#标志变量
flag=1

numtotal=0

DB="bigData"

MYSQL=`which mysql`

conn=$DB" -u "$1" -p"$2

tabresult=`cat tables.txt`

rm tables.txt

for tab in $tabresult
do
    a=`$MYSQL $conn -se 'select count('"id"') from '$tab`

    numtotal=$(( $numtotal + $a ))

done

eachtotal=$(( numtotal / 50 ))
counter=0
inper=0
b=0
x="#"


#读取临时文件数据
result=`cat sql.csv | sort -t ',' -k1 -k2 -u`
#cat #result
#遍历数据
for subres in $result
do
    #分割每行数据
    temp=`echo $subres | gawk -F, '{print $1,$2}'`
   # echo $temp
    #分别处理每行数据，将用户id和监测点id抽离出来
    for sub in $temp
    do
        if [ $count -eq 0 ]
        then 
            t1=$sub
            count=1
        else
            t2=$sub
            count=0
        fi
    done

    #处理监测点为空的情况
    if [ $t1 = NULL ]
    then 
        continue
    fi

    #处理首行数据
    if [ $flag -eq 1 ]
    then
        temold=$t1
        flag=0
    fi
    
    #将文件存储入finalData.csv文件
    if [ $temold = $t1 ]
    then
        userId=$userId","$t2
    else
        echo $temold$userId >> ~/bigData/finalData.csv
        temold=$t1
        userId=","$t2
    fi

    #进度条
    counter=$(( $counter + 1 ))
    b=$(( $counter % $eachtotal ))
    
    if (( $b == 0 ))
    then
        inper=$(( $inper + 2 ))
        printf "[%-50s]%d%%\r" $x $inper
        x=#$x
    fi
done
echo

#echo $numtotal
#echo $counter

#删除临时数据CSV
#rm $datatempcsv
