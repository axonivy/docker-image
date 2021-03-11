# Changelog

## 2021-03-11

### Changed

- Axon Ivy Engine Docker image is no longer built on the Axon Ivy Engine Debian package.
  This change affects the following versions:
  - LTS 8.0: 8.0.15 and higher
  - Leading Edge 9: 9.1.1 and higher

- web.xml and context.xml not available in global configuration directory LTS 8.0 (8.0.15 and higher)
  - web.xml must be mounted /usr/lib/axonivy-engine/webapps/ivy/WEB-INF/web.xml
  - context.xml must be mounted /usr/lib/axonivy-engine/webapps/ivy/META-INF/context.xml
