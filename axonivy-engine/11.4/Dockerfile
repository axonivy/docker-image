FROM docker.io/ubuntu:24.04 AS build

ARG IVY_ENGINE_DOWNLOAD_URL

ADD ${IVY_ENGINE_DOWNLOAD_URL} /tmp/ivy.zip
RUN apt-get update && \
    apt-get install -y unzip && \
    unzip /tmp/ivy.zip -d /tmp/ivy

FROM docker.io/eclipse-temurin:21-jre-noble
LABEL maintainer="Axon Ivy AG <info@axonivy.com>"

ARG IVY_HOME=/usr/lib/axonivy-engine

COPY --from=build /tmp/ivy ${IVY_HOME}

RUN usermod -l ivy ubuntu && \
    groupmod -n ivy ubuntu && \
\
    mkdir ${IVY_HOME}/applications && \
    mkdir ${IVY_HOME}/configuration/applications && \
    chown -R ivy:0 ${IVY_HOME} && \
\
    # that you can run the engine with an arbitrary users (group needs to have write access)
    chmod -R g=u ${IVY_HOME}

WORKDIR ${IVY_HOME}
USER 1000
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5m --retries=3 CMD curl -f http://localhost:8080/ || exit 1
ENTRYPOINT ["/usr/lib/axonivy-engine/bin/AxonIvyEngine"]
