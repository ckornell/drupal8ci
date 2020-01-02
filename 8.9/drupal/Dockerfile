FROM mogtofu33/drupal8ci:8.8-drupal

LABEL maintainer="dev-drupal.com"

WORKDIR /var/www

# Remove the Drupal project that comes with the parent image.
RUN rm -rf /var/www/html

USER www-data

# Upgrade Drupal version to last dev.
RUN composer create-project drupal/recommended-project:8.9.x-dev html --no-interaction --no-ansi \
  && composer update phpunit/phpunit phpspec/prophecy symfony/yaml --with-dependencies --no-progress \
  && composer clear-cache \
  && rm -rf /var/www/.composer/cache/*

WORKDIR /var/www/html
