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

# Scanning Channels

Default configuration, will setup Argentina ISDB-T channels for La Plata's city
and a set of IPTV channels.
You can scan for your channels using w-scan running:

```
docker run --rm -it --entrypoint=w_scan chrodriguez/vdr \ 
  -a0 -I /usr/share/dvb/dvb-t/ar-Argentina -o 21
```
# IPTV channels

For argentina we use: http://radiosargentina.com.ar/
