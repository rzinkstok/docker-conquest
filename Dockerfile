FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y build-essential g++ wget zip unzip sudo dos2unix

RUN mkdir -p /conquest/data
RUN mkdir -p /conquest/dbase

RUN wget http://ingenium.home.xs4all.nl/dicomserver/dicomserver1419d.zip
RUN mkdir /temp
RUN cd temp && unzip ../dicomserver1419d.zip
RUN rm dicomserver1419d.zip

RUN dos2unix /temp/maklinux
RUN chmod 777 /temp/maklinux
RUN cd /temp && printf "3\n" | ./maklinux

RUN cp /temp/dgate /conquest/.
RUN cp /temp/dgate.dic /conquest/.
RUN cp /temp/dicom.sql /conquest/.

RUN touch /conquest/serverstatus.log
RUN touch /conquest/PacsTrouble.log
COPY acrnema.map /conquest/
COPY dicom.ini /conquest/
COPY startConquest.sh /conquest/
RUN chmod 777 /conquest/startConquest.sh

RUN touch /conquest/serverstatus.log

CMD ["/conquest/startConquest.sh"]
