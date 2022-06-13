# syntax = docker/dockerfile:labs
ARG ALPINE_VERSION="3.16.0"
FROM alpine:${ALPINE_VERSION}

ARG TIMEZONE

RUN apk update \
&& apk add --update --no-cache varnish uuidgen \
&& ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone \
&& uuidgen > /etc/varnish/secret

COPY default.vcl /etc/varnish/
COPY entrypoint /usr/local/bin/docker-entrypoint

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
