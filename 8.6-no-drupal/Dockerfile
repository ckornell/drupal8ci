# https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/
# https://github.com/docker-library/drupal/blob/master/8.6/apache/Dockerfile
FROM mogtofu33/drupal8ci:8.6

LABEL maintainer="dev-drupal.com"

# Add some npm tools for Drupal 8.6+ with extra sass-lint.
ADD https://cgit.drupalcode.org/drupal/plain/core/package.json /root/package.json
RUN npm -g config set user root \
  && npm -g config set unsafe-perm true \
  && cd /root \
  && npm install --no-audit \
  && npm install --no-audit git://github.com/sasstools/sass-lint.git#1.13.0 \
  && ln -sf /root/node_modules/.bin/* /usr/local/bin

# Remove the vanilla Drupal project that comes with this image.
RUN rm -rf ..?* .[!.]* *

# Clean phpunit in the image.
RUN rm -f /usr/local/bin/phpunit

# Change docroot since we use Composer Drupal project.
RUN sed -ri -e 's!/var/www/html!/var/www/html/web!g' /etc/apache2/sites-available/*.conf \
  && sed -ri -e 's!/var/www!/var/www/html/web!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY run-tests.sh /scripts/run-tests.sh
RUN chmod +x /scripts/run-tests.sh