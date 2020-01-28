#!/bin/bash

# build context directory based on the given version to build
buildContext() {
  version=$1
  if [ $version == "dev" ] || [ $version == "nightly" ] || [ $version == "sprint" ] || [ $version == "latest" ]; then
    echo "9"
  else
    echo $version
  fi
}

# if this is a official release, cause of this an additional tag will made to the image
isOfficialRelease() {
  version=$1
  if [ $version == "8.0" ] || [ $version == "latest" ]; then
    echo "yes"
  else
    echo "no"
  fi
}

##########################################################################
# build.sh
#--------------------------------------------------------------------------
# builds the axonivy-engine image and push it to docker hub
# param 1: version
# -- dev, sprint, nightly   -> development builds without further tags
# -- 8.0                    -> LTS release, additonal version tag e.g. 8.0.1
# -- latest                 -> LE release, additional version tag e.g. 9.1.0
############################################################################
VERSION=$1
ENGINE_URL=https://developer.axonivy.com/permalink/${VERSION}/axonivy-engine.deb
IMAGE=axonivy/axonivy-engine
echo "download debian package from ${ENGINE_URL}"

REDIRECTED_URL=$(curl -sI ${ENGINE_URL} | tr -d '\r' | sed -En 's/^location: (.*)/\1/p')
echo "redirected to ${REDIRECTED_URL}"

FULL_VERSION=$(echo "${REDIRECTED_URL}" | grep -oP '(?<=_)(\d+\.\d+.\d+)(?=\.)')
echo "version to build ${FULL_VERSION}"

buildContextDirectory=axonivy-engine/$(buildContext $VERSION)
echo "build image in build context directory $buildContextDirectory"

IMAGE_TAG=${IMAGE}:${VERSION} 
docker build --pull -t ${IMAGE_TAG} ${buildContextDirectory} --build-arg IVY_ENGINE_DOWNLOAD_URL=${ENGINE_URL}
docker push ${IMAGE_TAG}

if [ $(isOfficialRelease $VERSION) == "yes" ]; then
    FULL_VERSION_TAG=${IMAGE}:${FULL_VERSION}
    echo "publish official release ${FULL_VERSION_TAG}"
    docker tag ${IMAGE_TAG} ${FULL_VERSION_TAG}
    docker push ${FULL_VERSION_TAG}
    docker rmi ${FULL_VERSION_TAG}
fi

docker rmi ${IMAGE_TAG}
