# syntax = docker/dockerfile:labs
ARG BRAND
FROM ${BRAND}_php

ARG BRAND

ARG PHP_USER="php-${BRAND}"
ARG ROOT_PATH="/home/${BRAND}"
ARG APP_ROOT_PATH="/home/${BRAND}/public_html"
ARG WEB_ROOT_PATH="/home/${BRAND}/public_html/pub"

RUN <<EOF
    apk update
    apk add --update --no-cache git
EOF

RUN <<EOF
    curl -o /usr/local/bin/n98-magerun2 https://files.magerun.net/n98-magerun2.phar
    chmod +x /usr/local/bin/n98-magerun2
EOF

RUN <<EOF
    mkdir -p ${APP_ROOT_PATH}
    chown -R ${BRAND}.${PHP_USER} ${APP_ROOT_PATH}
    mkdir -p ${ROOT_PATH}/.config && chown -R ${BRAND} ${ROOT_PATH}/.config
    mkdir -p ${ROOT_PATH}/.cache && chown -R ${BRAND} ${ROOT_PATH}/.cache
    mkdir -p ${ROOT_PATH}/.local && chown -R ${BRAND} ${ROOT_PATH}/.local
    mkdir -p ${ROOT_PATH}/.composer && chown -R ${BRAND} ${ROOT_PATH}/.composer
    mkdir -p ${ROOT_PATH}/.npm && chown -R ${BRAND} ${ROOT_PATH}/.npm
    chmod -R 2750 ${APP_ROOT_PATH}
EOF

USER ${BRAND}:${PHP_USER}

RUN <<EOF
    cd ${APP_ROOT_PATH}
    echo 007 > magento_umask
    find . -type d -exec chmod 2750 {} \;
    find . -type f -exec chmod 640 {} \;
    chmod +x bin/magento
EOF

ENTRYPOINT ["n98-magerun2", "-vv"]

USER ${BRAND}
