#!/usr/bin/env bash

# Set ${TRAVIS} to false on non travis builds.
TRAVIS=${TRAVIS:-false}

# The directory, where the project is located. On travis this is set to TRAVIS_BUILD_DIR otherwise defaults to the current directory
DRUPAL_TRAVIS_PROJECT_BASEDIR=${DRUPAL_TRAVIS_PROJECT_BASEDIR:-${TRAVIS_BUILD_DIR:-$(pwd)}}

# The distribution to use. Currently only drupal core is supported.
DRUPAL_TRAVIS_DISTRIBUTION=${DRUPAL_TRAVIS_DISTRIBUTION:-drupal}

# The composer name of the current project, if not specified, it will be read from the composer.json.
DRUPAL_TRAVIS_COMPOSER_NAME=${DRUPAL_TRAVIS_COMPOSER_NAME:-$(jq -r .name ${DRUPAL_TRAVIS_PROJECT_BASEDIR}/composer.json)}

# The project name, if not provided, the second part of the composer name will be use. E.g. If the composer name is
# vendor/myproject the project name will be myproject.
DRUPAL_TRAVIS_PROJECT_NAME=${DRUPAL_TRAVIS_PROJECT_NAME-$(echo ${DRUPAL_TRAVIS_COMPOSER_NAME} | cut -d '/' -f 2)}

# The phpunit test group, defaults to the project name. To provide multiple groups, concatenate them with comma:
# E.g. DRUPAL_TRAVIS_TEST_GROUP="mygroup1,mygroup2"
DRUPAL_TRAVIS_TEST_GROUP=${DRUPAL_TRAVIS_TEST_GROUP-${DRUPAL_TRAVIS_PROJECT_NAME}}

# Boolean value if coding styles should be tested with burdamagazinorg/thunder-dev-tools.
# By default coding styles are tested.
DRUPAL_TRAVIS_TEST_CODING_STYLES=${DRUPAL_TRAVIS_TEST_CODING_STYLES:-true}

# Boolean value if javascript coding style should be tested.
# By default javascript coding styles are tested.
DRUPAL_TRAVIS_TEST_JAVASCRIPT=${DRUPAL_TRAVIS_TEST_JAVASCRIPT:-true}

# Boolean value if php coding style should be tested.
# By default php coding styles are tested.
DRUPAL_TRAVIS_TEST_PHP=${DRUPAL_TRAVIS_TEST_PHP:-true}

# The drupal version to test against. This can be any valid composer version string, but only drupal versions greater 8.6
# are supported.
DRUPAL_TRAVIS_DRUPAL_VERSION=${DRUPAL_TRAVIS_DRUPAL_VERSION:-^8.6}

# The base directory for all generated files. Into this diretory will be drupal installed and temp files stored.
# This directory gets removed after successful tests.
DRUPAL_TRAVIS_TEST_BASE_DIRECTORY=${DRUPAL_TRAVIS_TEST_BASE_DIRECTORY:-/tmp/test/${DRUPAL_TRAVIS_PROJECT_NAME}}

# The directory, where drupal will be installed, defaults to ${DRUPAL_TRAVIS_TEST_BASE_DIRECTORY}/install
# This directory gets removed after successful tests.
DRUPAL_TRAVIS_DRUPAL_INSTALLATION_DIRECTORY=${DRUPAL_TRAVIS_DRUPAL_INSTALLATION_DIRECTORY:-${DRUPAL_TRAVIS_TEST_BASE_DIRECTORY}/install}

# The directory, where lock files for finished stages will be saved, defaults to ${DRUPAL_TRAVIS_TEST_BASE_DIRECTORY}/finished-stages.
# This directory gets removed after successful tests.
DRUPAL_TRAVIS_LOCK_FILES_DIRECTORY=${DRUPAL_TRAVIS_LOCK_FILES_DIRECTORY:-${DRUPAL_TRAVIS_TEST_BASE_DIRECTORY}/finished-stages}

# The web server host. Defaults to 127.0.0.1
DRUPAL_TRAVIS_HTTP_HOST=${DRUPAL_TRAVIS_HTTP_HOST:-127.0.0.1}

# The web server port. Defaults to 8888
DRUPAL_TRAVIS_HTTP_PORT=${DRUPAL_TRAVIS_HTTP_PORT:-8888}

# The selenium chrome docker version to use. defaults to the latest version.
DRUPAL_TRAVIS_SELENIUM_CHROME_VERSION=${DRUPAL_TRAVIS_SELENIUM_CHROME_VERSION:-latest}

# The selenium host. Defaults to the web server host.
DRUPAL_TRAVIS_SELENIUM_HOST=${DRUPAL_TRAVIS_SELENIUM_HOST:-${DRUPAL_TRAVIS_HTTP_HOST}}

# The selenium port. Defaults to 4444.
DRUPAL_TRAVIS_SELENIUM_PORT=${DRUPAL_TRAVIS_SELENIUM_PORT:-4444}

# The database host. Defaults to the web server host.
DRUPAL_TRAVIS_DATABASE_HOST=${DRUPAL_TRAVIS_DATABASE_HOST:-${DRUPAL_TRAVIS_HTTP_HOST}}

# The database port. Defaults to 3306.
DRUPAL_TRAVIS_DATABASE_PORT=${DRUPAL_TRAVIS_DATABASE_PORT:-3306}

# The database user. Defaults to travis, which is the default travis database user.
DRUPAL_TRAVIS_DATABASE_USER=${DRUPAL_TRAVIS_DATABASE_USER:-travis}

# The database password for ${DRUPAL_TRAVIS_DATABASE_USER}, empty by default.
DRUPAL_TRAVIS_DATABASE_PASSWORD=${DRUPAL_TRAVIS_DATABASE_PASSWORD}

# The database name. Defaults to drupaltesting
DRUPAL_TRAVIS_DATABASE_NAME=${DRUPAL_TRAVIS_DATABASE_NAME:-drupaltesting}

# The Test runner to use. Allowed values are phpunit and run-tests, defaults to phpunit.
# If you prefer the output of drupal run-tests.sh set this to run-tests
DRUPAL_TRAVIS_TEST_RUNNER=${DRUPAL_TRAVIS_TEST_RUNNER:-phpunit}

# By default all created files are deleted after successfull test runs, you can disable this behaviour by setting
# this to true.
DRUPAL_TRAVIS_NO_CLEANUP=${DRUPAL_TRAVIS_NO_CLEANUP:-false}

# The symfony environment variable to ignore deprecations, for possible values see symfony documentation.
# The default value is "week" to ignore any deprecation notices.
export SYMFONY_DEPRECATIONS_HELPER=${SYMFONY_DEPRECATIONS_HELPER-weak}

# The url that simpletest will use.
export SIMPLETEST_BASE_URL=${SIMPLETEST_BASE_URL:-http://${DRUPAL_TRAVIS_HTTP_HOST}:${DRUPAL_TRAVIS_HTTP_PORT}}

# The database string, that simpletest will use.
export SIMPLETEST_DB=${SIMPLETEST_DB:-mysql://${DRUPAL_TRAVIS_DATABASE_USER}:${DRUPAL_TRAVIS_DATABASE_PASSWORD}@${DRUPAL_TRAVIS_DATABASE_HOST}:${DRUPAL_TRAVIS_DATABASE_PORT}/${DRUPAL_TRAVIS_DATABASE_NAME}}

# The driver args for webdriver. When testing locally, we use chromedriver, which uses a different URL than
# the selenium hub, that is used for travis runs.
if ${TRAVIS}; then
    export MINK_DRIVER_ARGS_WEBDRIVER=${MINK_DRIVER_ARGS_WEBDRIVER-"[\"chrome\", null, \"http://${DRUPAL_TRAVIS_SELENIUM_HOST}:${DRUPAL_TRAVIS_SELENIUM_PORT}/wd/hub\"]"}
else
    export MINK_DRIVER_ARGS_WEBDRIVER=${MINK_DRIVER_ARGS_WEBDRIVER-"[\"chrome\", null, \"http://${DRUPAL_TRAVIS_SELENIUM_HOST}:${DRUPAL_TRAVIS_SELENIUM_PORT}\"]"}
fi
