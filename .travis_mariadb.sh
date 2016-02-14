#!/usr/bin/env bash

set -eu

# Install MariaDB if DB=mariadb
if [[ -n ${DB-} && x$DB =~ ^xmariadb ]]; then
  sudo apt-get -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold -y install libmariadbclient-dev
fi