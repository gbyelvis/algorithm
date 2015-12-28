#!/bin/bash


gzfile=`ls | grep *.tar.gz`

tar -xzvf $gzfile -C ~/

echo "eXtract all the files into exDir"
