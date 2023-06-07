#!/bin/bash

# build context directory based on the given version to build
buildContext() {
  version=$1
  if [ $version == "8.0" ] || [ $version == 'nightly-8.0' ]; then
    echo "8.0"
  elif [ $version == '9.1' ] || [ $version == '9.2' ] || [ $version == '9.3' ]; then
    echo "9"
  elif [ $version == '9' ] || [ $version == '9.4' ]; then
    echo "9.4"
  elif [ $version == '10.0' ] || [ $version == 'nightly-10.0' ]; then
    echo "10.0"
  else # when version = dev|nightly|sprint
    echo "11"
  fi
}

# if its the current LTS, we add 'latest' tag
isCurrentLTS() {
  version=$1
  if [ $version == "10.0" ]; then
    echo "yes"
  else
    echo "no"
  fi
}

# if this is a official release, we add a 'version' tag (e.g. 8.0.3)
isOfficialRelease() {
  version=$1
  if [ $version == "dev" ] || [ $version == "nightly" ] || [ $version == "sprint" ] || [[ $version == nightly* ]]; then
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
# param 2: --push
# -- if set to true, images will be pushed to the docker registry
# -- default: false
############################################################################
VERSION=$1
if [ -z $VERSION ]; then
  echo "Parameter 1: version is required"
  exit 0
fi

PUSH=0
if [ $# -eq 2 ]; then
  if [ $2 = "--push" ]; then
    PUSH=1
  fi
fi
ENGINE_URL=https://developer.axonivy.com/permalink/${VERSION}/axonivy-engine.zip
echo "download ${ENGINE_URL}"
echo "push ${PUSH} (0=NO, 1=YES)"

IMAGE=axonivy/axonivy-engine-local
if [ "$PUSH" = "1" ]; then
  IMAGE=axonivy/axonivy-engine
fi
echo "building image ${IMAGE}"

REDIRECTED_URL=$(curl -sI ${ENGINE_URL} | tr -d '\r' | sed -En 's/^location: (.*)/\1/p')
echo "redirected to ${REDIRECTED_URL}"

FULL_VERSION=$(echo "${REDIRECTED_URL}" | grep -oP '(\d+\.\d+.\d+)' | head -1)
echo "version to build ${FULL_VERSION}"

buildContextDirectory=axonivy-engine/$(buildContext $VERSION)
echo "build image in build context directory $buildContextDirectory"

docker buildx create --name mymultibuilder --driver docker-container --bootstrap --use
IMAGE_TAG=${IMAGE}:${VERSION}
PUSHIT=""
if [ "$PUSH" = "1" ]; then
  PUSHIT="--push"
fi
docker buildx build --platform linux/amd64,linux/arm64 --no-cache --pull -t ${IMAGE_TAG} ${buildContextDirectory} --build-arg IVY_ENGINE_DOWNLOAD_URL=${ENGINE_URL} ${PUSHIT}

if [ $(isOfficialRelease $VERSION) == "yes" ]; then
    FULL_VERSION_TAG=${IMAGE}:${FULL_VERSION}
    echo "tag official release with ${FULL_VERSION_TAG}"
    docker tag ${IMAGE_TAG} ${FULL_VERSION_TAG}
    if [ "$PUSH" = "1" ]; then
      docker push ${FULL_VERSION_TAG}
      docker rmi ${FULL_VERSION_TAG}
    fi
fi

if [ $(isCurrentLTS $VERSION) == "yes" ]; then
    LATEST_VERSION_TAG=${IMAGE}:latest
    echo "tag official LTS release with ${LATEST_VERSION_TAG}"
    docker tag ${IMAGE_TAG} ${LATEST_VERSION_TAG}
    
    if [ "$PUSH" = "1" ]; then
      docker push ${LATEST_VERSION_TAG}
      docker rmi ${LATEST_VERSION_TAG}
    fi
fi

if [ "$PUSH" = "1" ]; then
  docker rmi ${IMAGE_TAG}
fi
