FROM docker.io/ubuntu:24.04 AS build

ARG IVY_ENGINE_DOWNLOAD_URL

ADD ${IVY_ENGINE_DOWNLOAD_URL} /ivy.zip
RUN apt-get update && \
    apt-get install -y unzip && \
    unzip /ivy.zip -x "bin/*.exe" -x "bin/*.dll" -x "bin/AxonIvyEngine.service" -x "bin/InstallService.sh" -x "opensearch/bin/*.bat" -d /ivy && \
    mkdir /ivy/applications && \
    mkdir /ivy/data && \
    mkdir /ivy/logs && \
    mkdir /ivy/configuration/applications && \
    # sets the permission of the group to the same as the user
    # in OpenShift you need to run with any user but the user is
    # part of the group
    chmod -R g=u /ivy

FROM docker.io/eclipse-temurin:25-jre-noble
LABEL maintainer="Axon Ivy AG <info@axonivy.com>"

RUN usermod -l ivy ubuntu && \
    groupmod -n ivy ubuntu

RUN apt-get update && \
    apt-get install -y curl wget && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build --chown=1000:0 /ivy /ivy
RUN chmod g+w /ivy

VOLUME [ "/ivy/data", "/ivy/configuration", "/ivy/applications" ]

WORKDIR /ivy
USER 1000
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5m --retries=3 CMD curl -f http://localhost:8080/ || exit 1
ENTRYPOINT ["/ivy/bin/AxonIvyEngine"]
