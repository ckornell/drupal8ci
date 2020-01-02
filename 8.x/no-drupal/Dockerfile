# https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/
# https://github.com/docker-library/drupal/blob/master/$DRUPAL_TAG/apache/Dockerfile
# https://gitlab.com/mog33/drupal8ci
FROM mogtofu33/drupal8ci:$DRUPAL_TAG-drupal

LABEL maintainer="dev-drupal.com"

WORKDIR /var/www

# Remove the Drupal project that comes with the parent image.
RUN rm -rf /var/www/html \
  && mkdir -p /var/www/html \
  && chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html
