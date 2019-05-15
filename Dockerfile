FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y build-essential g++ libpq-dev wget zip unzip sudo dos2unix vim

RUN mkdir -p /conquest/mount
RUN mkdir -p /conquest/dbdata

RUN wget http://ingenium.home.xs4all.nl/dicomserver/dicomserver1419d.zip
RUN mkdir /temp
RUN cd temp && unzip ../dicomserver1419d.zip
RUN rm dicomserver1419d.zip

RUN dos2unix /temp/maklinux
RUN chmod 777 /temp/maklinux
RUN sed -i '/www/d' /temp/maklinux
RUN sed -i '/cgi-bin/d' /temp/maklinux

RUN cd /temp && printf "2\n" | ./maklinux

RUN cp /temp/dgate /conquest/.
#RUN cp /temp/dgate.dic /conquest/config/.
#RUN cp /temp/dicom.sql /conquest/config/.
#COPY acrnema.map /conquest/config/.
#COPY dicom.ini /conquest/config/.
RUN rm -r /temp

#RUN touch /conquest/logs/serverstatus.log
#RUN touch /conquest/logs/PacsTrouble.log

COPY startConquest.sh /conquest/
RUN dos2unix /conquest/startConquest.sh
RUN chmod 777 /conquest/startConquest.sh

CMD ["/conquest/startConquest.sh"]
