#!/usr/bin/env bash

SCRIPT_DIR=`dirname $0`

echo "Deployment script running..."
echo "=== Build parameters ===
    TRAVIS_TAG=${TRAVIS_TAG}
    TRAVIS_BRANCH=${TRAVIS_BRANCH}
    TRAVIS_BUILD_ID=${TRAVIS_BUILD_ID}
    TRAVIS_BUILD_NUMBER=${TRAVIS_BUILD_NUMBER}
    TRAVIS_COMMIT=${TRAVIS_COMMIT}
    TRAVIS_COMMIT_RANGE=${TRAVIS_COMMIT_RANGE}
    TRAVIS_JOB_ID=${TRAVIS_JOB_ID}
    TRAVIS_JOB_NUMBER=${TRAVIS_JOB_NUMBER}
    TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST}
    TRAVIS_REPO_SLUG=${TRAVIS_REPO_SLUG}
    TRAVIS_SECURE_ENV_VARS=${TRAVIS_SECURE_ENV_VARS}
    SCRIPT_DIR=${SCRIPT_DIR}
    CONTINUOUS_INTEGRATION=${CONTINUOUS_INTEGRATION}

"

if [ "$TRAVIS_SECURE_ENV_VARS" != "true" -o "$TRAVIS_PULL_REQUEST" != "false" ]; then

    echo "No deployment running for pull requests $TRAVIS_PULL_REQUEST"
    exit 0
fi

echo "Decrypting gpg key..."

openssl aes-256-cbc -K ${GPG_PRIVATE_KEY_ENCRYPTION_KEY} -iv ${GPG_PRIVATE_KEY_ENCRYPTION_IV} \
  -in "${SCRIPT_DIR}/gpg/paradoxical-io-private.gpg.enc" \
  -out "${SCRIPT_DIR}/gpg/paradoxical-io-private.gpg" -d

echo "DONE decrypting gpg key!"

if [ -n "$TRAVIS_TAG" ]; then
    echo "Deploying release version for tag '${TRAVIS_TAG}'"
    mvn clean deploy --settings "${SCRIPT_DIR}/settings.xml" -DskipTests -P release -Drevision='' $@
    exit $?
elif [ "$TRAVIS_BRANCH" = "master" ]; then
    echo "Deploying snapshot version on branch '${TRAVIS_BRANCH}'"
    mvn clean deploy --settings "${SCRIPT_DIR}/settings.xml" -DskipTests -P snapshot $@
    exit $?
else
    echo "No deployment running for current settings"
    exit 0
fi
