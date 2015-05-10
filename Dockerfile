# -----------------------------------------------------------------------------
# docker-vdr-headless
#
#
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------

FROM phusion/baseimage:0.9.16
MAINTAINER chrodriguez <chrodriguez@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Don't ask user options when installing
env   DEBIAN_FRONTEND noninteractive
RUN echo APT::Install-Recommends "0"; >> /etc/apt/apt.conf 
RUN echo APT::Install-Suggests "0"; >> /etc/apt/apt.conf 

# Update the system
RUN ln -s -f /bin/true /usr/bin/chfn && \
    apt-get -y update && apt-get -y upgrade && dpkg-divert --local --rename --add /sbin/initctl && \
    ln -sf /bin/true /sbin/initctl

# Add yavdr packages
run   apt-add-repository -y ppa:yavdr/unstable-main
run   apt-add-repository -y ppa:yavdr/unstable-vdr

# Add mutiverse to sources.list 
RUN echo "deb http://security.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list

# Update the system
RUN apt-get -y update && apt-get -y dist-upgrade

# Install vdr with plugins for:
#   * vnsiserver: connect kodi clients
#   * pvrinput: we still use analog cards to view TV in argentina
#   * xineliboutput: needed for testing vdr is working. See:
#	- https://wiki.archlinux.org/index.php/VDR#Xineliboutput_-_Full-Featured_and_Budget_Cards
#   * wirbelscan: automatic scan for channels
# 
RUN apt-get -y install vdr vdr-plugin-vnsiserver vdr-plugin-pvrinput vdr-plugin-xineliboutput \
	xineliboutput-sxfe libxineliboutput-sxfe vdr-plugin-wirbelscan

# Install linux-firmware to access specific video drivers
RUN apt-get -y install linux-firmware

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose Ports
EXPOSE 22 
EXPOSE 6419 
EXPOSE 34890
EXPOSE 37890

# Add runscript for vdr
RUN mkdir /etc/service/vdr/
ADD ./scripts/vdr/run /etc/service/vdr/run
RUN chmod +x /etc/service/vdr/run

#########################################################################################
# User passwords cannot be changed with chpasswd because of pam implementation. 
# We need to recompile pam support and then change password so ssh can be done as root
#----------------------------------------------------------------------------------------
# Setup build environment for libpam
RUN apt-get update && apt-get -y build-dep pam
# Rebuild and istall libpam with --disable-audit option
RUN export CONFIGURE_OPTS=--disable-audit && cd /root && apt-get -b source pam && dpkg -i libpam-doc*.deb libpam-modules*.deb libpam-runtime*.deb libpam0g*.deb

# Change root password to vdr so we can access via ssh. Instead is better to use nsenter
RUN  echo "root:vdr"| chpasswd
#########################################################################################

# Enable ssh
RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]
