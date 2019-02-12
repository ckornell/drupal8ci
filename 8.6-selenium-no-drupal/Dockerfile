# https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/
# https://github.com/docker-library/drupal/blob/master/8.6/apache/Dockerfile
FROM mogtofu33/drupal8ci:8.6-selenium

LABEL maintainer="dev-drupal.com"

# Remove the vanilla Drupal project that comes with this image.
RUN rm -rf ..?* .[!.]* *

# Clean phpunit in the image.
RUN rm -f /usr/local/bin/phpunit

COPY run-tests.sh /scripts/run-tests.sh
RUN chmod +x /scripts/*.sh
