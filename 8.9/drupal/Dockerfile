# https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/
# https://github.com/docker-library/drupal/blob/master/8.8/apache/Dockerfile
# https://gitlab.com/mog33/drupal8ci
FROM mogtofu33/drupal8ci:2.x-dev-base

LABEL maintainer="dev-drupal.com"

USER www-data

# Add Drupal project with dev and Drush.
RUN composer create-project drupal/recommended-project:~8.9 /var/www/html --no-interaction --no-ansi \
  && composer require drupal/core-dev:~8.9 drush/drush:^10 --working-dir=/var/www/html --no-interaction --no-ansi --no-suggest \
  && composer update phpunit/phpunit phpspec/prophecy symfony/yaml --working-dir=/var/www/html --with-dependencies --no-progress \
  && composer clear-cache \
  && rm -rf /var/www/.composer/cache/*

USER root

VOLUME /var/www/html
