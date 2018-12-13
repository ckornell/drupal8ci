# Drupal 8 CI Docker image for Gitlab CI

[![Image size](https://images.microbadger.com/badges/image/mogtofu33/drupal8ci.svg)](https://microbadger.com/images/mogtofu33/drupal8ci)
[![Docker Build Status](https://img.shields.io/docker/build/mogtofu33/drupal8ci.svg)](https://hub.docker.com/r/mogtofu33/drupal8ci/)
[![pipeline status](https://gitlab.com/mog33/drupal8ci/badges/master/pipeline.svg)](https://gitlab.com/mog33/drupal8ci/commits/master)

![](https://img.shields.io/github/license/Mogtofu33/drupal8ci.svg)

Drupal 8 CI image for [Gitlab CI Drupal](https://gitlab.com/mog33/gitlab-ci-drupal), with all tools needed for CI Build/Tests.

- Fork from [juampynr/drupal8ci](https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/)
- Based on  [Drupal official image](https://hub.docker.com/_/drupal/), added
  - [Node.js](https://nodejs.org/en/) 10 + [Yarn](https://yarnpkg.com)
  - [Php + Apache](https://github.com/docker-library/php/tree/master/7.2/stretch/apache) added extensions: xsl, imagick, xdebug
  - [Composer](https://getcomposer.org) + [Prestissimo plugin](https://github.com/hirak/prestissimo)
  - [Robo CI](http://robo.li)
  - [Phpqa](https://github.com/EdgedesignCZ/phpqa)
  - [Docker CE](https://store.docker.com/search?type=edition&offering=community)
  - [Drupal Coder](https://www.drupal.org/project/coder)
  - Mariadb (MySQL) client