FROM php:7.2-cli

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install node
RUN apt-get update && apt-get install -y \
            gnupg2 \
      && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
      && apt-get install -y nodejs build-essential \
      && rm -rf /var/lib/apt/lists/*

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
      && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
      && apt-get update && apt-get install --no-install-recommends yarn

RUN apt-get update && apt-get install -y \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      libicu-dev \
      git \
      git-core \
      unzip \
      zlib1g-dev \
   && rm -rf /var/lib/apt/lists/* \
   && echo "date.timezone = America/Sao_Paulo" > /usr/local/etc/php/php.ini \
   && docker-php-ext-install -j$(nproc) iconv intl zip exif fileinfo mysqli pdo pdo_mysql pcntl\
   && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
   && docker-php-ext-install -j$(nproc) gd

RUN useradd -m -d /developer -s /bin/bash -c "Developer" -U composer

WORKDIR /developer
