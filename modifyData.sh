#!/bin/bash

#用户id，监测点id，表名字
userid=""
siteid=""
tableName=""

#中间变量
userId=""
temold=""
t1=""
t2=""
count=0
#标志变量
flag=1

#数据库路径
MYSQL=`which mysql`

#请求query
conn=$1" -u "$2" -pzxcvb0"

#键入参数
if [ $# -ne 3 ] && [ -f $3 ] #规范输入参数
then
    #显示提示信息
    echo "Usage: you should enter DBName、DBUser and SQLFile"
    exit
else
    #获取表名
    subhard=`head -n 10 $3 | sed -n '/^create/p'`
    array=($(echo $subhard | tr '`' ' ' | tr -s ' '))
    #echo ${array[2]}
    tableName=${array[2]}

    #请求tableName
    $MYSQL $conn -se 'show tables' | grep $tableName > /dev/null

    if [ $? -ne 0 ] #是否请求成功
    then
        $MYSQL $conn < $3  #导入数据
    fi

    #获取表头所需数据项属性
    $MYSQL $conn -se 'show columns from '$tableName | gawk '{print $1}' > tablehead.txt
    
    userid=`cat tablehead.txt | sed -n '/^u.*/p'`   
    siteid=`cat tablehead.txt | sed -n '/^si.*/p'`
fi

#建立临时文件
datatemptxt=`mktemp temptxt.XXXX`
datatempcsv=`mktemp tempcsv.XXXX`

numtotal=`$MYSQL $conn -se 'select count('$siteid') from '$tableName`
eachtotal=$(( numtotal / 50 ))
counter=0
inper=0
b=0
x="#"

#请求数据信息
$MYSQL $conn -se 'select '$siteid', '$userid' from '$tableName > $datatemptxt
#排序字段一，字段二，无重复值
cat $datatemptxt | tr -s ' ' | gawk '{$1=$1","; print $1 $2}' | sort -t ',' -k1 -k2 -u > $datatempcsv
#删除临时数据TXT
rm $datatemptxt
#末尾增加一行数据，以便处理
echo "ZZZZZZZZZZZZZZZZ,ZZZZZZZZZZZZZZZZ" >> $datatempcsv
cat $datatempcsv > s.csv
#读取临时文件数据
result=`cat $datatempcsv`
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
        echo $temold$userId >> finalData.csv
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

echo $numtotal
echo $counter

#删除临时数据CSV
rm $datatempcsv
