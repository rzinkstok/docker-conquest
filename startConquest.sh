#!/bin/bash
cd /conquest

#echo Starting Conquest
FILE=/conquest/mount/dbase/conquest.db3
if test -f "$FILE"; then
    echo "Database is already initialized"
else
    echo "Initializing database"
    ./dgate -v -w/conquest/mount/config -r &>> /conquest/mount/logs/serverstatus.log
fi
./dgate -v -w/conquest/mount/config &>> /conquest/mount/logs/serverstatus.log

