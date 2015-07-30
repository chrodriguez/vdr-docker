# -----------------------------------------------------------------------------
# docker-vdr-headless
#
#
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------

FROM ubuntu:14.04
MAINTAINER chrodriguez <chrodriguez@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root
# Don't ask user options when installing
env   DEBIAN_FRONTEND noninteractive
RUN echo APT::Install-Recommends "0"; >> /etc/apt/apt.conf 
RUN echo APT::Install-Suggests "0"; >> /etc/apt/apt.conf 

# Update system
RUN apt-get -y update && apt-get -y dist-upgrade

# Install git
RUN apt-get -y install git

# Usefull tools
RUN apt-get -y install w-scan dvb-apps vim

# Add Dependencies for building
RUN apt-get -y install build-essential libjpeg-dev libncursesw5-dev libfreetype6-dev \
  libcap-dev libfontconfig-dev gettext python linux-libc-dev libfribidi-dev libncurses5-dev

RUN apt-get -y install libudev-dev curl libcurl4-nss-dev

# GET SOURCES
RUN git clone https://github.com/chrodriguez/vdr.git /tmp/vdr && \
    git clone https://github.com/FernetMenta/vdr-plugin-vnsiserver.git /tmp/vdr/PLUGINS/src/vnsiserver && \
    git clone git://projects.vdr-developer.org/vdr-plugin-pvrinput.git /tmp/vdr/PLUGINS/src/pvrinput

RUN curl -SL http://www.saunalahti.fi/~rahrenbe/vdr/iptv/files/vdr-iptv-2.2.1.tgz | tar -xzC /tmp/vdr/PLUGINS/src && \
    mv /tmp/vdr/PLUGINS/src/iptv-2.2.1 /tmp/vdr/PLUGINS/src/iptv
RUN cd /tmp/vdr && \
    VIDEODIR=/recordings make && \
    VIDEODIR=/recordings make install

# Needed for iptv
RUN apt-get -y install software-properties-common
RUN apt-add-repository ppa:mc3man/trusty-media && apt-get -y update
RUN apt-get -y install vlc mplayer ffmpeg

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Change iptv vlc2iptv channels directory
RUN sed -i.bak -r 's@^(CHANNEL_SETTINGS_DIR=)(.*)@\1/var/lib/vdr/plugins/iptv/channels@' /usr/local/share/vdr/plugins/iptv/vlc2iptv && \
    sed -i.bak -r "s/^vlc /SUDO_UID=`id -u nobody` vlc-wrapper /" /usr/local/share/vdr/plugins/iptv/vlc2iptv


COPY config /tmp/config
COPY docker-entrypoint.sh /entrypoint.sh

# Expose Ports
EXPOSE 6419
EXPOSE 34890

# Volumes
VOLUME /var/lib/vdr
VOLUME /recordings


ENTRYPOINT ["/entrypoint.sh"]
# Use baseimage-docker's init system
CMD ["-p", "6419", "-P", "vnsiserver", "-P", "iptv"]

