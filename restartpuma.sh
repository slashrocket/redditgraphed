#!/bin/sh
ps auxw | grep puma | grep -v grep > /dev/null

if [ $? != 0 ]
then
	puma -p 3000 > /dev/null
fi
