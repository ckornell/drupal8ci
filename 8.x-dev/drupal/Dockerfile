FROM mogtofu33/drupal8ci:$DRUPAL_TAG-drupal

LABEL maintainer="dev-drupal.com"

WORKDIR /var/www

# Remove the Drupal project that comes with the parent image.
RUN rm -rf /var/www/html \
  && mkdir -p /var/www/html

WORKDIR /var/www/html

RUN set -eux; \
  curl -fSL "https://ftp.drupal.org/files/projects/drupal-8.9.x-dev.tar.gz" -o drupal.tar.gz; \
  tar -xz --strip-components=1 -f drupal.tar.gz; \
  rm drupal.tar.gz; \
  chown -R www-data:www-data /var/www/html

RUN mkdir -p /var/www/html/vendor \
  && chown -R www-data:www-data /var/www/html/vendor

USER root

RUN ln -sf /var/www/.composer/vendor/bin/* /var/www/html/vendor/bin/