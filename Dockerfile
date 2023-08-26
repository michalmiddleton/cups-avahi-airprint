FROM debian:12.1

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y cups \
	avahi-daemon \
	inotify-tools \
	rsync \
	python3 \
	python3-cups\
	libc6-i386

ADD pkg/* /root/
RUN mkdir -p /var/spool/lpd/mfc9970cdw
RUN dpkg -i --force-all  /root/mfc9970cdwcupswrapper-1.1.1-5.i386.deb /root/mfc9970cdwlpr-1.1.1-5.i386.deb

# This will use port 631
EXPOSE 631/tcp
EXPOSE 5353/udp

# We want a mount for these
VOLUME /config
VOLUME /services

# Add scripts
ADD root/ /root/
RUN chmod +x /root/*sh /root/*py

#Run Script
CMD ["/root/run_cups.sh"]

# Baked-in config file changes
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
	sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/.*enable\-dbus=.*/enable\-dbus\=no/' /etc/avahi/avahi-daemon.conf && \
	echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
	echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf
