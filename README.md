# Docker container for ADCH++ hub server

https://adchpp.sourceforge.io/index.html

ADCH++ is a hub software for the ADC network. It implements the ADC protocol. The core application is very simple, but extensible using plugins.

# How to run

## Configure

Copy and modify `adchpp.xml` from `sample` folder to `etc/config` and run:


## docker

Configure, then:

```
docker run -v $PWD/etc/config:/app/config -p 2780:2780 ivunchata/adchpp:3.0.0
```

The container uses `CMD` (instead of `ENTRYPOINT`) so that it can be explored and tinkered with.

## docker-compose

Configure, then:

```
docker-compose up -d
```

## Encryption
There are self-signed certs that are generated during container build.
To provide your own - place them in `etc/certs` and pass that folder to the container.
The server expects (by default) the certificates in `/app/certs`.

NOTE: Absolute paths to the certs must be provided in the server configuration (i.e. `adchpp.xml`)!

# How to build

Add the source of the desired version (e.g. 3.0.0) of ADCH++ to `src` and run:

```
docker build . --build-arg VERSION=3.0.0
```
