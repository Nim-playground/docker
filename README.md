## Dockerfiles for the Nim playground

### building single images

Use the `NIMTAG` argument to specify which version of Nim to build.

```sh
# build Nim 2.0.2
podman build . -t playground-runner:v2.0.2 --build-arg NIMTAG=v2.0.2
```

```sh
# build Nim 1.0.0
podman build . -t playground-runner:v1.0.0 --build-arg NIMTAG=v1.0.0
```

### building all images

To build all tagged versions of Nim v1 and v2, use the `build_all.sh` script.

This fetches the tags from GitHub, builds them, and tags them `playground-runner:{version}`.
