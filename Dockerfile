# All credit goes to Jason Wilder and all the contributors of his original Github repository
# Credit goes to Alexander Krause <akr@informatik.uni-kiel.de> for making it work on armhf.

# This is a general fix for me that made it work on (I think?) RPI1 or arm32v6, no guarantees.
FROM arm32v6/nginx:alpine
LABEL maintainer="Henrik Johansson"

# Install wget and install/updates certificates
RUN apk update \
  && apk add wget \
  && apk add tar \
  && apk add bash \
  && rm -rf /var/cache/apk/*


# Configure Nginx and apply fix for very long server names
RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
 && sed -i 's/worker_processes  1/worker_processes  auto/' /etc/nginx/nginx.conf

# Install Forego
ADD https://github.com/djmaze/armhf-forego/releases/download/v0.16.1/forego /usr/local/bin/forego
RUN chmod u+x /usr/local/bin/forego

ENV DOCKER_GEN_VERSION 0.7.4

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz

COPY network_internal.conf /etc/nginx/

COPY . /app/
WORKDIR /app/

ENV DOCKER_HOST unix:///tmp/docker.sock

VOLUME ["/etc/nginx/certs", "/etc/nginx/dhparam"]

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]

