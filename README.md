[![](https://img.shields.io/docker/pulls/alexanderkrause/rpi-nginx-proxy.svg)](https://hub.docker.com/r/alexanderkrause/rpi-nginx-proxy "Click to view the image on Docker Hub")

This is a [**fork**](https://github.com/Kahevajo/rpi-docker-nginx-proxy) of a [**fork**](https://github.com/Alexander-Krause/rpi-docker-nginx-proxy), that enables usage on a arm32v6 architecture RPI 1 (I think?). Have a look at Jason Wilder's [original](https://github.com/jwilder/nginx-proxy) repository and README. The following part does not include all available options of the original project.

The original fork did not work for my raspberry pi 1 with arm32v6 so I modified it a bit, changing to alpine as a base as the arm32v6 only releases on alpine.

It worked for me so I thought I share it if it is useful for some of you.

All credit goes to Jason Wilder for the original and Alexander Krause for making it work on armhf.

### Why do you want to use this?
Reasons and examples for using a reverse proxy are discussed [by Jason Wilder](https://stackoverflow.com/a/366212/3250397) or [here](https://stackoverflow.com/a/366212/3250397).
With a [companion container](https://github.com/Alexander-Krause/rpi-docker-letsencrypt-nginx-proxy-companion) for creating/renewing *Let's Encrypt certificates* automatically you can use it with a Raspberry Pi and DynDNS Provider to host and expose your dockerized (and now TLS-secured) applications. Examples:

* [Nextcloud](https://github.com/nextcloud/docker) with [Passman](https://github.com/nextcloud/passman) extension and [MySQL](https://github.com/hypriot/rpi-mysql) (*tested*)
* [Nginx](https://github.com/armhf-docker-library/nginx) hosting your web sites (*tested*)
* Own Mailserver, e.g. [tomav/docker-mailserver](https://github.com/tomav/docker-mailserver), [hardware/mailserver](https://github.com/hardware/mailserver) or [Poste.io](https://poste.io/) (*not tested*)

### Usage

1. Clone this repository `$ git https://github.com/Kahevajo/rpi-docker-nginx-proxy.git`
2. `$ cd rpi-docker-nginx-proxy`
3. `$ docker build -t kahevajo/rpi1-nginx-proxy:latest .`
4. `$ docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro kahevajo/rpi1-nginx-proxy:latest`

Then start any containers you want proxied with an env var `VIRTUAL_HOST=subdomain.youdomain.com`

    $ docker run -e VIRTUAL_HOST=foo.bar.com  ...



### Below things have not been tested on a RPI1 but supposedly works on RPI3


### SSL Support using letsencrypt (recommend)

[rpi-docker-letsencrypt-nginx-proxy-companion](https://github.com/Alexander-Krause/rpi-docker-letsencrypt-nginx-proxy-companion) is a lightweight companion container for the nginx-proxy. It allow the creation/renewal of Let's Encrypt certificates automatically. 

### SSL Support

SSL is supported using single host, wildcard and SNI certificates using naming conventions for
certificates or optionally specifying a cert name (for SNI) as an environment variable.

To enable SSL:

    $ docker run -d -p 80:80 -p 443:443 -v /path/to/certs:/etc/nginx/certs -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy

The contents of `/path/to/certs` should contain the certificates and private keys for any virtual
hosts in use.  The certificate and keys should be named after the virtual host with a `.crt` and
`.key` extension.  For example, a container with `VIRTUAL_HOST=foo.bar.com` should have a
`foo.bar.com.crt` and `foo.bar.com.key` file in the certs directory.

### DynDNS

You can use for example https://www.duckdns.org to expose your Nextcloud container or something else. See [here](https://github.com/Alexander-Krause/rpi-docker-letsencrypt-nginx-proxy-companion/blob/master/README.md#dyndns) for more details.


