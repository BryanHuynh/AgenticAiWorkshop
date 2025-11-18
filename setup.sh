#!/bin/bash

set -a
source .env
set +a

USE_GPU="${NVIDIA_GPU_ENABLED:-false}"

docker network create workshop-shared-network 2>/dev/null || true

cd database
docker-compose up -d
cd ..

cd model
if [ "$USE_GPU" = "true" ]; then
  echo "Starting model services with GPU configuration (docker-compose.gpu.yml)..."
  docker-compose -f docker-compose.yml -f docker-compose.gpu.yml up -d
else
  echo "Starting model services without GPU (CPU only)..."
  docker-compose up -d
fi
cd ..