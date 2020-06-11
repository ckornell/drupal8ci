# Drupal 8 CI Docker image for Gitlab CI

## Details

[Drupal 8](https://www.drupal.org/8) ci image with a lot of Php/NodeJs tools needed for CI or Local Build/Tests/Lint.

Used with project [Gitlab CI Drupal](https://gitlab.com/mog33/gitlab-ci-drupal).

- Fork from [juampynr/drupal8ci](https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/)
- Based on  [Drupal official image](https://hub.docker.com/_/drupal/), added
  - [Node.js 10](https://nodejs.org/en/) + [Yarn](https://yarnpkg.com)
  - [Php7 + Apache](https://github.com/docker-library/php/tree/master/7.3/stretch/apache) added extensions: xsl, imagick, xdebug
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

The default image `8.8` include Drupal core managed by Composer with Google Chrome.

Tag `8.9` rely on current Drupal `8.9` latest tag (alpha, beta, stable...) version.

Tag `9.0` rely on current Drupal `9.0` latest tag (alpha, beta, stable...) version.

Tag with suffix `-base` do not include Drupal.

To use with a local Drupal 8 managed by Composer, mount your Drupal on `/var/www/html`

## Build

CI variable `CI_DO_RELEASE`, default to `1` to push to Docker hub.

```bash
make prepare
```

## Tests

Basic version check tests with [Obvious Shell Testing (osht)](https://github.com/coryb/osht).

```bash
docker run -it --rm mogtofu33/drupal8ci:2.x-dev-8.8 /scripts/run-tests.sh
```

----
Want some help implementing this on your project? I provide Drupal expertise as a freelance, just [contact me](https://developpeur-drupal.com/en).
