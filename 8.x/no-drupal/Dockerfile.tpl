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

# Change docroot since we use Composer Drupal project.
RUN sed -ri -e 's!DocumentRoot /var/www/html!DocumentRoot /var/www/html/web!g' /etc/apache2/sites-available/*.conf \
  && sed -ri -e 's!DocumentRoot /var/www!DocumentRoot /var/www/html/web!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
