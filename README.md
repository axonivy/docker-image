[![LTS][1]][0] [![Latest][2]][0] 
[![Sprint][3]][0] [![Nightly][4]][0] [![Dev][5]][0]

# Axon Ivy Engine Docker Image

Get an Axon Ivy Engine running with only one command:

    docker run -p 8080:8080 axonivy/axonivy-engine

Open your browser and go to <http://localhost:8080>

We have many [docker-samples](https://github.com/ivy-samples/docker-samples)
to see how Axon Ivy Engine can be used in a docker container.

## Changelog

See [changelog](CHANGELOG.md) for changes related to the Docker Image.

## Development

You can build the image locally with `build.sh`. This script will
build the Axon Ivy Engine Docker Image with a postfix of `-local`
in the image name e.g. `axonivy/axonivy-engine-local:dev`. 
The images won't be pushed to `docker.io` by default, only by
passing the param `--push`.

```bash
./build.sh dev
./build.sh 10.0
./build.sh 10.0.1
```

[0]: https://hub.docker.com/r/axonivy/axonivy-engine/tags
[1]: https://img.shields.io/badge/docker-8.0-green
[2]: https://img.shields.io/badge/docker-latest-yellowgreen
[3]: https://img.shields.io/badge/docker-sprint-yellow
[4]: https://img.shields.io/badge/docker-nightly-orange
[5]: https://img.shields.io/badge/docker-dev-red
