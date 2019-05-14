#!/bin/bash
cd /conquest

#echo Starting Conquest
FILE=/conquest/dbase/conquest.db3
if test -f "$FILE"; then
    echo "Database is already initialized"
else
    echo "Initializing database"
    ./dgate -v -w/conquest/config -r &>> /conquest/logs/serverstatus.log
fi
./dgate -v -w/conquest/config &>> /conquest/logs/serverstatus.log

