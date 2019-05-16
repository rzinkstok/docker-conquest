#!/bin/bash
DBFILE=/conquest/mount/dbase/conquest.db3
INITEMPLATE=/conquest/mount/config/dicom.ini.j2
INIFILE=/conquest/mount/config/dicom.ini
CONVERTERFILE=/conquest/mount/config/converters.txt
ACRNEMAFILE=/conquest/mount/config/acrnema.map

cd /conquest

# Create dicom.ini
cp $INITEMPLATE $INIFILE
dos2unix $INIFILE
sed -i "s/{{ AETITLE }}/$AETITLE/g" $INIFILE
sed -i "s/{{ PORT }}/$PORT/g" $INIFILE
cnt=0

while read p; do
    echo "ImportConverter$cnt = $p" >> $INIFILE
    let "cnt++"
done < $CONVERTERFILE

# Ensure the server is listed in acrnema.map
dos2unix $ACRNEMAFILE
LINE="$AETITLE    127.0.0.1    $PORT    un"
grep -qxF $LINE $ACRNEMAFILE || echo $LINE >> $ACRNEMAFILE 

# Init database
./dgate -v -w/conquest/mount/config -r

# Start the server
echo Starting Conquest server $AETITLE at port $PORT
./dgate -v -w/conquest/mount/config

