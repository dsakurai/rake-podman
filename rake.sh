#!/usr/bin/env bash

set -e

# Update the container image
podman-compose build --pull

# Ensure that HOST_WORKDIR is set to the directory of this script
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export HOST_WORKDIR="$SCRIPT_PATH" # Will be passed to the container

podman-compose run --rm rake_service "$@"
