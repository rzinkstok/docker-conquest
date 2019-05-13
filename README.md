# Conquest DICOM docker image

This is a simple dockerized version of the Conquest DICOM server (see https://github.com/marcelvanherk/Conquest-DICOM-Server). 
This docker image contains just the basic dgate executable without the web interface.
Configuration can be done by editing the `acrnema.map` and the `dicom.ini` files. After any edit of these
files, a new docker image should be built:

```
docker build -t rzinkstok/conquest .
```

The service can be started using `docker-compose`::

```
cd compose
docker-compose up -d
```

## Data folders

Data and the database are stored on volumes: the `compose/data` and `compose/dbase` are mounted in the container.

## To do

- Parametrize server parameters like AETitle and port number
- Move to serious database, using a separate MySQL or PostgreSQL container
- ...
