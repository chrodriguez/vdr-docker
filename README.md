# Docker VDR tunned for my country: Argentina

Basic headless VDR Server based on Docker


## Building image

Simply run: 
```
docker build --rm=true -t "chrodriguez/vdr" .
```

# Runing vdr

The first time you run this image you can use:

```
docker run -d --privileged --name="vdr" \
	-p 2200:22 \
	-p 34890:34890  \
	-p 37890:37890  \
	-v /etc/timezone:/etc/timezone:ro \
	-v /etc/localtime:/etc/localtime:ro \
	-v `pwd`/config/channels.conf:/var/lib/vdr/channels.conf \
	-v `pwd`/config/setup.conf:/var/lib/vdr/setup.conf \
	-v `pwd`/config/svdrphosts.conf:/var/lib/vdr/svdrphosts.conf \
	-v `pwd`/config/plugins/vnsiserver/allowed_hosts.conf:/var/lib/vdr/plugins/vnsiserver/allowed_hosts.conf \
	-v `pwd`/config/plugins/xineliboutput/allowed_hosts.conf:/var/lib/vdr/plugins/xineliboutput/allowed_hosts.conf \
	chrodriguez/vdr
```

It's important to edit custom configuration as it's passed as container volumes.

## If you need to enter container:

* You can use nsenter
* SSH is enabled on port 2200 as root: password vdr
* To analyze logs: `docker logs -f vdr`

## Custom VDR plugin options

Any options for plugins can be passed by arguments in scripts/vdr/run

# See also

Configuration used by me can be downloaded from: https://github.com/chrodriguez/vdr-my-configuration
