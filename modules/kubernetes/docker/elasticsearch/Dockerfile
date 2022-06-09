# syntax = docker/dockerfile:labs
ARG ELASTICSEARCH_VERSION="7.17.4"
FROM elasticsearch:${ELASTICSEARCH_VERSION}

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu \
&& /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-phonetic
