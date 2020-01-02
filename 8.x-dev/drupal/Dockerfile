FROM mogtofu33/drupal8ci:$DRUPAL_TAG-drupal

LABEL maintainer="dev-drupal.com"

WORKDIR /var/www

# Remove the Drupal project that comes with the parent image.
RUN rm -rf /var/www/html

USER www-data

# Upgrade Drupal version to last dev.
RUN composer create-project drupal/recommended-project:$DRUPAL_DOWNLOAD_TAG html --no-interaction --no-ansi \
  && composer clear-cache

WORKDIR /var/www/html

RUN composer update phpunit/phpunit phpspec/prophecy symfony/yaml --with-dependencies --no-progress \
  && composer clear-cache \
  && rm -rf /var/www/.composer/cache/* \
  # Add ww-data to sudoers to be able to use sudo -u www-data
  && sudo usermod -aG sudo,adm www-data
