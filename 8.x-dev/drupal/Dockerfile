FROM mogtofu33/drupal8ci:${DRUPAL_TAG}-no-drupal

LABEL maintainer="dev-drupal.com"

USER www-data

# Upgrade Drupal version to last dev.
RUN composer create-project drupal/recommended-project:${DRUPAL_DOWNLOAD_TAG} /var/www/html --no-interaction --no-ansi \
  && composer require drupal/core-dev:^${DRUPAL_CURRENT_DEV} --working-dir=/var/www/html --no-interaction --no-ansi --no-suggest \
  && composer update phpunit/phpunit phpspec/prophecy symfony/yaml --with-dependencies --no-progress \
  && composer clear-cache \
  && rm -rf /var/www/.composer/cache/* \
  && ls -lAh /var/www/html

USER root
