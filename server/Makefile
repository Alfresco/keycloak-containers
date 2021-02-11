include build.properties
export $(shell sed 's/=.*//' build.properties)

IMAGE_NAME							:=alfresco/alfresco-identity-service:$(IDENTITY_VERSION)
IMAGE_NAME_WITH_BASE_OS				:=$(IMAGE_NAME)-java-11-openjdk-ubi8-minimal
IMAGE_NAME_WITH_BASE_OS_AND_SHA		:=$(IMAGE_NAME_WITH_BASE_OS)-$(shell git rev-parse HEAD | cut -c1-12)
export IMAGE_NAME
export IMAGE_NAME_WITH_BASE_OS
export IMAGE_NAME_WITH_BASE_OS_AND_SHA

# Alfresco keycloak variables
KEYCLOAK_DIST	:=https://github.com/Alfresco/keycloak/releases/download/$(KEYCLOAK_VERSION)/keycloak-$(KEYCLOAK_VERSION).zip
# Dev properties
GIT_REPO		:=Alfresco/keycloak
# 'master' will be used if not set
GIT_BRANCH		:=
THEME_VERSION	?=0.3.2


build: download_keycloak build_image push_private cleanup

download_keycloak:
	@./build-keycloak-locally.sh keycloak_dist=$(KEYCLOAK_DIST)

# Dev time rule
build_keycloak:
	@./build-keycloak-locally.sh git_repo=$(GIT_REPO) git_branch=$(GIT_BRANCH) theme_version=$(THEME_VERSION) || (echo "Couldn't build keycloak. Make sure you are building with the correct Java version."; rm -rf temp; exit 1)

build_image:
	@./build-image.sh

push_private:
	@echo "Push private docker image..."
	@docker push quay.io/$(IMAGE_NAME)
	@docker push quay.io/$(IMAGE_NAME_WITH_BASE_OS)
	@docker push quay.io/$(IMAGE_NAME_WITH_BASE_OS_AND_SHA)

tag_push_public:
	@echo "Tag and push public image..."
	@docker tag quay.io/$(IMAGE_NAME_WITH_BASE_OS_AND_SHA) $(IMAGE_NAME) && docker push $(IMAGE_NAME)
	@docker tag quay.io/$(IMAGE_NAME_WITH_BASE_OS_AND_SHA) $(IMAGE_NAME_WITH_BASE_OS) && docker push $(IMAGE_NAME_WITH_BASE_OS)
	@docker tag quay.io/$(IMAGE_NAME_WITH_BASE_OS_AND_SHA) $(IMAGE_NAME_WITH_BASE_OS_AND_SHA) && docker push $(IMAGE_NAME_WITH_BASE_OS_AND_SHA)

cleanup:
	@rm -rf temp

run:
	@docker run -e DB_VENDOR=h2 -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin --name alfresco-ids -p 8080:8080  --rm quay.io/$(IMAGE_NAME)

stop:
	@docker stop alfresco-ids

sh:
	@docker exec -it $$(docker ps -aq --filter name=alfresco-ids) bash
