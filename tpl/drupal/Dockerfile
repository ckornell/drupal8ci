# https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/
# https://github.com/docker-library/drupal/blob/master/$IMAGE_TAG/apache/Dockerfile
# https://gitlab.com/mog33/drupal8ci
FROM mogtofu33/drupal8ci:${RELEASE}-base

LABEL maintainer="dev-drupal.com"

USER www-data

# Add Drupal project with dev and Drush.
RUN composer create-project drupal/recommended-project:~${RELEASE_TAG} /var/www/html --no-interaction --no-ansi \
  && composer require drupal/core-dev:~${DEV_TAG} drush/drush:^10 --working-dir=/var/www/html --no-interaction --no-ansi --no-suggest \
  && composer update phpunit/phpunit phpspec/prophecy symfony/yaml --working-dir=/var/www/html --with-dependencies --no-progress \
  && composer clear-cache \
  && rm -rf /var/www/.composer/cache/*

USER root

VOLUME /var/www/html
