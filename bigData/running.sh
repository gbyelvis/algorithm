#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Uages: You should enter DBUser UserPassWd"
    exit
else
    clear
    printf "\n\n\n\n\n\n"
    echo "Now! Running the procedures"
    sleep 1
    printf "\n\n\n"
    echo "Two step!!!"

    chmod u+x unzipdata.sh
    ./unzipdata.sh
    echo "---------------------------------------------------------------------"

    echo "[The fisrt step:]"


    chmod u+x sql2csv.sh
    ./sql2csv.sh $1 $2

    if [ $? -eq 0 ]
    then
        echo "---------------------------------------------------------------------"
        echo "[The second step]"
        chmod u+x datProcess.sh
        ./datProcess.sh $1 $2
        if [ $? -eq 0 ]
        then
            echo "It's overing!!!"
        else
            echo "Running ./modifyData.sh error"
            exit
        fi
    else
        echo "Running ./sql2csv.sh error"
        exit
    fi
fi
