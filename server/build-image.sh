#!/bin/bash -e

EXPIRE_AFTER="${EXPIRE_AFTER:-2w}"

EXPIRES_AFTER_LABEL=""
if [ ! -z "$BRANCH_NAME" -a "$BRANCH_NAME" != "master" -a "$BRANCH_NAME" != "8.0.N" ]; then
    # Add expiration label so it can be deleted by quay automatically
    EXPIRES_AFTER_LABEL="--label quay.expires-after=$EXPIRE_AFTER"
fi

if [ -z "$EXPIRES_AFTER_LABEL" ]; then
    echo "Building image with three tags: '$IMAGE_NAME', '$IMAGE_NAME_WITH_BASE_OS', and '$IMAGE_NAME_WITH_BASE_OS_AND_SHA' ..."
else
    echo "Building image with three tags: '$IMAGE_NAME', '$IMAGE_NAME_WITH_BASE_OS', and '$IMAGE_NAME_WITH_BASE_OS_AND_SHA' with label: '$EXPIRES_AFTER_LABEL'..."
fi

docker build --force-rm=true --no-cache=true --build-arg KEYCLOAK_VERSION=$KEYCLOAK_VERSION -t quay.io/$IMAGE_NAME_WITH_BASE_OS_AND_SHA -t quay.io/$IMAGE_NAME -t quay.io/$IMAGE_NAME_WITH_BASE_OS -f Dockerfile . $EXPIRES_AFTER_LABEL
