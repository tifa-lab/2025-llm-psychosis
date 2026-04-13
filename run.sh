#!/bin/bash
set -e

LATEST_TAG=$(docker images --format '{{.Repository}}:{{.Tag}}' \
  | grep '^quay.io/tifalab/2025-llm-psychosis:20[0-9]\{6\}$' \
  | sed 's/.*://' \
  | sort -r \
  | head -n 1)

if [ -z "$LATEST_TAG" ]; then
  echo "No local image found. Run ./build.sh first."
  exit 1
fi

docker run --rm \
  --name llm-psychosis \
  -p 8888:8888 \
  -v "$(pwd)":/home/jovyan/work \
  quay.io/tifalab/2025-llm-psychosis:$LATEST_TAG \
  jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --IdentityProvider.token=''
