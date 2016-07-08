#!/usr/bin/env bash

SCRIPT_DIR=`dirname $0`

if [ ! -e ".travis.yml" ]; then
    echo ".travis.yml file not found, creating one from the default..."
    cp "${SCRIPT_DIR}/default-travis.yml" ".travis.yml"
fi

if [ -z "${SONATYPE_PASSWORD}" ]; then
    read -p "SONATYPE_PASSWORD=" SONATYPE_PASSWORD
fi

if [ -z "${GPG_PASSWORD}" ]; then
    read -p "GPG_PASSWORD=" GPG_PASSWORD
fi

travis encrypt "SONATYPE_PASSWORD='${SONATYPE_PASSWORD}'" -a
travis encrypt "GPG_PASSWORD='${GPG_PASSWORD}'" -a

if [ -z "${GPG_PRIVATE_KEY_ENCRYPTION_KEY}" ]; then

    travis encrypt-file "${SCRIPT_DIR}/gpg/paradoxical-io-private.gpg" \
        "${SCRIPT_DIR}/gpg/paradoxical-io-private.gpg.enc" \
        -w "${SCRIPT_DIR}/gpg/paradoxical-io-private.gpg" -p

    echo "use \$GPG_PRIVATE_KEY_ENCRYPTION_KEY and \$GPG_PRIVATE_KEY_ENCRYPTION_IV for the file encryption command instead"
fi

if [ -z "${GPG_PRIVATE_KEY_ENCRYPTION_KEY}" ]; then
    read -p "GPG_PRIVATE_KEY_ENCRYPTION_KEY=" GPG_PRIVATE_KEY_ENCRYPTION_KEY
fi

if [ -z "${GPG_PRIVATE_KEY_ENCRYPTION_IV}" ]; then
    read -p "GPG_PRIVATE_KEY_ENCRYPTION_IV=" GPG_PRIVATE_KEY_ENCRYPTION_IV
fi

travis encrypt "GPG_PRIVATE_KEY_ENCRYPTION_KEY=${GPG_PRIVATE_KEY_ENCRYPTION_KEY}" -a
travis encrypt "GPG_PRIVATE_KEY_ENCRYPTION_IV=${GPG_PRIVATE_KEY_ENCRYPTION_IV}" -a
