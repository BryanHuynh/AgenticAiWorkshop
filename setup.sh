#!/bin/bash

set -a
source .env
set +a

docker network create workshop-shared-network 2>/dev/null || true

cd database
docker-compose up -d
cd ..

cd model
docker-compose up -d
cd ..

echo "Waiting for Ollama to be ready..."
until docker exec ollama ollama list &> /dev/null; do
    sleep 2
done

echo "Pulling Ollama model: $MODEL"
docker exec ollama ollama pull $MODEL