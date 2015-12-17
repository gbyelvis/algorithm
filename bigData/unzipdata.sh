#!/bin/bash

mkdir ~/bigData

zipfile=`ls | grep *.zip`

unzip $zipfile -d ~/bigData

echo "eXtract all the files into exDir"
