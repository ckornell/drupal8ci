#!/bin/bash
set -e

function _get_robo_file() {
  if [ -f ${CI_PROJECT_DIR}/.gitlab-ci/RoboFile.php ]; then
    cp ${CI_PROJECT_DIR}/.gitlab-ci/RoboFile.php ${CI_PROJECT_DIR} || true
  else
    if [ ${VERBOSE} == 1 ]; then
      curl -fSL ${CI_REMOTE_FILES}/RoboFile.php --output ${CI_PROJECT_DIR}/RoboFile.php
    else
      curl -fsSL ${CI_REMOTE_FILES}/RoboFile.php --output ${CI_PROJECT_DIR}/RoboFile.php
    fi
  fi
}

###############################################################################
# Main
#
# Run any function defined above if exist when calling this script.
###############################################################################

_main() {
  # Run command if exist.
  __call="_${1}"
  if [[ "$(type -t "${__call}")" == 'function' ]]
  then
    $__call
  else
    printf "[ERROR] Unknown command: ${1}"
  fi
}


_main "$@"