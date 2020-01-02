# https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/
# https://github.com/docker-library/drupal/blob/master/$DRUPAL_TAG/apache/Dockerfile
FROM drupal:$DRUPAL_TAG-apache

LABEL maintainer="dev-drupal.com"

ENV DBUS_SESSION_BUS_ADDRESS="/dev/null"

# Install needed programs for next steps.
RUN apt-get update && apt-get install --no-install-recommends -y \
  apt-transport-https \
  ca-certificates \
  gnupg2 \
  software-properties-common \
  sudo \
  curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#==================
# Install Nodejs, Yarn, Chrome, php extensions, needed programs.
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  # Google Chrome latest stable release.
  && curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update && apt-get install --no-install-recommends -y \
  nodejs \
  yarn \
  google-chrome-stable \
  imagemagick \
  libmagickwand-dev \
  libnss3-dev \
  libxslt-dev \
  mariadb-client \
  jq \
  git \
  unzip \
  vim \
  # Install xsl, mysqli, xdebug, imagick.
  && docker-php-ext-install xsl mysqli \
  && pecl install imagick xdebug \
  && docker-php-ext-enable imagick xdebug \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#==================
# Chromedriver latest stable release.
# http://chromedriver.chromium.org/downloads/version-selection
RUN curl -fsSL https://chromedriver.storage.googleapis.com/$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip \
    -o /tmp/chromedriver_linux64.zip \
  && unzip /tmp/chromedriver_linux64.zip -d /opt \
  && rm -f /tmp/chromedriver_linux64.zip \
  && ln -fs /opt/chromedriver /usr/local/bin/chromedriver \
  # Add Chrome as a user
  && groupadd -r chromeuser && useradd -r -g chromeuser -G audio,video chromeuser \
  && mkdir -p /home/chromeuser && chown -R chromeuser:chromeuser /home/chromeuser

#==================
# Composer.
COPY --chown=www-data:www-data --from=composer:latest /usr/bin/composer /usr/local/bin/composer
COPY --chown=www-data:www-data composer.json /var/www/.composer/composer.json

WORKDIR /var/www

# Remove the Drupal project that comes with the parent image.
RUN rm -rf /var/www/html

RUN mkdir -p /var/www/.composer \
  && chmod 777 /var/www \
  && chown -R www-data:www-data /var/www

USER www-data

RUN composer create-project drupal/recommended-project html --no-interaction --no-ansi \
  && composer clear-cache \
  && rm -rf /var/www/.composer/cache/*

# Manage Composer.
WORKDIR /var/www/.composer

# Put a turbo on composer, install phpqa + tools + Robo + Coder.
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-ansi -n --profile --no-suggest \
  && composer clear-cache \
  && rm -rf /var/www/.composer/cache/*

WORKDIR /var/www/html

# Manage final tasks.
USER root

COPY --chown=www-data:www-data run-tests.sh /scripts/run-tests.sh
COPY --chown=chromeuser:chromeuser start-chromedriver.sh /scripts/start-chromedriver.sh
COPY --chown=chromeuser:chromeuser start-chrome.sh /scripts/start-chrome.sh

RUN chmod +x /scripts/*.sh \
  # Symlink binaries.
  # && ln -sf /var/www/html/vendor/bin/* /usr/local/bin \
  && ln -sf /var/www/.composer/vendor/bin/* /usr/local/bin \
  # && ln -sf /var/www/.composer/vendor/bin/* /var/www/html/vendor/bin/ \
  # Remove Apache logs to stdout from the php image (used by Drupal image).
  && rm -f /var/log/apache2/access.log \
  # Fix Php performances.
  && mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
  && sed -i "s#memory_limit = 128M#memory_limit = 2048M#g" /usr/local/etc/php/php.ini \
  && sed -i "s#max_execution_time = 30#max_execution_time = 90#g" /usr/local/etc/php/php.ini \
  && sed -i "s#;max_input_nesting_level = 64#max_input_nesting_level = 512#g" /usr/local/etc/php/php.ini \
  # Fix Apache DocumentRoot.
  && sed -ri -e 's!DocumentRoot /var/www/html!DocumentRoot /var/www/html/web!g' /etc/apache2/sites-available/*.conf \
  && sed -ri -e 's!DocumentRoot /var/www!DocumentRoot /var/www/html/web!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf \
  # Convenient alias.
  && echo "alias ls='ls --color=auto -lAh'" >> /root/.bashrc \
  && echo "alias l='ls --color=auto -lAh'" >> /root/.bashrc \
  && cp /root/.bashrc /var/www/.bashrc \
  && chown www-data:www-data /var/www/.bashrc

EXPOSE 80 4444 9515 9222