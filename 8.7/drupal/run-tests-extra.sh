#!/bin/bash

if [ -x "$(command -v phpunit)" ]; then
  phpunit --version | grep 'PHPUnit'
else
  printf "%sPhpunit missing!%s\\n" "${red}" "${end}"
  __error=1
fi
