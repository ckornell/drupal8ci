# https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/
# https://github.com/docker-library/drupal/blob/master/8.6/apache/Dockerfile
FROM drupal:8.6-apache

LABEL maintainer="dev-drupal.com"

# Install composer.
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install needed programs for next steps.
RUN apt-get update && apt-get install --no-install-recommends -y \
  apt-transport-https \
  gnupg2 \
  software-properties-common \
  sudo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Nodejs, Yarn, programs for next steps and php extensions.
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install --no-install-recommends -y \
  nodejs \
  yarn \
  imagemagick \
  libmagickwand-dev \
  libnss3-dev \
  libxslt-dev \
  mariadb-client \
  jq \
  shellcheck \
  git \
  unzip \
  # Install xsl, mysqli, xdebug, imagick.
  && docker-php-ext-install xsl mysqli \
  && pecl install imagick xdebug \
  && docker-php-ext-enable imagick xdebug \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root/

# Put a turbo on composer, install phpqa + tools + Robo + Coder.
# Install Drupal dev third party and upgrade Php-unit.
COPY composer.json /root/.composer/composer.json
RUN composer global install --no-ansi -n --profile --no-suggest \
  && ln -sf /root/.composer/vendor/bin/* /usr/local/bin \
  && composer clear-cache \
  && rm -rf /root/.composer/cache/*

# Add Drupal 8 Node tools / linters / Sass / Nightwatch.
ADD https://raw.githubusercontent.com/drupal/drupal/8.6.x/core/package.json /root/package.json
RUN npm -g config set user root \
  && npm -g config set unsafe-perm true \
  && npm install --no-audit \
  && npm install --no-audit git://github.com/sasstools/sass-lint.git#develop \
  && yarn install \
  && ln -s /root/node_modules/.bin/* /usr/local/bin \
  && ln -s /root/node_modules /var/www/html/core/node_modules \
  && npm cache clean --force \
  && rm -rf /tmp/*

COPY run-tests.sh /scripts/run-tests.sh
RUN chmod +x /scripts/run-tests.sh

# Remove Apache logs to stdout from the php image (used by Drupal inage).
RUN rm -f /var/log/apache2/access.log

#### Specific part for the included Drupal 8 code in this image.
COPY .env.nightwatch /var/www/html/core/.env

WORKDIR /var/www/html

# Install Drupal dev and PHP 7 update for PHPunit, see
# https://github.com/drupal/drupal/blob/8.6.x/composer.json#L56
RUN composer install --no-ansi -n --profile --no-suggest \
  && composer update phpunit/phpunit phpspec/prophecy symfony/yaml --with-dependencies --no-progress --no-ansi \
  && ln -sf /var/www/html/vendor/bin/phpunit /usr/local/bin/phpunit \
  # Patch for Nightwatch to install Drupal with a profile.
  # https://www.drupal.org/node/3017176
  && curl -fsSL https://www.drupal.org/files/issues/2019-02-05/3017176-7.patch -o 3017176-7.patch \
  && patch -p1 < 3017176-7.patch \
  && composer clear-cache \
  && rm -f 3017176-7.patch \
  && rm -rf /tmp/*
