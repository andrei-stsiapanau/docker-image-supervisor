FROM ubuntu:22.04

ARG DEBIAN_FRONTEND="noninteractive"
ARG TZ="UTC"

ADD https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key /tmp/nodesource-repo.gpg.key

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
    && apt-get update \
    && apt-get install --yes \
        curl \
        gpg \
        software-properties-common \
    && cat /tmp/nodesource-repo.gpg.key | gpg --dearmor --output /usr/share/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install --yes \
        nodejs \
        php8.3-bcmath \
        php8.3-cli \
        php8.3-curl \
        php8.3-gd \
        php8.3-imap \
        php8.3-igbinary \
        php8.3-imagick \
        php8.3-intl \
        php8.3-ldap \
        php8.3-mbstring \
        php8.3-memcached \
        php8.3-msgpack \
        php8.3-mysql \
        php8.3-readline \
        php8.3-redis \
        php8.3-soap \
        php8.3-swoole \
        php8.3-xml \
        php8.3-zip \
        supervisor \
    && apt-get remove --yes \
        curl \
        gpg \
        software-properties-common \
    && apt-get autoremove --yes \
    && apt-get clean --yes

ADD supervisord.conf /etc/supervisor/supervisord.conf

WORKDIR /srv/www

CMD [ "/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisor/supervisord.conf" ]
