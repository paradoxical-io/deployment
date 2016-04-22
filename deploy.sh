#!/usr/bin/env bash

if [ -z "$GPG_PRIVATE_KEY_ENCRYPTION_IV" ]; then
    exit 0
fi

if [ -n "$TRAVIS_TAG" ]; then
    echo "Deploying release version for tag '${TRAVIS_TAG}'"
    mvn clean deploy --settings settings.xml -DskipTests -P release -Drevision=''
    exit $?
elif [ "$TRAVIS_BRANCH" = "master" ]; then
    echo "Deploying snapshot version on branch '${TRAVIS_BRANCH}'"
    mvn clean deploy --settings settings.xml -DskipTests
    exit $?
fi
