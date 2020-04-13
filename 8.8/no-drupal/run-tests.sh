#!/bin/bash
set -eu

run_tests() {
  # eval "$(curl -q -s https://raw.githubusercontent.com/coryb/osht/master/osht.sh)"
  eval "$(curl -q -s https://raw.githubusercontent.com/dcsobral/osht/bug/junitXML/osht.sh)"

  # Force report file.
  OSHT_JUNIT=1
  OSHT_JUNIT_OUTPUT=/report.xml

  __num=12

  if [ -f "/var/www/html/vendor/bin/drush" ]; then
    __num=13
    # Print Drupal version.
    if [ -f "/var/www/html/composer.json" ]; then 
      __num=14
  RUNS /var/www/html/vendor/bin/drush --root="/var/www/html" status --fields="drupal-version"
    fi
  RUNS /var/www/html/vendor/bin/drush --version
  fi

  RUNS php -v
  RUNS apache2 -v
  RUNS composer --version
  RUNS mysql -V
  RUNS robo -V
  RUNS node --version
  RUNS yarn versions
  RUNS phpqa tools
  RUNS jq --version
  RUNS google-chrome --version
  RUNS chromedriver --version

  # Get and compare Chrome and Chromedriver versions.
  __chrome_version=($(google-chrome --version))
  __chrome_version=${__chrome_version[2]}
  __chrome_version=(${__chrome_version//./ })
  __chrome_version=${__chrome_version[0]}
  __chromedriver_version=($(chromedriver --version))
  __chromedriver_version=${__chromedriver_version[1]}
  __chromedriver_version=(${__chromedriver_version//./ })
  __chromedriver_version=${__chromedriver_version[0]}

  OSHT_VERBOSE=1
  IS $__chromedriver_version == $__chrome_version

  PLAN $__num
}

if [ ${1:-""} = "report" ]; then
  # Silent and return xml.
  tests=$( run_tests &>/dev/null)
  cat /report.xml
else
  run_tests
fi
