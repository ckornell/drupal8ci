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
  software-properties-common

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
  && docker-php-ext-enable imagick xdebug\
  && rm -rf /var/lib/apt/lists/*

# Put a turbo on composer, install phpqa + tools + Robo.
RUN composer global require hirak/prestissimo \
  && composer global require edgedesign/phpqa --update-no-dev \
  && composer global require jakub-onderka/php-parallel-lint jakub-onderka/php-console-highlighter \
      vimeo/psalm sensiolabs/security-checker \
  && rm -rf ~/.composer/cache/* \
  && curl -fsSL https://robo.li/robo.phar -o robo.phar \
  && chmod +x robo.phar \
  && mv robo.phar /usr/local/bin/robo

CMD export PATH=$PATH:~/.composer/vendor/bin;

# Remove the memory limit for the CLI only.
RUN echo 'memory_limit = -1' > /usr/local/etc/php/php-cli.ini

# Remove the vanilla Drupal project that comes with this image.
RUN rm -rf ..?* .[!.]* *

# Change docroot since we use Composer Drupal project.
RUN sed -ri -e 's!/var/www/html!/var/www/html/web!g' /etc/apache2/sites-available/*.conf \
  && sed -ri -e 's!/var/www!/var/www/html/web!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY run-tests.sh /scripts/run-tests.sh
RUN chmod +x /scripts/run-tests.sh
