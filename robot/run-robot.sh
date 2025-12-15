#!/bin/bash

echo "Robot Simulator - Quick Start"
echo "================================="
echo ""

# Ensure test-mosquitto is running
if ! docker ps | grep -q test-mosquitto; then
    echo "Starting MQTT broker..."
    docker start test-mosquitto 2>/dev/null || \
    docker run -d \
      --name test-mosquitto \
      --network cloud_default \
      -v ~/transitive-dev/mosquitto-config:/mosquitto/config \
      -p 1884:1883 \
      -p 9002:9001 \
      eclipse-mosquitto:2 \
      mosquitto -c /mosquitto/config/mosquitto.conf
    sleep 2
fi

echo "MQTT broker ready"
echo ""

# Install packages if needed
if [ ! -d "node_modules" ]; then
    echo "Installing packages (first time)..."
    docker run --rm \
      --network cloud_default \
      -v $(pwd):/app \
      -w /app \
      node:18-alpine \
      npm install
    echo ""
fi

echo "Starting robot simulator..."
echo "Press Ctrl+C to stop"
echo ""

# Run robot (no interactive shell, just run node directly)
docker run -it --rm \
  --name robot-simulator \
  --network cloud_default \
  -v $(pwd):/app \
  -w /app \
  node:18-alpine \
  node index.js
