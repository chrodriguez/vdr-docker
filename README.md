# Docker VDR patched for Argentina ISDB-T

Basic headless VDR Server based on Docker


## Building image

Simply run: 
```
docker build --rm=true -t "chrodriguez/vdr" .
```

# Runing vdr

Run this image as:

```
docker run --privileged -p 6419:6419 -p 34890:34890 \
  -v $HOME/vdr-config:/var/lib/vdr \
  -it \
  --name=vdr \
  chrodriguez/vdr
```

In this case, configuration will be saved on local filesystem `$HOME/vdr-config`

## Change default arguments
When run without arguments, it will run vdr with the following arguments:

```
vdr -p 6419 -P vnsiserver -P iptv
```

If this arguments are not ok with your needs, you can run the image with custom
arguments:

```
docker run chrodriguez/vdr -V
```

Will show vdr and compiled plugins versions

```
docker run -e TZ=America/Argentina/Buenos_Aires -e LANG=en_US.UTF-8 \
  -v /home/car/vdr/config:/var/lib/vdr -v /home/car/vdr/recordings:/recordings \
  -it --privileged --name=vdr \
  -p 6419:6419 -p 34890:34890 \
  chrodriguez/vdr -p 6419 -P vnsiserver -P pvrinput -P iptv
```

Will start vdr setting TZ to my country and default codeset to UTF8. Then I
mount local filesystem volumes and nam docker container as vdr. This command
will start vdr with plugins: vnsiserver pvrinput and iptv

# Scanning Channels

Default configuration, will setup Argentina ISDB-T channels for La Plata's city
and a set of IPTV channels.
You can scan for your channels using w-scan running:

```
docker run --rm --privileged -it chrodriguez/vdr w_scan \
  -a0 -I /usr/share/dvb/dvb-t/ar-Argentina -o 21
```
# IPTV channels

IPTV channels are added as specified by [vdr iptv
plugin](http://www.saunalahti.fi/~rahrenbe/vdr/iptv/). 

Some IPTV channels are provided in [channels.conf](config/channels.conf). They
use `vlc2iptv` script that will look for a file named as channel (be carefull
with channels names because they can break this integration if using space or -)
This files need to be inside config dir under
[plugins/iptv/channels](config/plugins/iptv/channels)

Each channel file can set *VIDEO_BITRATE* and *AUDIO_BITRATE* variables in
addition to *URL* to change default VIDRO_BITATE and AUDIO_BITRARE

Source IPTV channels for argentina can be downloaded from http://radiosargentina.com.ar/

# Bugs

It seems to be problems with kernel 3.16. Try using 3.13 if w_scan 
complains with:

```
tune to: QAM_AUTO f = 527142 kHz I999B6C999D999T999G999Y0  (no signal)
(time: 06:37) Info: no data from PMT
Info: no data from SDT(actual)
Info: no data from NIT(actual)
```
