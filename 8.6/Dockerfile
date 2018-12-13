# https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/
# https://github.com/docker-library/drupal/blob/master/$VER/apache/Dockerfile
FROM drupal:8.6-apache

# Install composer.
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install needed programs for next steps.
RUN apt-get update && apt-get install --no-install-recommends -y \
  sudo \
  apt-transport-https \
  gnupg2 \
  software-properties-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Docker, Nodejs, Yarn programs for next steps and php extensions.
RUN curl -sL https://download.docker.com/linux/debian/gpg | sudo apt-key add - \
  && echo "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" | sudo tee /etc/apt/sources.list.d/docker.list \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install --no-install-recommends -y \
  docker-ce \
  nodejs \
  yarn \
  imagemagick \
  libmagickwand-dev \
  libxslt-dev \
  mariadb-client \
  git \
  unzip \
  # Install xsl, mysqli, xdebug, imagick.
  && docker-php-ext-install xsl mysqli \
  && pecl install imagick xdebug \
  && docker-php-ext-enable imagick xdebug \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Put a turbo on composer, install phpqa + tools + Robo + Coder.
COPY composer.json /root/composer.json
RUN composer global install --no-ansi -n --profile /root/composer.json \
  && rm -rf ~/.composer/cache/* \
  && ln -s /root/.composer/vendor/bin/* /usr/local/bin \
  && ls -lA /usr/local/bin

# Add some npm tools for Drupal 8.6+ with extra sass-lint.
COPY https://cgit.drupalcode.org/drupal/plain/core/package.json /root/package.json
RUN npm -g config set user root \
  && npm -g config set unsafe-perm true \
  && npm -g install --no-audit /root/package.json \
  && npm -g install --no-audit git://github.com/sasstools/sass-lint.git#1.13.0

# Remove the memory limit for the CLI only.
RUN echo 'memory_limit = -1' > /usr/local/etc/php/php-cli.ini

# Remove the vanilla Drupal project that comes with this image.
RUN rm -rf ..?* .[!.]* *

# Change docroot since we use Composer Drupal project.
RUN sed -ri -e 's!/var/www/html!/var/www/html/web!g' /etc/apache2/sites-available/*.conf \
  && sed -ri -e 's!/var/www!/var/www/html/web!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

ENV PATH="~/.composer/vendor/bin:${PATH}"
ENV NPM_CONFIG_UNSAFE_PERM true

COPY run-tests.sh /scripts/run-tests.sh
RUN chmod +x /scripts/run-tests.sh
