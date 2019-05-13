#!/bin/bash
cd /conquest

#echo Starting Conquest
if [ "$(ls -A dbase)" ]; then
    echo "Database is already initialized"
else
    echo "Initializing database"
    ./dgate -v -r >> serverstatus.log
fi
./dgate -v >> serverstatus.log

