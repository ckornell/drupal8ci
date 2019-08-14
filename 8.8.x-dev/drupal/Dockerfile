FROM mogtofu33/drupal8ci:8.7

LABEL maintainer="dev-drupal.com"

# Remove the vanilla Drupal project that comes with the parent image.
RUN rm -rf ..?* .[!.]* *
ENV DRUPAL_VERSION 8.8.x-dev

RUN set -eux; \
  curl -fSL "https://ftp.drupal.org/files/projects/drupal-.tar.gz" -o drupal.tar.gz; \
  tar -xz --strip-components=1 -f drupal.tar.gz; \
  rm drupal.tar.gz; \
  chown -R www-data:www-data sites modules themes
