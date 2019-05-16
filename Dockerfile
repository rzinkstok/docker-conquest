FROM ubuntu:18.04

# Install packages
RUN apt-get update
RUN apt-get install -y build-essential g++ libpq-dev wget zip unzip sudo dos2unix vim

# Create folders
RUN mkdir -p /conquest/mount
RUN mkdir -p /conquest/dbdata

# Download Conquest
RUN wget http://ingenium.home.xs4all.nl/dicomserver/dicomserver1419d.zip
RUN mkdir /temp
RUN cd temp && unzip ../dicomserver1419d.zip
RUN rm dicomserver1419d.zip

# Build dgate
RUN dos2unix /temp/maklinux
RUN chmod 777 /temp/maklinux
RUN sed -i '/www/d' /temp/maklinux
RUN sed -i '/cgi-bin/d' /temp/maklinux
RUN cd /temp && printf "2\n" | ./maklinux

# Clean up
RUN cp /temp/dgate /conquest/.
RUN rm -r /temp

# Create startup script
COPY startConquest.sh /conquest/
RUN dos2unix /conquest/startConquest.sh
RUN chmod 777 /conquest/startConquest.sh

CMD ["/conquest/startConquest.sh"]
