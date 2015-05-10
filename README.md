docker-vdr
==========

Basic headless VDR Server based on Docker

1. docker build --rm=true -t "chrodriguez/docker-vdr-headless" .

2. docker run -d --privileged --name="vdr" \
	-p 2200:22 \
	-p 34890:34890  \
	-p 37890:37890  \
	-v /etc/timezone:/etc/timezone:ro \
	-v /etc/localtime:/etc/localtime:ro \
	chrodriguez/docker-vdr-headless

3. sudo nsenter vdr


Any options for plugins can be passed by arguments in scripts/vdr/run
