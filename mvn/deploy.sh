MVN_SCRIPT_DIR=`dirname $0`

function snapshot() {
  mvn clean deploy --settings "${MVN_SCRIPT_DIR}/settings.xml" \
        -P snapshot \
        -DskipTests $@
}

function release() {
  mvn clean deploy --settings "${MVN_SCRIPT_DIR}/settings.xml" \
      -P release \
      -DskipTests \
      -Drevision="$REVISION" \
      -Ddeployment.directory="${SCRIPT_DIR}" $@
}
