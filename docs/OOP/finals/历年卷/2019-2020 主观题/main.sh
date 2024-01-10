#! /bin/bash
g++ -o test src/test.cpp 
hello=`./test $1`
if [ "$hello" == "hello world" ]
then
echo 100 > $1
else
echo 0 > $1
fi

