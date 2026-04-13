#!/bin/bash
set -e

TAG=$(date +%Y%m%d)
export TAG

IMAGE="quay.io/tifalab/2025-llm-psychosis:$TAG"

if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^$IMAGE$"; then
    docker rmi "$IMAGE"
fi

docker-compose build --no-cache

docker tag "$IMAGE" quay.io/tifalab/2025-llm-psychosis:latest
