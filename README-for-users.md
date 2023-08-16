# Instructions for developers

## deployment process
```sh
export CONTAINER_NAME=analytics
export CONTAINER_TAG=1.0.1
```
### check building of the docker file
```sh
docker build . -f Dockerfile --tag $CONTAINER_NAME:$CONTAINER_TAG
```

### check building of the docker file
```sh
docker run --entrypoint="" -it $CONTAINER_NAME:$CONTAINER_TAG  /bin/sh
```

## deploy changes 