# https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/
# https://github.com/docker-library/drupal/blob/master/8.8/apache/Dockerfile
# https://gitlab.com/mog33/drupal8ci
FROM mogtofu33/drupal8ci:8.8-no-drupal

LABEL maintainer="dev-drupal.com"

USER www-data

# Add Drupal project with dev.
RUN composer create-project drupal/recommended-project /var/www/html --no-interaction --no-ansi \
  && composer require drupal/core-dev:^8.8 --no-interaction --no-ansi --no-suggest \
  && composer clear-cache \
  && rm -rf /var/www/.composer/cache/*

USER root
