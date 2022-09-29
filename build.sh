#!/bin/bash

# build context directory based on the given version to build
buildContext() {
  version=$1
  if [ $version == "8.0" ] || [ $version == 'nightly-8' ]; then
    echo "8.0"
  elif [ $version == '9.1' ] || [ $version == '9.2' ] || [ $version == '9.3' ]; then
    echo "9"
  elif [ $version == '9' ] || $version == '9.4' ]; then
    echo "9.4"
  else # when version = dev|nightly|sprint
    echo "10.0"
  fi
}

# if its the current LTS, we add 'latest' tag
isCurrentLTS() {
  version=$1
  if [ $version == "8.0" ]; then
    echo "yes"
  else
    echo "no"
  fi
}

# if this is a official release, we add a 'version' tag (e.g. 8.0.3)
isOfficialRelease() {
  version=$1
  if [ $version == "dev" ] || [ $version == "nightly" ] || [ $version == "sprint" ] || [ $version == "nightly-8" ]; then
    echo "no"
  else
    echo "yes"
  fi
}

###########################################################################
# build.sh
#--------------------------------------------------------------------------
# builds the axonivy-engine image and push it to docker hub
# param 1: version
# -- dev, sprint, nightly   -> development builds without further tags
# -- 8.0                    -> LTS release -> Additional version tag e.g. 8.0.1
# -- 9.1,9.2                -> LE release  -> Additional version tag e.g. 9.1.2
############################################################################
VERSION=$1
ENGINE_URL=https://developer.axonivy.com/permalink/${VERSION}/axonivy-engine.zip
IMAGE=axonivy/axonivy-engine
echo "download ${ENGINE_URL}"

REDIRECTED_URL=$(curl -sI ${ENGINE_URL} | tr -d '\r' | sed -En 's/^location: (.*)/\1/p')
echo "redirected to ${REDIRECTED_URL}"

FULL_VERSION=$(echo "${REDIRECTED_URL}" | grep -oP '(\d+\.\d+.\d+)' | head -1)
echo "version to build ${FULL_VERSION}"

buildContextDirectory=axonivy-engine/$(buildContext $VERSION)
echo "build image in build context directory $buildContextDirectory"

IMAGE_TAG=${IMAGE}:${VERSION}
docker build --pull -t ${IMAGE_TAG} ${buildContextDirectory} --build-arg IVY_ENGINE_DOWNLOAD_URL=${ENGINE_URL}
docker push ${IMAGE_TAG}

if [ $(isOfficialRelease $VERSION) == "yes" ]; then
    FULL_VERSION_TAG=${IMAGE}:${FULL_VERSION}
    echo "tag official release with ${FULL_VERSION_TAG}"
    docker tag ${IMAGE_TAG} ${FULL_VERSION_TAG}
    docker push ${FULL_VERSION_TAG}
    docker rmi ${FULL_VERSION_TAG}
fi

if [ $(isCurrentLTS $VERSION) == "yes" ]; then
    LATEST_VERSION_TAG=${IMAGE}:latest
    echo "tag official LTS release with ${LATEST_VERSION_TAG}"
    docker tag ${IMAGE_TAG} ${LATEST_VERSION_TAG}
    docker push ${LATEST_VERSION_TAG}
    docker rmi ${LATEST_VERSION_TAG}
fi

docker rmi ${IMAGE_TAG}
