# https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/
# https://github.com/docker-library/drupal/blob/master/8.6/apache/Dockerfile
FROM mogtofu33/drupal8ci:8.6-with-drupal

LABEL maintainer="dev-drupal.com"

ENV JAVA_OPTS="-Xmx512m"
ENV SE_OPTS="-debug"

ADD http://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar selenium-server-standalone.jar
ADD https://raw.githubusercontent.com/SeleniumHQ/docker-selenium/master/Standalone/start-selenium-standalone.sh /scripts/start-selenium-standalone.sh

RUN mkdir -p /usr/share/man/man1 \
  && apt-get update && apt-get install --no-install-recommends -y \
  chromium \
  libnss3-dev \
  openjdk-8-jdk \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY run-tests.sh /scripts/run-tests.sh
RUN chmod +x /scripts/*.sh
