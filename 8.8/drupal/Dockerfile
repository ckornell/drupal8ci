FROM mogtofu33/drupal8ci:8.7-drupal

LABEL maintainer="dev-drupal.com"

# Remove the vanilla Drupal project that comes with the parent image.
RUN rm -rf ..?* .[!.]* *

RUN set -eux; \
  curl -fSL "https://ftp.drupal.org/files/projects/drupal-8.8.0-rc1.tar.gz" -o drupal.tar.gz; \
  tar -xz --strip-components=1 -f drupal.tar.gz; \
  rm drupal.tar.gz; \
  chown -R www-data:www-data sites modules themes

# Composer install for dev
RUN mkdir -p /var/www/html/vendor \
  && chown -R www-data:www-data /var/www/html/vendor

USER www-data

WORKDIR /var/www/html

RUN composer install --no-suggest --prefer-dist --no-interaction --no-ansi \
  && composer clear-cache

USER root

RUN ln -sf /var/www/.composer/vendor/bin/* /var/www/html/vendor/bin/