FROM adoptopenjdk/openjdk11:debianslim-jre
LABEL maintainer="Axon Ivy AG <info@axonivy.com>" 

ARG IVY_ENGINE_DOWNLOAD_URL
ARG IVY_PACKAGE_NAME=axonivy-engine-9
ARG IVY_HOME=/usr/lib/axonivy-engine

RUN apt-get update && \
    apt-get install -y wget && \
\
    useradd --uid 1000 --user-group --no-create-home ivy && \
\
    wget ${IVY_ENGINE_DOWNLOAD_URL} -O /tmp/${IVY_PACKAGE_NAME}.deb --no-verbose && \
    dpkg --force-all -i /tmp/${IVY_PACKAGE_NAME}.deb && \
    ln -s /usr/lib/${IVY_PACKAGE_NAME} ${IVY_HOME} && \
    ln -s /var/lib/${IVY_PACKAGE_NAME} /var/lib/axonivy-engine && \
    ln -s /etc/${IVY_PACKAGE_NAME} /etc/axonivy-engine && \
    rm -f /tmp/${IVY_PACKAGE_NAME}.deb && \
\
    rm -rf /usr/share/doc/${IVY_PACKAGE_NAME} && \
    rm -rf /var/lib/apt/lists/*

ADD --chown=ivy:ivy ./docker-entrypoint.sh ${IVY_HOME}/bin/docker-entrypoint.sh
RUN chmod u+x ${IVY_HOME}/bin/docker-entrypoint.sh 

WORKDIR ${IVY_HOME}
USER 1000
EXPOSE 8080
ENTRYPOINT ["/usr/lib/axonivy-engine/bin/docker-entrypoint.sh"]
