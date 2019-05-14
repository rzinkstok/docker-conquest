FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y build-essential g++ wget zip unzip sudo dos2unix vim

RUN mkdir -p /conquest/data
RUN mkdir -p /conquest/dbase
RUN mkdir -p /conquest/config
RUN mkdir -p /conquest/logs

RUN wget http://ingenium.home.xs4all.nl/dicomserver/dicomserver1419d.zip
RUN mkdir /temp
RUN cd temp && unzip ../dicomserver1419d.zip
RUN rm dicomserver1419d.zip

RUN dos2unix /temp/maklinux
RUN chmod 777 /temp/maklinux
RUN cd /temp && printf "3\n" | ./maklinux

RUN cp /temp/dgate /conquest/.
#RUN cp /temp/dgate.dic /conquest/config/.
#RUN cp /temp/dicom.sql /conquest/config/.
#COPY acrnema.map /conquest/config/.
#COPY dicom.ini /conquest/config/.


#RUN touch /conquest/logs/serverstatus.log
#RUN touch /conquest/logs/PacsTrouble.log

COPY startConquest.sh /conquest/
RUN dos2unix /conquest/startConquest.sh
RUN chmod 777 /conquest/startConquest.sh

CMD ["/conquest/startConquest.sh"]
