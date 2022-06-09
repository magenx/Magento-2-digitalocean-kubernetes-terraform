# syntax = docker/dockerfile:labs
ARG VARNISH_VERSION="7.0.2"
FROM varnish:${VARNISH_VERSION}

ARG TIMEZONE

RUN apk update \
&& apk add --update --no-cache uuidgen \
&& ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone \
&& uuidgen > /etc/varnish/secret

COPY default.vcl /etc/varnish/
COPY entrypoint /usr/local/bin/docker-varnish-entrypoint
