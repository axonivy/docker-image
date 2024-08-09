# Changelog

## 2024-08-09

- Change base image from `docker.io/eclipse-temurin:21-jre-yammy` to `docker.io/eclipse-temurin:21-jre-noble` for version 11.4 and higher.

## 2024-07-11

- Change base image from `docker.io/eclipse-temurin:17-jre-jammy` to `docker.io/eclipse-temurin:21-jre-jammy` for version 11.4 and higher.

## 2023-06-07

### Added

- Provide Axon Ivy Engine images for linux/arm64 os architecture (8.0.34 and higher, 10.0.9 and higher, 11.1.1 and higher, 11.2.0 and higher)

## 2023-06-06

### Changed

- Add HEALTHCHECK for 11.1.0 and higher

## 2023-04-10

### Changed

- No longer create system database if it does not exist on container startup with `docker-entrypoint.sh`. This can be configured in `ivy.yaml` if needed.
  - Leading Edge: 11.1.0 and higher

## 2023-02-21

### Changed

- Extend base image reference with registry url (docker.io) for all images.
- Make images OpenShift compatible by applying the [arbitrary user id](https://docs.openshift.com/container-platform/4.12/openshift_images/create-images.html#images-create-guide-openshift_create-images) logic for all images.

## 2022-09-28

### Changed

- Change base image from `eclipse-temurin:17-jre-focal` to `eclipse-temurin:17-jre-jammy` for images 10.0 and higher.

## 2022-09-05

### Changed

- Change base image from `eclipse-temurin:11-jre-focal` to `eclipse-temurin:17-jre-focal` for images 9.4 and higher.

## 2022-28-01

### Changed

- Change base image from unmaintaned `adoptopenjdk/openjdk11:debianslim-jre` image to maintained `eclipse-temurin:11-jre-focal` image. This changes affects the following versions:
  - LTS 8.0: 8.0.25 and higher
  - Leading Edge 9: 9.3.3 and higher

## 2021-03-11

### Changed

- Axon Ivy Engine Docker image is no longer built on the Axon Ivy Engine Debian package.
  This change affects the following versions:
  - LTS 8.0: 8.0.15 and higher
  - Leading Edge 9: 9.1.1 and higher

- web.xml and context.xml not available in global configuration directory LTS 8.0 (8.0.15 and higher)
  - web.xml must be mounted /usr/lib/axonivy-engine/webapps/ivy/WEB-INF/web.xml
  - context.xml must be mounted /usr/lib/axonivy-engine/webapps/ivy/META-INF/context.xml
