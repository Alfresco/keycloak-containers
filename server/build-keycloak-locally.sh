#!/bin/bash -e

### Available environment variables:
# - GIT_REPO
# - GIT_BRANCH ('master' will be used if not set)
# - THEME_VERSION
# or
# - KEYCLOAK_DIST
#
### Available parameters:
# - git_repo
# - git_branch ('master' will be used if not set)
# - theme_version
# or
# - keycloak_dist
#
# Example:
# sh build-keycloak-locally.sh git_repo=Alfresco/myrepo git_branch=test-branch theme_version=0.1
#
### Note: ENV variables will take precedence over the passed parameters.
#

ARGS=$@
for arg in $ARGS; do
    eval "$arg"
done

mkdir -p temp
cd temp

GIT_REPO="${GIT_REPO:-$git_repo}"
GIT_BRANCH="${GIT_BRANCH:-$git_branch}"
KEYCLOAK_DIST="${KEYCLOAK_DIST:-$keycloak_dist}"

if [ "$GIT_REPO" != "" ]; then
    if [ "$GIT_BRANCH" == "" ]; then
        GIT_BRANCH="master"
    fi

    THEME_VERSION="${THEME_VERSION:-$theme_version}"
    export THEME_VERSION="$THEME_VERSION"

    # Clone repository
    git clone --depth 1 https://github.com/$GIT_REPO.git -b $GIT_BRANCH keycloak-source

    # Build
    cd keycloak-source

    MASTER_HEAD=$(git log -n1 --format="%H")
    echo "Build Keycloak from: $GIT_REPO/$GIT_BRANCH/commit/$MASTER_HEAD"

    mvn -Pdistribution -pl distribution/server-dist -am -Dmaven.test.skip clean install
    # Add Alfresco theme
    ./add-alfresco-theme.sh

    cd ..
    unzip -oq keycloak-source/distribution/server-dist/target/keycloak-*.zip

    mv keycloak-?.?.?* keycloak

else
    echo "Download Keycloak from: $KEYCLOAK_DIST"
    if [ -z "$KEYCLOAK_DIST" ]; then
        echo "KEYCLOAK_DIST variable is not set."
        exit 1
    fi

    curl -sSLO $KEYCLOAK_DIST
    unzip -oq keycloak-*.zip
    rm keycloak-*.zip
    mv keycloak-?.?.?* keycloak
fi
