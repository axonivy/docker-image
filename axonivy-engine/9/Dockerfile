FROM adoptopenjdk/openjdk11:debianslim-jre
LABEL maintainer="Axon Ivy AG <info@axonivy.com>" 

ARG IVY_ENGINE_DOWNLOAD_URL
ARG IVY_HOME=/usr/lib/axonivy-engine

RUN apt-get update && \
    apt-get install -y wget unzip && \
    useradd --uid 1000 --user-group --no-create-home ivy  && \
    wget ${IVY_ENGINE_DOWNLOAD_URL} -O /tmp/ivy.zip --no-verbose  && \
    unzip /tmp/ivy.zip -d ${IVY_HOME}  && \
    ln -s ${IVY_HOME}/configuration /etc/axonivy-engine && \
    ln -s ${IVY_HOME}/logs /var/log/axonivy-engine && \
    rm -f /tmp/ivy.zip && \
    rm -rf /var/lib/apt/lists/*

ADD --chown=ivy:ivy ./docker-entrypoint.sh ${IVY_HOME}/bin/docker-entrypoint.sh
RUN chmod u+x ${IVY_HOME}/bin/docker-entrypoint.sh 

WORKDIR ${IVY_HOME}
USER 1000
EXPOSE 8080
ENTRYPOINT ["/usr/lib/axonivy-engine/bin/docker-entrypoint.sh"]
