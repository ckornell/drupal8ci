# https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/
# https://github.com/docker-library/drupal/blob/master/$DRUPAL_TAG/apache/Dockerfile
# https://gitlab.com/mog33/drupal8ci
FROM mogtofu33/drupal8ci:${DRUPAL_TAG}-no-drupal

LABEL maintainer="dev-drupal.com"

USER www-data

# Add Drupal project with dev.
RUN composer create-project drupal/recommended-project /var/www/html --no-interaction --no-ansi \
  && composer require drupal/core-dev:^${DRUPAL_TAG} --working-dir=/var/www/html --no-interaction --no-ansi --no-suggest \
  && composer clear-cache \
  && rm -rf /var/www/.composer/cache/* \
  && ls -lAh /var/www/html

USER root
