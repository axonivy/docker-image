FROM docker.io/eclipse-temurin:11-jre-focal
LABEL maintainer="Axon Ivy AG <info@axonivy.com>" 

ARG IVY_ENGINE_DOWNLOAD_URL
ARG IVY_HOME=/usr/lib/axonivy-engine

RUN apt-get update && \
    apt-get install -y wget unzip && \
    rm -rf /var/lib/apt/lists/* && \
\
    useradd --uid 1000 --user-group --no-create-home ivy && \
\
    wget ${IVY_ENGINE_DOWNLOAD_URL} -O /tmp/ivy.zip --no-verbose && \
    unzip /tmp/ivy.zip -d ${IVY_HOME} && \
    rm -f /tmp/ivy.zip && \
\
    mkdir ${IVY_HOME}/applications && \
    chown -R ivy:ivy ${IVY_HOME} && \
\
    mkdir /var/lib/axonivy-engine && \
    ln -s ${IVY_HOME}/applications /var/lib/axonivy-engine/applications && \
    ln -s ${IVY_HOME}/deploy /var/lib/axonivy-engine/deploy && \
    chown -R ivy:ivy /var/lib/axonivy-engine && \
    ln -s ${IVY_HOME}/configuration /etc/axonivy-engine && \
    ln -s ${IVY_HOME}/elasticsearch/config /etc/axonivy-engine/elasticsearch && \
    ln -s ${IVY_HOME}/logs /var/log/axonivy-engine && \
\
    # for backward compatibilty. we have used the debian package.
    mkdir /var/lib/axonivy-engine-8 && \
    ln -s ${IVY_HOME} /usr/lib/axonivy-engine-8 && \
    ln -s ${IVY_HOME}/applications /var/lib/axonivy-engine-8/applications && \
    chown -R ivy:ivy /var/lib/axonivy-engine-8 && \
    ln -s ${IVY_HOME}/deploy /var/lib/axonivy-engine-8/deploy && \
    ln -s ${IVY_HOME}/configuration /etc/axonivy-engine-8 && \
    #ln -s ${IVY_HOME}/elasticsearch/config /etc/axonivy-engine-8/elasticsearch && \
    ln -s ${IVY_HOME}/logs /var/log/axonivy-engine-8

ADD --chown=ivy:ivy ./docker-entrypoint.sh ${IVY_HOME}/bin/docker-entrypoint.sh
RUN chmod u+x ${IVY_HOME}/bin/docker-entrypoint.sh && \
\
    chgrp -R 0 ${IVY_HOME} && \
    chmod -R g=u ${IVY_HOME}

WORKDIR ${IVY_HOME}
USER 1000
EXPOSE 8080
ENTRYPOINT ["/usr/lib/axonivy-engine/bin/docker-entrypoint.sh"]
