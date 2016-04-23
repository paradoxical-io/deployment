#!/usr/bin/env bash

if [ -z "$GPG_PRIVATE_KEY_ENCRYPTION_IV" ]; then
    exit 0
fi

SCRIPT_DIR=`dirname $0`

openssl aes-256-cbc -K ${GPG_PRIVATE_KEY_ENCRYPTION_KEY} -iv ${GPG_PRIVATE_KEY_ENCRYPTION_IV} \
  -in "${SCRIPT_DIR}/gpg/paradoxical-io-private.gpg.enc" \
  -out "${SCRIPT_DIR}/gpg/paradoxical-io-private.gpg" -d

if [ -n "$TRAVIS_TAG" ]; then
    echo "Deploying release version for tag '${TRAVIS_TAG}'"
    mvn clean deploy --settings "${SCRIPT_DIR}/settings.xml" -DskipTests -P release -Drevision=''
    exit $?
elif [ "$TRAVIS_BRANCH" = "master" ]; then
    echo "Deploying snapshot version on branch '${TRAVIS_BRANCH}'"
    mvn clean deploy --settings "${SCRIPT_DIR}/settings.xml" -DskipTests
    exit $?
fi
