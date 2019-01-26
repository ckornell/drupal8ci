# Drupal 8 CI Docker image for Gitlab CI

[![Image size](https://images.microbadger.com/badges/image/mogtofu33/drupal8ci.svg)](https://microbadger.com/images/mogtofu33/drupal8ci)
[![Docker Build Status](https://img.shields.io/docker/build/mogtofu33/drupal8ci.svg)](https://hub.docker.com/r/mogtofu33/drupal8ci/)
[![pipeline status](https://gitlab.com/mog33/drupal8ci/badges/master/pipeline.svg)](https://gitlab.com/mog33/drupal8ci/commits/master)

![_](https://img.shields.io/github/license/Mogtofu33/drupal8ci.svg)

## Details

[Drupal 8](https://www.drupal.org/8) tools image with all Php / Node tools needed for CI or Local Build/Tests/Lint.

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
    - [Phpstan](https://github.com/phpstan/phpstan)
    - [Psalm](https://github.com/vimeo/psalm)
    - [Security-checker](https://github.com/sensiolabs/security-checker)
  - [Drupal Coder](https://www.drupal.org/project/coder)
  - Mariadb (MySQL) client
  - [jq](https://stedolan.github.io/jq/)
  - [Shellcheck](https://www.shellcheck.net)
  - [Drupal core node tools](https://cgit.drupalcode.org/drupal/plain/core/package.json)
    - [Eslint](https://eslint.org/)
    - [Stylelint](https://github.com/stylelint/stylelint)
    - [Prettier](https://github.com/prettier/prettier)
    - [Nightwatch.js](http://nightwatchjs.org/)
    - Added: [Sasslint@1.13](https://github.com/sasstools/sass-lint)

## Basic usage (local)

### QA examples

From your Drupal root folder (where you have composer.json), as a starting point you an copy from [Gitlab CI dor Drupal 8](https://gitlab.com/mog33/gitlab-ci-drupal/tree/master):

- .phpqa.yml
- .phpmd.xml
- .sass-lint.yml
- .eslintignore
- phpstan.neon

```shell
docker run -it --rm -v $(pwd):/var/www/html mogtofu33/drupal8ci:8.6 \
  phpqa --report --buildDir reports \
  # Set your custom code folder.
  --analyzedDirs web/modules/custom \
  # Select any tests
  --tools phpcs,phpmd,phpcpd,parallel-lint,phploc
```

```shell
docker run -it --rm -v $(pwd):/var/www/html mogtofu33/drupal8ci:8.6 \
  phpqa --report --buildDir reports --analyzedDirs web/modules/custom --tools pdepend
```

```shell
docker run -it --rm -v $(pwd):/var/www/html mogtofu33/drupal8ci:8.6 \
  phpqa --report --buildDir reports --analyzedDirs web/modules/custom --tools phpmetrics
```

```shell
docker run -it --rm -v $(pwd):/var/www/html mogtofu33/drupal8ci:8.6 \
  phpqa --report --buildDir reports --analyzedDirs web/modules/custom --tools phpstan
```

### Security checker

```shell
docker run -it --rm -v $(pwd):/var/www/html mogtofu33/drupal8ci:8.6 \
  security-checker security:check
```

### Linting examples

```shell
docker run -it --rm -v $(pwd):/var/www/html mogtofu33/drupal8ci:8.6 \
  eslint -f table -c web/core/.eslintrc.passing.json web/modules/custom/**/*.js web/themes/custom/**/*.js
```

```shell
docker run -it --rm -v $(pwd):/var/www/html mogtofu33/drupal8ci:8.6 \
  stylelint --config-basedir /root/node_modules/ --config web/core/.stylelintrc.json "web/themes/custom/**/css/*.css"
```

```shell
docker run -it --rm -v $(pwd):/var/www/html mogtofu33/drupal8ci:8.6 \
  stylelint --config-basedir /root/node_modules/ --config web/core/.stylelintrc.json -s scss "web/themes/custom/**/scss/*.scss"
```

```shell
docker run -it --rm -v $(pwd):/var/www/html mogtofu33/drupal8ci:8.6 \
  sass-lint --config /.sass-lint.yml --verbose --no-exit --format html --output sass-lint-report.html
```
