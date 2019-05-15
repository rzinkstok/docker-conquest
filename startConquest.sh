#!/bin/bash
DBFILE=/conquest/mount/dbase/conquest.db3
INITEMPLATE=/conquest/mount/config/dicom.ini.j2
INIFILE=/conquest/mount/config/dicom.ini

cd /conquest

# Create dicom.ini
cp $INITEMPLATE $INIFILE
sed -i "s/{{ AETITLE }}/$AETITLE/g" $INIFILE
sed -i "s/{{ PORT }}/$PORT/g" $INIFILE

# Init database
./dgate -v -w/conquest/mount/config -r

# Start the server
./dgate -v -w/conquest/mount/config

