# Drupal 8 CI Docker image for Gitlab CI

[![Image size](https://images.microbadger.com/badges/image/mogtofu33/drupal8ci.svg)](https://microbadger.com/images/mogtofu33/drupal8ci)
[![Docker Build Status](https://img.shields.io/docker/build/mogtofu33/drupal8ci.svg)](https://hub.docker.com/r/mogtofu33/drupal8ci/)
[![pipeline status](https://gitlab.com/mog33/drupal8ci/badges/master/pipeline.svg)](https://gitlab.com/mog33/drupal8ci/commits/master)

![_](https://img.shields.io/github/license/Mogtofu33/drupal8ci.svg)

## Details

[Drupal 8](https://www.drupal.org/8) ci image with a lot of Php/NodeJs tools needed for CI or Local Build/Tests/Lint.

Used with project [Gitlab CI Drupal](https://gitlab.com/mog33/gitlab-ci-drupal).

- Fork from [juampynr/drupal8ci](https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/)
- Based on  [Drupal official image](https://hub.docker.com/_/drupal/), added
  - [Node.js 10](https://nodejs.org/en/) + [Yarn](https://yarnpkg.com)
  - [Php7 + Apache](https://github.com/docker-library/php/tree/master/7.2/stretch/apache) added extensions: xsl, imagick, xdebug
  - [Composer](https://getcomposer.org) + [Prestissimo plugin](https://github.com/hirak/prestissimo)
  - [Robo CI](http://robo.li)
  - [Phpqa](https://github.com/EdgedesignCZ/phpqa) including:
    - [Phpmetrics](https://www.phpmetrics.org)
    - [Phploc](https://github.com/sebastianbergmann/phploc)
    - [Phpcs](https://github.com/squizlabs/PHP_CodeSniffer)
    - [Phpmd](https://phpmd.org)
    - [Pdepend](https://pdepend.org)
    - [Phpcpd](https://github.com/sebastianbergmann/phpcpd)
    - [Security-checker](https://github.com/sensiolabs/security-checker)
  - [Drupal Coder](https://www.drupal.org/project/coder)
  - Mariadb (MySQL) client
  - [jq](https://stedolan.github.io/jq/)

## Basic usage (local)

The default image `8.8-drupal` include Drupal core managed by Composer with Google Chrome.

Tag `8.9-drupal` rely on current Drupal `8.9.x-dev` version.

Base images `no-drupal` are used for a project including a Drupal template from a `composer.json` and are all the same.

To use with a local Drupal 8 managed by Composer, mount your Drupal on `/var/www/html`

## Build

CI variable `CI_DO_RELEASE`, default to `1` to push to Docker hub.

Other variables to skip jobs:

```bash
SKIP_BASE                0
SKIP_CURRENT             0
SKIP_TEST                0
SKIP_DEV                 0
```

```bash
# 8.x and 8.x-dev are template files, can generate the files with:
make prepare
```

----
Want some help implementing this on your project? I provide Drupal 8 expertise as a freelance, just [contact me](https://developpeur-drupal.com/en).
