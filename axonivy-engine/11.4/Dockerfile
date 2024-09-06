FROM docker.io/ubuntu:24.04 AS build

ARG IVY_ENGINE_DOWNLOAD_URL

ADD ${IVY_ENGINE_DOWNLOAD_URL} /tmp/ivy.zip
RUN apt-get update && \
    apt-get install -y unzip && \
    unzip /tmp/ivy.zip -d /tmp/ivy && \
    mkdir /tmp/ivy/data && \
    mkdir /tmp/ivy/logs && \
    mkdir /tmp/ivy/configuration/applications && \
    chmod -R g=u /tmp/ivy

FROM docker.io/eclipse-temurin:21-jre-noble
LABEL maintainer="Axon Ivy AG <info@axonivy.com>"

RUN usermod -l ivy ubuntu && \
    groupmod -n ivy ubuntu

ARG IVY_HOME=/ivy

COPY --from=build --chown=1000:0 /tmp/ivy ${IVY_HOME}

VOLUME [ "/ivy/data", "/ivy/configuration" ]

WORKDIR ${IVY_HOME}
USER 1000
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5m --retries=3 CMD curl -f http://localhost:8080/ || exit 1
ENTRYPOINT ["/ivy/bin/AxonIvyEngine"]
