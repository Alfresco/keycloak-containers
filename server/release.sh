#!/bin/bash -e

declare -r currentDir="$(dirname "${BASH_SOURCE[0]}")"
source "${currentDir}/build.properties"

TAG=${KEYCLOAK_VERSION}
if [ -z "$TAG" ]; then
  echo "KEYCLOAK_VERSION variable is not set."
  exit 1
fi

CURRENT_BRANCH=$(git branch | grep '*' | cut -d' ' -f 2)

echo "Tag '$CURRENT_BRANCH' branch as '$TAG'"
git tag -f ${TAG} -m "[release-script][skip ci]"

echo "Push $TAG tag."
git push -f git@github.com:Alfresco/keycloak-containers.git ${TAG}
