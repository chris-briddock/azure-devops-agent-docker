#!/bin/bash
set -e

# Start Docker daemon
dockerd &

# Wait for Docker to be ready
while ! docker info >/dev/null 2>&1; do
    echo "Waiting for Docker to be ready..."
    sleep 1
done

# Execute the command passed to the script
exec "$@"