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

# Put a turbo on composer, install phpqa + tools + Robo + Coder.
# Install Drupal dev third party and upgrade Php-unit.
COPY composer.json /root/.composer/composer.json
RUN composer global install --no-ansi -n --profile \
  && ln -s /root/.composer/vendor/bin/* /usr/local/bin \
  && composer --working-dir="/var/www/html" install \
  && composer --working-dir="/var/www/html" run-script drupal-phpunit-upgrade \
  && ln -s /var/www/html/vendor/bin/phpunit /usr/local/bin/phpunit \
  && rm -rf ~/.composer/cache/*

# Patch for Nightwatch to install Drupal with a profile.
# https://www.drupal.org/node/3017176
RUN curl -fsSL https://www.drupal.org/files/issues/2019-02-05/3017176-7.patch -o 3017176-7.patch \
  && git apply -v 3017176-7.patch \
  && rm -f 3017176-7.patch

# Add Drupal 8 Node tools / linters / Sass / Nightwatch.
WORKDIR /var/www/html/core
COPY .env.nightwatch /var/www/html/core/.env
RUN npm install --no-audit \
  && npm install --no-audit git://github.com/sasstools/sass-lint.git#1.13.0 \
  && yarn install \
  && ln -s /var/www/html/core/node_modules/.bin/* /usr/local/bin

# Remove the memory limit for the CLI only.
RUN echo 'memory_limit = -1' > /usr/local/etc/php/php-cli.ini

COPY run-tests.sh /scripts/run-tests.sh
RUN chmod +x /scripts/run-tests.sh

WORKDIR /var/www/html
