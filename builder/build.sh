#!/bin/bash

export DOCKER_BUILDKIT=1

# Builder images are FROM meghsh/php:<version>, so the matching meghsh/php tag
# must already be pushed/available before these run.
docker buildx build --platform linux/amd64,linux/arm64 --build-arg PHP_VERSION=7.4 -t meghsh/builder:7.4 -f builder/Dockerfile builder --push
docker buildx build --platform linux/amd64,linux/arm64 --build-arg PHP_VERSION=8.0 -t meghsh/builder:8.0 -f builder/Dockerfile builder --push
docker buildx build --platform linux/amd64,linux/arm64 --build-arg PHP_VERSION=8.1 -t meghsh/builder:8.1 -f builder/Dockerfile builder --push
docker buildx build --platform linux/amd64,linux/arm64 --build-arg PHP_VERSION=8.2 -t meghsh/builder:8.2 -f builder/Dockerfile builder --push
docker buildx build --platform linux/amd64,linux/arm64 --build-arg PHP_VERSION=8.3 -t meghsh/builder:8.3 -f builder/Dockerfile builder --push
docker buildx build --platform linux/amd64,linux/arm64 --build-arg PHP_VERSION=8.4 -t meghsh/builder:8.4 -f builder/Dockerfile builder --push
docker buildx build --platform linux/amd64,linux/arm64 --build-arg PHP_VERSION=8.5 -t meghsh/builder:8.5 -f builder/Dockerfile builder --push
